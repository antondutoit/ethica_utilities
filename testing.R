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

# test 5 - using assign() and := to dynamically create variables ----- 
# example code from https://stackoverflow.com/questions/26003574/use-dynamic-name-for-new-column-variable-in-dplyr 
# In the new release of dplyr (0.6.0 awaiting in April 2017), we can also do an assignment (:=) and pass variables as column names by unquoting (!!) to not evaluate it
# 
# library(dplyr)
# multipetal <- function(df, n) {
#   mutate(df, "petal.{n}" := Petal.Width * n)
# }

# this works, as far as it goes ------
test_df <- data.frame(a = c(6,7,8), b = c("a", "b", "c"))
j <- 1
  varname <- paste("constant_val", j, sep = "." )
  assign(varname, 1:nrow(test_df))

test_df %<>% mutate("constant_val.{j}" := eval(sym(varname)))

# 2nd iteration: loop it ------
test_df <- data.frame(a = c(6,7,8), b = c("a", "b", "c"))
j <- 0
for (j in 0:2)  {
  j <- j + 1

  varname <- paste("constant_val", j, sep = "." )
  assign(varname, 1:nrow(test_df))

  test_df %<>% mutate("constant_val.{j}" := eval(sym(varname)))
  }


# checks -----
varname             # [1] "constant_val.1"
eval(varname)       # [1] "constant_val.1"
eval(sym(varname))  # [1] 1 2 3
constant_val.1      # [1] 1 2 3

# example code from online docs for assign() -----
for(i in 1:6) { #-- Create objects  'r.1', 'r.2', ... 'r.6' --
  nam <- paste("r", i, sep = ".")
  assign(nam, 1:i)
}

ls(pattern = "^r..$")
nam

























