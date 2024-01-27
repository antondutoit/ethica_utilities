# ethica_utilities
Utility software for the Avicenna/Ethica mobile data collection platform

First utility is:

<b>Ethica output cleaning and variable renaming</b><br> 
This is written in R. It cleans single answer question output and renames variables according to a consistent scheme for ease of reference.

To use this script with your data files, change the file path to point at the folder with your data files. The files must be in CSV format.

The script will output a dataframe for each CSV file; dataframes will be named Survey.Number_df. The dataframe will have clean numerical output for single-answer questions, and also will have all variables renamed as Survey.Number_Question.Number_Question.Type.
