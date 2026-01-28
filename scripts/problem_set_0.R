############################################################
# R Lunch Series — Problem Set 0
# Coding Basics for Medical Students
#
# HOW TO USE THIS FILE:
# 1. Read each QUESTION (commented with #).
# 2. Write your code directly BELOW each question.
# 3. Run code often. Errors are expected — that’s how you learn.
############################################################


############################
# PART 1 — Variables & Types
############################

# Q1) Create a numeric variable called `age` and set it to your age.
# YOUR CODE HERE


# Q2) Create a character variable called `name` and set it to your first name.
# YOUR CODE HERE


# Q3) Create a logical variable called `is_med_student` and set it to TRUE.
# YOUR CODE HERE

# Q4) Print each variable to the console.
# YOUR CODE HERE


# Q5) Use class() to check the type of each variable.
# YOUR CODE HERE


#################################
# PART 2 — Vectors (Measurements)
#################################

# Imagine these are exam scores or lab values.

# Q6) Create a numeric vector `scores` with values: 88, 92, 76, 81, 95.
# YOUR CODE HERE

# Q7) Compute mean, median, min, max, and SD of `scores`.
# YOUR CODE HERE


# Q8) Identify which scores are >= 90.
# Create a logical vector called `high_scores`.
# YOUR CODE HERE

# Q9) Use `high_scores` to print only scores >= 90.
# YOUR CODE HERE

############################
# PART 3 — Factors (Groups)
############################

# Think: treatment vs control.

# Q10) Create a vector `group`:
# "control", "treatment", "control", "control", "treatment"
# YOUR CODE HERE

# Q11) Convert `group` to a factor called `group_f`.
# YOUR CODE HERE

# Q12) Print levels and counts of each group.
# YOUR CODE HERE


############################
# PART 4 — Lists (Patients)
############################

# Q13) Create a list `patient1` with:
# - name
# - age
# - group
# - scores
# YOUR CODE HERE

# Q14) Access the patient’s age and highest score.
# YOUR CODE HERE


################################
# PART 5 — Data Frames (Cohorts)
################################

# Q15) Create a data frame `df` with:
# id: 1–6
# group: control / treatment
# age: 24, 31, 27, 29, 35, 22
# biomarker: 1.2, 0.8, 1.9, 2.2, 1.0, 1.6
# YOUR CODE HERE

# Q16) Inspect the dataset (head, dim, summary).
# YOUR CODE HERE

# Q17) Subset only treatment patients into `df_trt`.
# YOUR CODE HERE


############################
# PART 6 — Conditionals
############################

# Q18) Write an if/else statement that labels a patient
# as "adult" or "minor" based on age.
# YOUR CODE HERE


############################
# PART 7 — For Loops
############################

# Q19) Create a vector `squared` where element i = i^2 for i = 1 to 10.
# Use a for-loop.
# YOUR CODE HERE

# Q20) Loop through `scores` and print each value.
# YOUR CODE HERE


############################
# PART 8 — Applied Mini-Challenge
############################

# Q21) Add a new column `risk` to df:
# "high" if biomarker >= 1.5, else "low"
# Use a for-loop.
# YOUR CODE HERE


# Q22) Create a frequency table of risk by group.
# YOUR CODE HERE


############################
# END OF PROBLEM SET
############################
