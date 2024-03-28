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

# chunk:  -----

