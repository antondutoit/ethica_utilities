# Title:    Ethica_utilities_source
# Purpose:  Container for Ethica_utilities functions and 

# chunk: constants and patterns for regex - will go into source file -----
sortvec <- c("participant_id", "participant_label", "participant_status", 
             #     "obs_id", 
             "uuid", 
             "session_scheduled_time", "participant_start_time", "participant_end_time", "prompt_time", "record_time", "expiry_time",
             "duration_seconds_from_scheduled_to_completion_time", "duration_seconds_from_first_response_to_completion_time",
             "device_id", "device_manufacturer", "device_model", "device_last_used", "device_app_version", "device_app_update_date",
             "unanswered_status", "activity_version", "status", "triggering_logic_id", "triggering_logic_type", 
             "location", "n_miss_all")

q_type_exts <- c("saq", "maq", "num", "vas", "fft")

# extract Study number  
pattern1   <- "activity_response_" %R% repeated(DGT,4,5)          # extracts the *Study* no., not the activity no.
pattern1.1 <- "activity_response_" %R% repeated(DGT,4,5) %R% "_"  # used to remove unwanted chars from Study no.

# detect unwanted columns (to be removed)
pattern2 <- "_" %R% repeated("[a-z]", lo = 3, hi = 3) %R% "_question_" %R% "[0-9]"  
pattern2.1 <- DGT %R% optional(DGT) %R% "_maq_metadata_question_"

# extract activity number; this expression will extract 5- to 6-digit activity numbers.
pattern3 <- "activity_response_" %R% repeated(DGT,4,5) %R% "_" %R% repeated(DGT,5,6) %R% "_"  # extracts activity no.(+)
pattern3.1 <- "activity_response_" %R% repeated(DGT,4,5) %R% "_"                              # to remove unwanted chars

# extract numeric answer code to rewrite answer columns
pattern4 <- "\\{\"answer_id" %R% repeated(not_dgt(), lo = 2, hi = 28) %R% capture(DGT) %R% capture(optional(DGT)) %R% one_or_more(printable())

# extract question numbers  
pattern5 <- START %R% "x" %R% capture(repeated(DGT,0,2)) %R% "_" %R% repeated("[a-z]", lo = 3, hi = 3) %R% "_" %R% repeated(not_dgt(), lo = 0, hi = 18) %R% capture(repeated(DGT,0,2)) %R% one_or_more(printable())
pattern5.1 <- START %R% "x" %R% DGT %R% optional(DGT)   # 

# extract activity no. from df_name
pattern6 <- "_" %R% repeated(DGT, 5, 6) %R% "_df"   

# extract question type (SAQ, NUM, VAS, etc)
pattern7 <- START %R% "x" %R% repeated(DGT,1,2) %R% "_" %R% repeated("[a-z]",3,3) %R% "_" 
pattern7.1 <- repeated("[a-z]",3,3)    # used to acquire only the desired chars without surrounding chars

# extract MAQ option no.  
pattern8 <- "_maq_" %R% DGT %R% optional(DGT)

# chunk: Create: functions for use in rest of script - will go into source file -----
number_extract_single2 <- function(x) {
  as.numeric(str_replace(x, pattern = pattern4, replacement = REF1))
}

mk <- function(x) {
  kable(x) %>%kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed"))
}

# Functions  -----
# 1. Was: {r Create: functions for data frame naming, warning=FALSE, message=FALSE}
import_CSV <<- function() {
  # Load and rename CSV files 
  file_names <<- Sys.glob(paste0(data_path, "/*.csv"))
  
  # Set up empty objects 
  df_names <<- data.frame()
  activity_numbers <<- vector()
  df_list <<- list()
  
  # extract study number
  study_number <<- str_extract(file_names[1], pattern = pattern1)
  study_number <<- study_number %>% str_remove_all("activity_response_")
  
  # Create data frame names from file_names and read in data from CSV files 
  i <- 0   
  for (file_name in file_names) {
    i <- i + 1
    # extract activity number
    activity_numbers[i] <<- str_extract(file_name, pattern = pattern3 )
    activity_numbers[i] <<- activity_numbers[i] %>% str_remove_all(pattern3.1) %>% str_remove_all("_")
    
    # Generate df names from CSV file names
    df_name <<- paste0("S", study_number, "_", activity_numbers[i], "_df", collapse = NULL)
    
    df_names <<- c(df_names, df_name)
    df_names <<- as.vector(df_names, mode = "character")
    
    # read in CSV files   
    df_list[[df_name]] <<- read_csv(file_name, col_names = TRUE, na = c("", "NA"))
    
    # how to make all these objects available in the env ?
    # return(list(obj1, obj2))
  }
}

# 2. Was: {r Create:   functions to clean column names, detect and remove columns with answer labels}
clean_all_names <<- function() {
  for (df_name in df_names)  {
    df_list[[df_name]] <<- df_list[[df_name]] %>% janitor::clean_names()
  }
}

# 3. Was: {r Create:   functions to clean column names, detect and remove columns with answer labels}
remove_answ_cols <<- function() {
  for (df_name in df_names)  {
    df_list[[df_name]] <<- df_list[[df_name]] %>% select(!matches(pattern2))
    df_list[[df_name]] <<- df_list[[df_name]] %>% select(!matches(pattern2.1))
  }
}

# 4. Was: {r Fix:    extract numeric answer codes and rewrite 'metadata' answer columns}
extract_saq_numbers <- function() {
  for (df_name in df_names)  {
    df_list[[df_name]] <<- df_list[[df_name]] %>% mutate(across(contains("_metadata_"), number_extract_single2))
  }
}

# 5. Was: {r Fix:    rename answer columns}
rename_answ_cols <- function() {
  i <- 0
  for (df_name in df_names)  {
    i <- i + 1
    
    column_names <<- colnames(df_list[[df_name]])
    logV <<- str_detect(column_names, pattern = pattern5)
    activity_no <<- str_extract(df_name, pattern = pattern6) %>% str_remove_all("df") %>% str_remove_all("_")
    
    raw_question_numbers_int <<- str_extract(column_names[logV], pattern = pattern5)
    raw_question_numbers <<- str_extract(raw_question_numbers_int, pattern = pattern5.1)
    raw_question_numbers <<-  raw_question_numbers %>% str_remove("x")
    
    # extract 3 letter code for question type
    question_type_int <<- str_extract(column_names[logV], pattern = pattern7)    
    question_type <<- str_extract(question_type_int, pattern = pattern7.1)
    
    maqV <<- str_detect(column_names[logV], pattern = "_maq_")
    
    if (sum(maqV)>0) {
      maq_option_no <<- str_extract(column_names[logV], pattern =  pattern8) %>% str_remove("_maq") %>% str_remove("_") %>%  str_replace_na(replacement = "NA") %>% str_replace("NA", "") 
      maq_option_no <<- maq_option_no %>%  str_replace_all(capture(repeated(DGT,1,2)), "_opt" %R% REF1)
      question_numbers <<- str_c("a", activity_no, "_", "q", raw_question_numbers, "_", question_type, maq_option_no, sep = "")  
    }
    
    if (sum(maqV)==0) {
      question_numbers <<- str_c("a", activity_no, "_", "q", raw_question_numbers, "_", question_type, sep = "")  
    }
    
    column_names[logV] <<- question_numbers
    colnames(df_list[[df_name]]) <<- column_names   
  }   
}

# 6. Was: {r create:  function to add a column with number of missing values in that row}
add_all_msg_cols <- function() {
  for (df_name in df_names)  {
    df_list[[df_name]] <<- df_list[[df_name]] %>% naniar::add_n_miss()  
  }
}

# 7. Was: {r create:  arrange by answer dttm and add a column with ordinal no of observation}
add_all_obs.no_cols <- function() {
  for (df_name in df_names)  {
    df_list[[df_name]] <<- df_list[[df_name]] %>% arrange(record_time)
    activity_no <<- str_extract(df_name, pattern = pattern6) %>% str_remove_all("df") %>% str_remove_all("_")
    new.var <<- paste("obs", activity_no, sep = "." )
    assign(new.var, 1:nrow(df_list[[df_name]]))
    df_list[[df_name]] <<- df_list[[df_name]] %>% mutate("obs.{activity_no}" := eval(sym(new.var)), .before = uuid)
  }
}

# 8. Was: {r Create: function to change some var classes}
change_some_classes <- function() {
  for (df_name in df_names)  {
    df_list[[df_name]] <<- df_list[[df_name]] %>% select(all_of(sortvec), starts_with("obs."), everything())
    
    df_list[[df_name]] <<- df_list[[df_name]] %>% 
      mutate(participant_id = as.integer(participant_id)) %>%
      mutate(participant_status = as.integer(participant_status)) %>%
      mutate(status = as.integer(status)) %>%
      mutate(triggering_logic_id = as.integer(triggering_logic_id)) %>%
      mutate(triggering_logic_type = as.integer(triggering_logic_type))
  }
}

# 9. Create a combined df and re-order its columns  
create_combined_df <- function() {
  combined_df <<- bind_rows(df_list, .id = "original_df")   
  
  combined_df <<- combined_df %>% select(all_of(sortvec), starts_with("obs."), everything()) %>%
    relocate(c(starts_with("obs"), original_df), .before = uuid)
}


# 10. Was: ```{r Create: extract data frames from list if needed}
extract_all_df <- function() {
list2env(df_list, .GlobalEnv)
}

# . Was: 

