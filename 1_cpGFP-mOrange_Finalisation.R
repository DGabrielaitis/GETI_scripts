
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

rm(list = ls()) 




#------------libraries and functinos --------

library(readxl)
library(glue)
library(writexl)

library(dplyr)
library(tidyverse)


#------------------------------- Function for normalisation: ---------------------------

folder_paths <- c("exp1", "exp2", "exp3", "exp4")

# Create an empty list to store all the data frames
data_frames <- list()

for (folder_path in folder_paths) {
  # Get a list of all Excel files in the folder that start with "W"
  excel_files <- list.files(folder_path, pattern = "^W.*\\.xlsx", full.names = TRUE)
  
  # Loop through each Excel file
  for (excel_file in excel_files) {
    # Read the Excel file into a data frame
    df <- read_excel(excel_file)
    
    # Remove any columns with the name "time"
    df <- df %>% select(-contains("time"))
    
    # Add the data frame to the list
    data_frames[[length(data_frames) + 1]] <- df
  }
}


# Define a function to add prefix to column names
prefix_cols <- function(df, prefix) {
  colnames(df) <- paste0(prefix, "_", colnames(df))
  return(df)
}

# Use lapply to apply the function to all data frames in the list
df_list_renamed <- lapply(seq_along(data_frames), function(i) {
  prefix_cols(data_frames[[i]], i)
})

# Combine the data frames using cbind
df_combined <- do.call(cbind, df_list_renamed)

# use grep() to find column indices that match the pattern "GFP"
gfp_cols <- grep("GFP", names(df_combined))

# use subset() to select only the columns that match the pattern "GFP"
df_gfp <- subset(df_combined, select = gfp_cols)

# use grep() to find column indices that match the pattern "GFP"
rfp_cols <- grep("RFP", names(df_combined))

# use subset() to select only the columns that match the pattern "GFP"
df_rfp <- subset(df_combined, select = rfp_cols)



# calculate the averages, stdev and N
# apply mean, sd, and length functions to each row
df_stats <- apply(df_gfp, 1, function(x) c(mean_gfp = mean(x), sd_gfp = sd(x), N_gfp = length(x)))

# convert resulting matrix to dataframe
GFP_stats <- as.data.frame(t(df_stats))

# apply mean, sd, and length functions to each row
df_stats <- apply(df_rfp, 1, function(x) c(mean_rfp = mean(x), sd_rfp = sd(x), N_rfp = length(x)))

# convert resulting matrix to dataframe
RFP_stats <- as.data.frame(t(df_stats))

df_fin <- cbind(GFP_stats, RFP_stats)
write_xlsx(df_fin, "Final_stat.xlsx")
