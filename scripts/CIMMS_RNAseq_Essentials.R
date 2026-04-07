# RNA-seq CIMMS Data Loading
# 04072026

install_and_load <- function(cran = character(), bioc = character()) {
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
  }
  
  missing_cran <- cran[!sapply(cran, requireNamespace, quietly = TRUE)]
  if (length(missing_cran) > 0) {
    install.packages(missing_cran)
  }
  
  missing_bioc <- bioc[!sapply(bioc, requireNamespace, quietly = TRUE)]
  if (length(missing_bioc) > 0) {
    BiocManager::install(missing_bioc, ask = FALSE, update = FALSE)
  }
  
  invisible(lapply(c(cran, bioc), library, character.only = TRUE))
}

install_and_load(
  cran = c(
    "tidyverse", "RColorBrewer", "reshape2", "matrixStats",
    "hrbrthemes", "gt", "DT", "plotly"
  ),
  bioc = c(
    "tximport", "biomaRt", "genefilter", "edgeR", "limma"
  )
)

library(tidyverse) # provides access to Hadley Wickham's collection of R packages for data science, which we will use throughout the course
library(tximport) # package for getting Kallisto results into R
library(biomaRt) # provides access to a wealth of annotation info
library(RColorBrewer) 
library(reshape2) 
library(genefilter)
library(matrixStats)
library(hrbrthemes) 
library(tidyverse)
library(limma) #powerful package for differential gene expression using linear modeling
library(edgeR) #another great package for differential gene expression analysis
library(gt)
library(DT) #creates interactive datatables
library(hrbrthemes)
library(plotly)

# IF NOT DOWNLOADING ASK GPT!

targets <- read_tsv("../../studyDesign.txt")# read in your study design
path <- file.path("../readMapping", targets$sample, "abundance.h5") # set file paths to your mapped data
targets <- mutate(targets, path) # add paths to your study design (only necessary for Sleuth)
Hs.anno <- useMart(biomart="ENSEMBL_MART_ENSEMBL", dataset = "hsapiens_gene_ensembl") # select 'mart' from biomaRt for annotations
Tx <- getBM(attributes=c('ensembl_transcript_id_version', # get gene symbols for each transcript ID
                         'external_gene_name'),
            mart = Hs.anno)
Tx <- as_tibble(Tx) # convert this annotation mapping file to a tibble (the tidyverse version of a dataframe)
Txi_gene <- tximport(path, #reading kallisto data into R
                     type = "kallisto", 
                     tx2gene = Tx, 
                     txOut = FALSE, 
                     countsFromAbundance = "lengthScaledTPM") # create a length scaled, library scaled value
myCPM <- as_tibble(Txi_gene$abundance, rownames = "geneSymbol") # these are you counts after adjusting for transcript length
myCounts <- as_tibble(Txi_gene$counts, rownames = "geneSymbol") # these are your transcript per million (TPM) values, or counts per million (CPM) if you collapsed data to gene level

groups1 <- targets$treatment
groups1 <- factor(groups1)
sampleLabels <- targets$sample
myDGEList <- DGEList(Txi_gene$counts)
save(myDGEList, file = "myDGEList")
load(file = "myDGEList")
log2.cpm <- cpm(myDGEList, log=TRUE)
nsamples <- ncol(log2.cpm)
myColors <- brewer.pal(nsamples, "Paired")
log2.cpm.df <- as_tibble(log2.cpm)
colnames(log2.cpm.df) <- sampleLabels
log2.cpm.df.melt <- melt(log2.cpm.df)

ggplot(log2.cpm.df.melt, aes(x=variable, y=value, fill=variable)) +
  geom_violin(trim = FALSE, show.legend = FALSE) +
  stat_summary(fun.y = "median", geom = "point", shape = 124, size = 6, color = "black", show.legend = FALSE) +
  labs(y="log2 expression", x = "sample",
       title="Log2 Counts per Million (CPM)",
       subtitle="unfiltered, non-normalized",
       caption=paste0("produced on ", Sys.time())) +
  coord_flip() +
  theme_ipsum_rc() 

table(rowSums(myDGEList$counts==0)==9)
cpm <- cpm(myDGEList)
keepers <- rowSums(cpm>1)>=3 #user defined
myDGEList.filtered <- myDGEList[keepers,]
myDGEList.filtered.norm <- calcNormFactors(myDGEList.filtered, method = "TMM")
log2.cpm.filtered.norm <- cpm(myDGEList.filtered.norm, log=TRUE)
log2.cpm.filtered.norm.df <- as_tibble(log2.cpm.filtered.norm)
colnames(log2.cpm.filtered.norm.df) <- sampleLabels
log2.cpm.filtered.norm.df.melt <- melt(log2.cpm.filtered.norm.df)

ggplot(log2.cpm.filtered.norm.df.melt, aes(x=variable, y=value, fill=variable)) +
  geom_violin(trim = FALSE, show.legend = FALSE) +
  stat_summary(fun.y = "median", geom = "point", shape = 124, size = 6, color = "black", show.legend = FALSE) +
  labs(y="log2 expression", x = "sample",
       title="Log2 Counts per Million (CPM)",
       subtitle="filtered, TMM normalized",
       caption=paste0("produced on ", Sys.time())) +
  coord_flip() +
  theme_ipsum_rc() 

design <- model.matrix(~0 + groups1)
colnames(design) <- levels(groups1)
v.DEGList.filtered.norm <- voom(myDGEList.filtered.norm, design, plot = FALSE)
fit <- lmFit(v.DEGList.filtered.norm, design)
contrast.matrix <- makeContrasts(infection_with_WT = crypto.wt - uninfected,
                                 infection_with_Mut = crypto.mut - uninfected,
                                 levels=design)

fits <- contrasts.fit(fit, contrast.matrix)
ebFit <- eBayes(fits)
myTopHits <- topTable(ebFit, adjust ="BH", coef=1, number=40000, sort.by="logFC")
myTopHits <- as_tibble(myTopHits, rownames = "geneSymbol")
ggplotly(ggplot(myTopHits, aes(y=-log10(adj.P.Val), x=logFC, text = paste("Symbol:", geneSymbol))) +
           geom_point(size=2) +
           ylim(-0.5,12) +
           geom_hline(yintercept = -log10(0.01), linetype="longdash", colour="grey", size=1) +
           geom_vline(xintercept = 1, linetype="longdash", colour="#BE684D", size=1) +
           geom_vline(xintercept = -1, linetype="longdash", colour="#2C467A", size=1) +
           labs(title="Volcano plot",
                subtitle = "C. parvum infected vs. naive (HCT-8 cells)",
                caption=paste0("produced on ", Sys.time())) +
           theme_ipsum_rc())

results <- decideTests(ebFit, method="global", adjust.method="BH", p.value=0.01, lfc=2)
colnames(v.DEGList.filtered.norm$E) <- sampleLabels
diffGenes <- v.DEGList.filtered.norm$E[results[,1] !=0 | results[,2] !=0,]
diffGenes.df <- as_tibble(diffGenes, rownames = "geneSymbol")
datatable(diffGenes.df, 
          extensions = c('KeyTable', "FixedHeader"), 
          caption = 'Table 1: DEGs for infected (wt Crypto) vs control',
          options = list(keys = TRUE, searchHighlight = TRUE, pageLength = 10, lengthMenu = c("10", "25", "50", "100"))) %>%
  formatRound(columns=c(1:10), digits=2)

