
# ```{r Deprecated} -----
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


# # test -----
# x4 <- "{\"answer_id\":null,\"answer_content\":\"7\",\"answer_location\":{\"latitude\":null,\"longitude\":null,\"accuracy\":null,\"speed\":null},\"answer_response_time\":\"2024-02-19T03:35:15.692000+00:00\",\"answer_question_content\":\"In general how much of the time do you feel you are making progress towards accomplishing your goals?\\n(If your answer is zero you still have to move the slider back and forth so it knows you are not skipping the question.)\\n0 = Never\\n10 = Always\",\"answer_media_interactions\":[],\"unanswered_status_id\":null}"
# 
# str_detect(x4, pattern4)  #   
# 
# x5 <- "{\"answer_id\":2,\"answer_content\":\"A little of the time\",\"answer_location\":{\"latitude\":null,\"longitude\":null,\"accuracy\":null,\"speed\":null},\"answer_response_time\":\"2024-02-19T03:03:37.484000+00:00\",\"answer_question_content\":\"In the last four weeks about how often ...\\n\\n1. Did you feel tired out for no good reason?\",\"answer_media_interactions\":[],\"unanswered_status_id\":null}"
# 
# str_detect(x5, pattern4)  #  


# testing regex in funs -----
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


# ```

# ```{r Test:    try to rewrite col name regex to include MAQ questions, eval=FALSE} ----
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

# ```{r Create: functions for output cleaning}
# # Function to create column with count of NAs     # redundant- can use a fun from naniar:: or tidyr::, so replace 
# countRowNAs <- function(x) { sum(is.na(x)) }
# 
# count_NA <- function(data) {
#   apply(data, 1, countRowNAs)
# }     

# ```

# ```{r deprecated, eval=FALSE} -----
# combined_df %<>% 
#   mutate(participant_id = as.integer(participant_id)) %>% 
#   mutate(participant_status = as.integer(participant_status)) %>% 
#   mutate(obs_id = as.integer(obs_id)) %>% 
#   mutate(status = as.integer(status)) %>% 
#   mutate(triggering_logic_id = as.integer(triggering_logic_id)) %>% 
#   mutate(triggering_logic_type = as.integer(triggering_logic_type)) 

# test_df <- data.frame(a = c(6,7,8), b = c("a", "b", "c"))
# j <- 0
# for (j in 0:2)  {
#   j <- j + 1
# 
#   varname <- paste("constant_val", j, sep = "." )
#   assign(varname, 1:nrow(test_df))
# 
#   test_df %<>% mutate("constant_val.{j}" := eval(sym(varname)))
#   }

# for (df_name in df_names)  {
#   df_list[[df_name]] %<>% arrange(record_time)
#   activity_no <- str_extract(df_name, pattern = pattern6) %>% str_remove_all("df") %>% str_remove_all("_")
#   newvar <- paste("obs", activity_no, sep = "." )
#   df_list[[df_name]] %<>% mutate(newvar = row_number(), .before = uuid)
#  }

# ```


# ```{r Create: functions for preprocessing multiple answer questions, eval=FALSE}
# # put NA in 1340_Q19_MAQ
# test_pathways_baselines_df <- test_pathways_baselines_df %>%
#     mutate_at(vars(`1340_Q19_MAQ`), ~ na_if(., ""))             # NB mutate_at() may be depreceated by nnow; replace

# # create multiple cols for 1340_Q19_MAQ. First use str_split to create a matrix with one col for each answer, then make into df.
# diagnosed_conditions_mx <- str_split(string = test_pathways_baselines_df$`1340_Q19_MAQ`, pattern = " & ", simplify = TRUE)
# diagnosed_conditions_df <- as.data.frame(diagnosed_conditions_mx)
# 
# # Do I need a join to get the data in the right place? It seems not. 
# test_pathways_baselines_df <- bind_cols(test_pathways_baselines_df, diagnosed_conditions_df)
# 
# # rename columns. May need more code if someone has more than 6 answers. But I don't; the most answers anyone had was 6.  
# test_pathways_baselines_df <- rename(test_pathways_baselines_df, `1340_Q19_MAQ_1` = V1, `1340_Q19_MAQ_2` = V2, `1340_Q19_MAQ_3` = V3, `1340_Q19_MAQ_4` = V4, `1340_Q19_MAQ_5` = V5, `1340_Q19_MAQ_6` = V6)
# 
# # use str_replace to get numbers only, dump characters
# test_pathways_baselines_df <- test_pathways_baselines_df %>% 
#     mutate_at(vars(contains("1340_Q19_MAQ_")), number_extract_single)
# 
# # create col with concatenation of all Q19_MAQ cols
# test_pathways_baselines_df <- test_pathways_baselines_df %>% unite(`1340_Q19_MAQ_concat`, `1340_Q19_MAQ_1`:`1340_Q19_MAQ_6`, sep = ",", remove = FALSE)
# 
# # create binary cols for each concat answer
# pattern1 <- or1(c(",1,", ",1" %R% END, START %R% "1,"))
# pattern2 <- or1(c(",2,", ",2" %R% END, START %R% "2,"))
# pattern3 <- or1(c(",3,", ",3" %R% END, START %R% "3,"))
# pattern4 <- or1(c(",4,", ",4" %R% END, START %R% "4,"))
# pattern5 <- or1(c(",5,", ",5" %R% END, START %R% "5,"))
# pattern7 <- or1(c(",6,", ",6" %R% END, START %R% "6,"))
# pattern8 <- or1(c(",7,", ",7" %R% END, START %R% "7,"))
# pattern8 <- or1(c(",8,", ",8" %R% END, START %R% "8,"))
# pattern9 <- or1(c(",9,", ",9" %R% END, START %R% "9,"))
# pattern10 <- or1(c(",10,", ",10" %R% END, START %R% "10,"))
# 
# test_pathways_baselines_df <- test_pathways_baselines_df %>% 
#     mutate(`1340_Q19_MAQ_option1` = ifelse(str_detect(string = `1340_Q19_MAQ_concat`, pattern = pattern1), TRUE, FALSE)) %>%
#     mutate(`1340_Q19_MAQ_option2` = ifelse(str_detect(string = `1340_Q19_MAQ_concat`, pattern = pattern2), TRUE, FALSE)) %>%
#     mutate(`1340_Q19_MAQ_option3` = ifelse(str_detect(string = `1340_Q19_MAQ_concat`, pattern = pattern3), TRUE, FALSE)) %>% 
#      mutate(`1340_Q19_MAQ_option4` = ifelse(str_detect(string = `1340_Q19_MAQ_concat`, pattern = pattern4), TRUE, FALSE)) %>% 
#      mutate(`1340_Q19_MAQ_option5` = ifelse(str_detect(string = `1340_Q19_MAQ_concat`, pattern = pattern5), TRUE, FALSE)) %>% 
#      mutate(`1340_Q19_MAQ_option6` = ifelse(str_detect(string = `1340_Q19_MAQ_concat`, pattern = pattern7), TRUE, FALSE)) %>% 
#     mutate(`1340_Q19_MAQ_option7` = ifelse(str_detect(string = `1340_Q19_MAQ_concat`, pattern = pattern8), TRUE, FALSE)) %>% 
#     mutate(`1340_Q19_MAQ_option8` = ifelse(str_detect(string = `1340_Q19_MAQ_concat`, pattern = pattern8), TRUE, FALSE)) %>% 
#     mutate(`1340_Q19_MAQ_option9` = ifelse(str_detect(string = `1340_Q19_MAQ_concat`, pattern = pattern9), TRUE, FALSE)) %>% 
#     mutate(`1340_Q19_MAQ_option10` = ifelse(str_detect(string = `1340_Q19_MAQ_concat`, pattern = pattern10), TRUE, FALSE))
# 
# test_pathways_baselines_df <- test_pathways_baselines_df %>% 
#     mutate_at(vars(`1340_Q19_MAQ_1`:`1340_Q19_MAQ_6`), ~ factor(., levels = c(1:10), labels = c("Heart disease", "Other heart condition", "Blood clot thrombosis", "Asthma", "Hay fever", "Depression", "Anxiety", "Thyroid problems", "None of these", "Other"), exclude = NA))

# ```







