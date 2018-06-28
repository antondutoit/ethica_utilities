# ethica_utilities
Utility software for the Ethica mobile data collection platform

First utility is:

'Ethica output cleaning and variable renaming'. 
This is written in R. It cleans single answer question output and renames variables according to a consistent scheme for ease of reference.

To use this script with your data files, change the file path on line 56 to point at the folder with your data files. The files must be in CSV format.

The script will output a dataframe for each CSV file; dataframes will be named Survey.Number_df. The dataframe will have clean numerical output for single-answer questions, and also will have all variables renamed as Survey.Number_Question.Number_Question.Type.

If you also want a CSV file outputted, you could use this code: write.csv(your_df, file = "C:/your_file_path/your_filename.csv", na = "").
