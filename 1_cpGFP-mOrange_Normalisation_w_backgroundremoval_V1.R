
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

rm(list = ls()) 



#------------libraries and functinos --------

library(readxl)
library(glue)
library(writexl)
library(dplyr)


#------------------------------- Function for normalisation: ---------------------------

BACKGROUND_REMOVAL<- function(df) {
  #count the number of ROIs subtracting the background
  NoOfCells <- ((ncol(df)-5)/2)-1
  #select the background trace (it is always the last ROI's)
  GFP_background <- df[,NoOfCells+6]
  RFP_background <- df[,2*NoOfCells+7]
  #Background correction
  for (i in 1:NoOfCells) {
    #for every row, subtract the mean background
    df[,5+i]<-df[,5+i]-GFP_background
    df[,5+NoOfCells+i]<-df[,5+NoOfCells+i]-RFP_background
  }
  return(df)
}



#this function is meant for every image
DATA_NORMALISATION <- function(df) {
  #calculate the number of cells recorded, sp that we could know how many times to iterate our loop:
  NoOfCells <- ((ncol(df)-5)/2)-1
  # create a new DF which will become our normalised DF
  new_df <- data.frame(matrix(NA, nrow = 105, ncol = 0))
  #Make a new DF that only contains the GFP and the RFP DATA for that specific cell, also remove the 0's (this is only useful if you acquired data without merging the channels):
  #first separate the data into GFP and RFP:
  #GFP
  indicesGFP <- seq(1, nrow(df), by = 2)
  GFP1 <- df[indicesGFP,]
  indicesRFP <- seq(2, nrow(df), by = 2)
  RFP1 <- df[indicesRFP,]
  
  
  #Normalise
  for (i in 1:NoOfCells) {
    #add normalisation HERE  
    nf_g <- as.numeric(GFP1[15,5+i])
    GFP1_norm<- data.frame(GFP1[,5+i])/nf_g
    #
    nf_r <- as.numeric(RFP1[15,NoOfCells+5+i])
    RFP1_norm<- data.frame(RFP1[,NoOfCells+5+i])/nf_r
    #Bind the data into a new df
    new_df <- cbind(new_df,GFP1_norm, RFP1_norm)
    colnames(new_df)[(2*i)-1] <- glue("GFP_Cell{i}")
    colnames(new_df)[2*i] <- glue("RFP_Cell{i}")
  }
  new_df$time <- GFP1$`Time [s]` 
  return(new_df)
}


#-------------------------- data import -------------------------

# List all the files in the current working directory
files <- list.files()
# Filter the files to include only the file you want to open
# Here we make the assumption, that out codes name is always first
File_name <- files[2]

# upload data from a single image
W1I1 <- read_excel(File_name, sheet = "W1I1")
W1I2 <- read_excel(File_name, sheet = "W1I2")
W1I3 <- read_excel(File_name, sheet = "W1I3")
W1I4 <- read_excel(File_name, sheet = "W1I4")
W1I5 <- read_excel(File_name, sheet = "W1I5")
W2I1 <- read_excel(File_name, sheet = "W2I1")
W2I2 <- read_excel(File_name, sheet = "W2I2")
W2I3 <- read_excel(File_name, sheet = "W2I3")
W2I4 <- read_excel(File_name, sheet = "W2I4")
W2I5 <- read_excel(File_name, sheet = "W2I5")

# remove background for all df's

W1I1 <- BACKGROUND_REMOVAL(W1I1)
W1I2 <- BACKGROUND_REMOVAL(W1I2)
W1I3 <- BACKGROUND_REMOVAL(W1I3)
W1I4 <- BACKGROUND_REMOVAL(W1I4)
W1I5 <- BACKGROUND_REMOVAL(W1I5)

W2I1 <- BACKGROUND_REMOVAL(W2I1)
W2I2 <- BACKGROUND_REMOVAL(W2I2)
W2I3 <- BACKGROUND_REMOVAL(W2I3)
W2I4 <- BACKGROUND_REMOVAL(W2I4)
W2I5 <- BACKGROUND_REMOVAL(W2I5)

#-------------------------- Run the code for the data -------------------------

W1I1_out<-DATA_NORMALISATION(W1I1)
W1I1_out<-W1I1_out %>% relocate('time')
write_xlsx(W1I1_out, "W1I1_out.xlsx")

W1I2_out<-DATA_NORMALISATION(W1I2)
W1I2_out<-W1I2_out %>% relocate('time')
write_xlsx(W1I2_out, "W1I2_out.xlsx")

W1I3_out<-DATA_NORMALISATION(W1I3)
W1I3_out<-W1I3_out %>% relocate('time')
write_xlsx(W1I3_out, "W1I3_out.xlsx")

W1I4_out<-DATA_NORMALISATION(W1I4)
W1I4_out<-W1I4_out %>% relocate('time')
write_xlsx(W1I4_out, "W1I4_out.xlsx")

W1I5_out<-DATA_NORMALISATION(W1I5)
W1I5_out<-W1I5_out %>% relocate('time')
write_xlsx(W1I5_out, "W1I5_out.xlsx")

W2I1_out<-DATA_NORMALISATION(W2I1)
W2I1_out<-W2I1_out %>% relocate('time')
write_xlsx(W2I1_out, "W2I1_out.xlsx")

W2I2_out<-DATA_NORMALISATION(W2I2)
W2I2_out<-W2I2_out %>% relocate('time')
write_xlsx(W2I2_out, "W2I2_out.xlsx")

W2I3_out<-DATA_NORMALISATION(W2I3)
W2I3_out<-W2I3_out %>% relocate('time')
write_xlsx(W2I3_out, "W2I3_out.xlsx")

W2I4_out<-DATA_NORMALISATION(W2I4)
W2I4_out<-W2I4_out %>% relocate('time')
write_xlsx(W2I4_out, "W2I4_out.xlsx")

W2I5_out<-DATA_NORMALISATION(W2I5)
W2I5_out<-W2I5_out %>% relocate('time')
write_xlsx(W2I5_out, "W2I5_out.xlsx")




