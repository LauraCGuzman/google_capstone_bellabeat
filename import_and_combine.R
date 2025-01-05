#install libraries
install.packages(c("tidyverse", "ggplot2", "lubridate", "dplyr", "readr", "janitor", "data.table", "tidyr"))
#upload libraries
library(tidyverse) 
library(ggplot2) 
library(lubridate) 
library(dplyr) 
library(readr) 
library(janitor) 
library(data.table) 
library(tidyr) 


#Importing and combining tables: same tables were split in 2 different periods
# Define the path to folders
folder1 <- "Fitabase_Data_3.12.16-4.11.16"
folder2 <- "Fitabase_Data_4.12.16-5.12.16"

# Obtiene la lista de archivos en ambas carpetas
files_folder1 <- list.files(path = folder1, pattern = "\\.csv$", full.names = TRUE)
files_folder2 <- list.files(path = folder2, pattern = "\\.csv$", full.names = TRUE)

# Combina los archivos que están en ambas carpetas y los que están solo en una
for (file in c(files_folder1, files_folder2)) {
  file_name <- basename(file)  # Obtiene el nombre del archivo sin la ruta
  
  # Lee el archivo CSV y lo asigna a una variable con el mismo nombre
  assign(file_name, read.csv(file))
  
  # Si el archivo existe en ambas carpetas, busca el otro y combina
  if (file %in% files_folder1 && file %in% files_folder2) {
    file2 <- file_name
    file2 <- gsub(".csv", "", file2)  # Quita la extensión .csv
    file2 <- paste0(file2, "_folder2.csv")
    file2 <- file.path(folder2, file2)
    
    df2 <- read.csv(file2)
    
    # Combina los dataframes y asigna el resultado a la variable original
    assign(file_name, rbind(get(file_name), df2))
  }
}