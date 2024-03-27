
# ```{r Deprecated}
# # testing
# x1 <- (df_list[[1]][[1,3]])
# number_extract_single2((df_list[[1]][[1,3]]))

# # more testing
# str_detect(x1, pattern = "{\"answer_id\":" %R% capture(DGT))  # TRUE 
# str_detect(x1, pattern = "\"answer_id\":" %R% capture(DGT) %R% one_or_more(printable()))  # TRUE

# # testing
# x1 <- "x1_saq_question_1_of_survey_1197"
# str_detect(x1, pattern2)
# str_extract(x1, pattern2)

# x2 <- "x1_saq_metadata_question_1_of_survey_1197"  
# str_detect(x2, pattern2)  # FALSE - good 

# target column name: S3735_s20908_q1 OR s20908_q1
# x2 <- "x1_saq_metadata_question_1_of_survey_1197"  
# pattern3 <- "_" %R% repeated("[a-z]", lo = 3, hi = 3) %R% "_metadata_question_" %R% capture(DGT) %R% 
#   repeated(capture(optional(DGT)),0,2) %R% "_of_survey_" %R% capture(DGT) %R%
#   repeated(capture(optional(DGT)),0,5)

# more test
# x6 <- "a,b\""
# pattern2 <- "_" %R% repeated("[a-z]", lo = 3, hi = 3) %R% "_question_" %R% "[0-9]"
# pattern_test <- repeated(not_dgt(), lo = 3, hi = 5)
# 
# str_detect(x6, pattern_test)

# # functions from pw_new2.10
# number_extract_single <- function(x) {
#   as.numeric(str_replace(x, 
#                          pattern = "\\(ID " %R% 
#                            capture(DGT) %R% 
#                            capture(optional(DGT)) %R% 
#                            "\\) " %R% 
#                            one_or_more(char_class("a-z","A-Z","0-9"," ")), 
#                          replacement = REF1))
#   }
# 
# number_extract_multiple <- function(x) {
#   as.numeric(str_replace(x, 
#                          pattern = one_or_more("\\(ID " %R% capture(DGT) %R% 
#                                                  capture(optional(DGT)) %R% "\\) " %R%
#                                                  one_or_more(char_class("a-z","A-Z","0-9", " "))),
#                          replacement = REF1 %R% REF2 %R% REF3 %R% REF4))
#   }


# # test
# x4 <- "{\"answer_id\":null,\"answer_content\":\"7\",\"answer_location\":{\"latitude\":null,\"longitude\":null,\"accuracy\":null,\"speed\":null},\"answer_response_time\":\"2024-02-19T03:35:15.692000+00:00\",\"answer_question_content\":\"In general how much of the time do you feel you are making progress towards accomplishing your goals?\\n(If your answer is zero you still have to move the slider back and forth so it knows you are not skipping the question.)\\n0 = Never\\n10 = Always\",\"answer_media_interactions\":[],\"unanswered_status_id\":null}"
# 
# str_detect(x4, pattern4)  #   
# 
# x5 <- "{\"answer_id\":2,\"answer_content\":\"A little of the time\",\"answer_location\":{\"latitude\":null,\"longitude\":null,\"accuracy\":null,\"speed\":null},\"answer_response_time\":\"2024-02-19T03:03:37.484000+00:00\",\"answer_question_content\":\"In the last four weeks about how often ...\\n\\n1. Did you feel tired out for no good reason?\",\"answer_media_interactions\":[],\"unanswered_status_id\":null}"
# 
# str_detect(x5, pattern4)  #  


# # create function to extract numerical data from 'metadata' column 
# pattern1 <- "\\{\"answer_id\":" %R% capture(DGT) %R% capture(optional(DGT)) %R% one_or_more(printable())
# 
# pattern1.1 <-  "\\{\"answer_id\":null,\"answer_content\":\"" %R% capture(DGT) %R% capture(optional(DGT)) %R% one_or_more(printable())
# 
# # rewrite pattern 1 for VAS and other question types 
# pattern1.2 <- group(or1(c(pattern1.1, pattern1), capture = TRUE))

# # # R chunk # # Clean single answer column data ----
# for (df_name in df_names)  { 
#   df_temp <- df_list[[df_name]] %>% mutate(across(where(contains("SAQ"))), number_extract_single)
#   df_list[[df_name]] <- df_temp
#   }
# 
# # Output from this chunk is df_list, a list of data frames with regularised variable names 

# pattern3.1 <- "_" %R% repeated("[a-z]", lo = 3, hi = 3) %R% "_metadata_question_" %R% capture(DGT) %R% #   repeated(capture(optional(DGT)),0,2) %R% "_of_survey_" %R% (DGT) %R%
#   repeated(optional(DGT),0,5)


# ***********

# ```

# ```{r Test:    try to rewrite col name regex to include MAQ questions, eval=FALSE}
# # current regex
# pattern3.1 <- "_" %R% repeated("[a-z]", lo = 3, hi = 3) %R% "_metadata_question_" %R% capture(DGT) %R%
#   repeated(capture(optional(DGT)),0,2) %R% "_of_survey_" %R% (DGT) %R%
#   repeated(optional(DGT),0,5)
# 
# # sample non-MAQ and MAQ col names
# nonmaq <- "x2_saq_metadata_question_2_of_survey_1197"
#    maq <- "x10_maq_2_any_meat"
# 
# str_detect(nonmaq, pattern3.1)    # TRUE
# str_detect(maq, pattern3.1)       # FALSE
# 
# # new regex for MAQ only
# pattern3.2 <- START %R% "x" %R% capture(repeated(DGT,1,2)) %R% "_" %R% repeated("[a-z]", lo = 3, hi = 3) %R% "_" %R% capture(repeated(DGT,1,2)) %R% one_or_more(printable())
# 
# str_detect(nonmaq, pattern3.2)    # FALSE
# str_detect(maq, pattern3.2)       # TRUE
# 
# str_replace(nonmaq, pattern = pattern3.2, replacement = REF1 %R% "_" %R% REF2)
#                                                         # "x2_saq_metadata_question_2_of_survey_1197"
# str_replace(maq, pattern = pattern3.2, replacement = REF1 %R% "_" %R% REF2)      # "10_2"
# 
# # attempt regex for MAQ _and_ SAQ, VAS, etc
# pattern3.3 <- START %R% "x" %R% capture(repeated(DGT,0,2)) %R% "_" %R% repeated("[a-z]", lo = 3, hi = 3) %R% "_" %R% repeated(not_dgt(), lo = 0, hi = 18) %R% capture(repeated(DGT,0,2)) %R% one_or_more(printable())
# 
# str_detect(nonmaq, pattern3.3)    # TRUE
# str_detect(maq, pattern3.3)       # TRUE
# 
# str_replace(nonmaq, pattern3.3, replacement = REF1 %R% "_" %R% REF2)        # s/be "2_2"   # "2_2"
# str_replace(maq, pattern = pattern3.3, replacement = REF1 %R% "_" %R% REF2) # s/be "10_2"  # "10_2"

# ```

```{r Create: functions for output cleaning}
# # Function to create column with count of NAs     # redundant- can use a fun from naniar:: or tidyr::, so replace 
# countRowNAs <- function(x) { sum(is.na(x)) }
# 
# count_NA <- function(data) {
#   apply(data, 1, countRowNAs)
# }     

```







