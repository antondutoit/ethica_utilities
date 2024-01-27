# Title: Ethica output cleaning and variable renaming

# Frontmatter instructions and notes
# This script processes CSV files as output from Ethica. xxx ....

# To use this script with your data files: 
#   - change the file path on line 57 to point at the folder with your data files. 
#   - The files must be in CSV format. 
# The script will output a dataframe for each CSV file; dataframes will be named Survey.Number_df. The dataframe will have clean numerical output for single-answer questions, and also will have all variables renamed as Survey.Number_Question.Number_Question.Type. 
# If you want a CSV file outputted as well, you may un-comment the write.csv() call at the end of this file and add in the appropriate file path. 

# Load libraries ----
library("rebus")
# library("data.table")
library("tidyverse")

# Define functions ----
number_extract_single <- function(x) {
  as.numeric(str_replace(x, 
                         pattern = "\\(ID " %R% 
                           capture(DGT) %R% 
                           capture(optional(DGT)) %R% 
                           "\\) " %R% 
                           one_or_more(char_class("a-z","A-Z","0-9"," ")), 
                         replacement = REF1))
  }

number_extract_multiple <- function(x) {
  as.numeric(str_replace(x, 
                         pattern = one_or_more("\\(ID " %R% capture(DGT) %R% 
                                                 capture(optional(DGT)) %R% "\\) " %R%
                                                 one_or_more(char_class("a-z","A-Z","0-9", " "))),
                         replacement = REF1 %R% REF2 %R% REF3 %R% REF4))
  }

# Function to create column with count of NAs  
      # redundant - can use a fun from naniar:: or maybe tidyr::, so replace 
countRowNAs <- function(x) { sum(is.na(x)) }

count_NA <- function(data) {
  apply(data, 1, countRowNAs)
  }


# Load and rename .csv files ----
file_names <- Sys.glob("C:/your/file/path/something/like/files_to_process/*.csv")
df_names <- data.frame()

# Set up empty objects 
survey_numbers <- vector()
df_list <- list()

# Create data frame names from file_names and read in data from CSV files ----
i <- 0

for (file_name in file_names) {
  i <- i + 1
# Extract survey number; this expression will extract 3- to 5-digit survey numbers.
  survey_numbers[i] <- str_extract(file_name, 
                                 DGT %R% DGT %R% DGT %R% optional(DGT) %R% optional(DGT)) 
# Generate df names from csv file names
  df_name <- paste(survey_numbers[i], sep = "_", "df", collapse = NULL)

  df_names <- c(df_names, df_name)
  df_names <- as.vector(df_names, mode = "character")

  df_list[[df_name]] <- read_csv(file_name, col_names = TRUE, na = "NA")
  }

# Rename columns ----
# (LogV lets us skip over the first four column_names: Name, Date, Duration (minutes), Location.)

i <- 0
length(df_names)
for (df_name in df_names)  {
  i <- i + 1
  column_names <- colnames(df_list[[df_name]])
  logV <- str_detect(column_names, pattern = START %R% ANY_CHAR %R% DGT %R% optional(DGT))
# Extracts a vector of question numbers. The expression allows for up to 999 questions in a Survey.  # This is done with START %R% ANY_CHAR %R% DGT, etc because column names could have other digits after those at the start.
  raw_question_numbers_intermediate <- str_extract(column_names[logV], 
        pattern = START %R% ANY_CHAR %R% DGT %R% optional(DGT) %R% optional(DGT))
  raw_question_numbers <- str_extract(raw_question_numbers_intermediate, 
                                      pattern = DGT %R% optional(DGT) %R% optional(DGT))
  
# extract 3 letter code for question type from CSV file column header
  question_type <- str_extract(column_names[logV], 
                               pattern = "_" %R% char_class("A-Z") %R% 
                                 char_class("A-Z") %R% char_class("A-Z"))
  
# Put Survey number at start of question number, to get complete number as per Ethica convention. 
  question_numbers_intermediate <- str_c(survey_numbers[i], raw_question_numbers, sep = "_Q")
  question_numbers <- str_c(question_numbers_intermediate, question_type)
  
  column_names[logV] <- question_numbers
  colnames(df_list[[df_name]]) <- column_names
   }

# Clean single answer column data ----
for (df_name in df_names)  { 
  df_temp <- df_list[[df_name]] %>% mutate(across(where(contains("SAQ"))), number_extract_single)
  df_list[[df_name]] <- df_temp
  }

# Un-comment and add file path if a CSV file is required. NB Keep this function call at the end of the script, 
# write.csv(pathways_df, file = "C:/your/file/path/something/like/output_files/your_filename.csv")
