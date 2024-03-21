
FN <- file_names[[1]]

FN

# Extract activity number; this expression will extract 5- to 6-digit activity numbers.
AN1 <- str_extract(FN, pattern = "activity_response_" %R% repeated(DGT,4,5) %R% "_" %R% repeated(DGT,5,6) )

AN1

AN2 <- AN1 %>% str_remove_all("activity_response_" %R% repeated(DGT,4,5) %R% "_")

AN2



