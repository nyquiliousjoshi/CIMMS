############################################################
# CIMMS — Problem Set 0 (ANSWER KEY)
# Author: Nikhil Joshi
#
# Notes:
# - Replace the example `age` and `name` with your own if desired.
############################################################


############################
# PART 1 — Variables & Types
############################

# Q1) Create a numeric variable called `age` and set it to your age.
age <- 24

# Q2) Create a character variable called `name` and set it to your first name.
name <- "Nikhil"

# Q3) Create a logical variable called `is_med_student` and set it to TRUE.
is_med_student <- TRUE

# Q4) Print each variable to the console.
age
name
is_med_student

# Q5) Use class() to check the type of each variable.
class(age)
class(name)
class(is_med_student)


#################################
# PART 2 — Vectors (Measurements)
#################################

# Q6) Create a numeric vector `scores` with values: 88, 92, 76, 81, 95.
scores <- c(88, 92, 76, 81, 95)

# Q7) Compute mean, median, min, max, and SD of `scores`.
mean(scores)
median(scores)
min(scores)
max(scores)
sd(scores)

# Q8) Identify which scores are >= 90.
# Create a logical vector called `high_scores`.
high_scores <- scores >= 90
high_scores

# Q9) Use `high_scores` to print only scores >= 90.
scores[high_scores]


############################
# PART 3 — Factors (Groups)
############################

# Q10) Create a vector `group`:
# "control", "treatment", "control", "control", "treatment"
group <- c("control", "treatment", "control", "control", "treatment")

# Q11) Convert `group` to a factor called `group_f`.
group_f <- factor(group)

# Q12) Print levels and counts of each group.
levels(group_f)
table(group_f)


############################
# PART 4 — Lists (Patients)
############################

# Q13) Create a list `patient1` with:
# - name
# - age
# - group
# - scores
patient1 <- list(
  name = name,
  age = age,
  group = group_f,   # first patient's group (from the earlier vector)
  scores = scores
)

# Q14) Access the patient’s age and highest score.
patient1$age
max(patient1$scores)


################################
# PART 5 — Data Frames (Cohorts)
################################

# Q15) Create a data frame `df` with:
# id: 1–6
# group: control / treatment
# age: 24, 31, 27, 29, 35, 22
# biomarker: 1.2, 0.8, 1.9, 2.2, 1.0, 1.6
df <- data.frame(
  id = 1:6,
  group = c("control", "treatment", "control", "control", "treatment", "treatment"),
  age = c(24, 31, 27, 29, 35, 22),
  biomarker = c(1.2, 0.8, 1.9, 2.2, 1.0, 1.6)
)

# Q16) Inspect the dataset (head, dim, summary).
head(df)
dim(df)
summary(df)

# Q17) Subset only treatment patients into `df_trt`.
df_trt <- df[df$group == "treatment", ]
df_trt


############################
# PART 6 — Conditionals
############################

# Q18) Write an if/else statement that labels a patient
# as "adult" or "minor" based on age.
#
# Example using a single age value:
patient_age <- 17
if (patient_age >= 18) {
  label <- "adult"
} else {
  label <- "minor"
}
label

# (Optional) Vectorized version for an entire column:
df$age_label <- ifelse(df$age >= 18, "adult", "minor")
df


############################
# PART 7 — For Loops
############################

# Q19) Create a vector `squared` where element i = i^2 for i = 1 to 10.
# Use a for-loop.
squared <- numeric(10)  # pre-allocate for speed/clarity
for (i in 1:10) {
  squared[i] <- i^2
}
squared

# Q20) Loop through `scores` and print each value.
for (s in scores) {
  print(s)
}


############################
# PART 8 — Applied Mini-Challenge
############################

# Q21) Add a new column `risk` to df:
# "high" if biomarker >= 1.5, else "low"
# Use a for-loop.
df$risk <- character(nrow(df))  # pre-allocate
for (i in 1:nrow(df)) {
  if (df$biomarker[i] >= 1.5) {
    df$risk[i] <- "high"
  } else {
    df$risk[i] <- "low"
  }
}
df

# Q22) Create a frequency table of risk by group.
table(df$risk, df$group)

# Nicer display with margins:
addmargins(table(df$risk, df$group))

