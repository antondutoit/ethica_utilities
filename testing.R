# test 1
FN <- file_names[[1]]
FN

# Extract activity number; this expression will extract 5- to 6-digit activity numbers.
AN1 <- str_extract(FN, pattern = "activity_response_" %R% repeated(DGT,4,5) %R% "_" %R% repeated(DGT,5,6) )
AN1

AN2 <- AN1 %>% str_remove_all("activity_response_" %R% repeated(DGT,4,5) %R% "_")
AN2

# test 2
DFN <- df_names[[1]]
DFN

AN3 <- str_extract(DFN, pattern = "_" %R% repeated(DGT, 5, 6) %R% "_df" ) %>%  str_remove_all("_") %>% str_remove_all("df")
AN3

AN3.1 <- str_extract(DFN, pattern = "_" %R% repeated(DGT, 5, 6) %R% "_df" ) %>%  str_replace_all(pattern = c("_","df"), replacement = "") 
AN3.1

# test 3
tvec <- c("ababab", "cbcbcb")
str_remove_all(tvec, c("a","c"))

# test 4 - where will a str_c concatenate onto an existing vector, start or end? 
str_c("opt_", tvec)
str_c(tvec, "opt_")   # in the order of the arguments, unsurprisingly 

# test 5 

