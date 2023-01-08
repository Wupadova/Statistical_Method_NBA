####################################################################################
#=================================================================================
# per game dataset
data_player_game <- read.csv('nba2021_per_game.csv')    # end with 'PTS'
# advance dataset
data_player_adv <- read.csv('nba2021_advanced.csv')

data <- left_join(data_player_adv, data_player_game, by = 'Player', suffix = c("", ".y")) %>%
  select(-ends_with(".y"))

data <- data[complete.cases(data), ]   # select rows without NA

data <- data[!duplicated(data['Player']),]
colSums(is.na(data))
rowSums(is.na(data))

#=================================================================================
# Get the salary of the players
data_salary <- read.csv('nba2k-full.csv')

salary <- data_salary$salary  # Get the salary of the players

# remove the $ sign
salary = as.numeric(gsub("\\$", "", salary))

library(stringr)
weight <- str_split_fixed(data_salary$weight, "/", 2)[, 2] # Get the weight in kg
weight <- as.numeric(sub('kg.', '', weight))  # Remove kg. and change it to numeric values
#----------------------------------------------------------------------------------
Player <- data_salary[, 'full_name'] # Get the name of the players of salary dataset

# Create a new dataset for weight and salary
new_data <- data.frame(Player, weight, salary)

data <- left_join(data, new_data, by = 'Player', suffix = c("", ".y")) %>%
  select(-ends_with(".y"))

data <- data[complete.cases(data),]   # Remove NA by rows
data <- data[!duplicated(data['Player']),]

colSums(is.na(data))
rowSums(is.na(data))

colnames(data)


#--------------------------------------------------------------------------------------
# Perform one-hot-encoding
library(mltools) #library for one_hot function
library(data.table)
#--------------------------------------------------------------------------------------
# put them as a factor (they where as characters)
data$Pos <- as.factor(data$Pos)
data$Tm <- as.factor(data$Tm)

# use one_hot function
data <- one_hot(as.data.table(data))

#=================================================================================
# COMBINE WITH OTHER DATASET
# The 2k player dataset
data_2k <- read.csv('2K20_ratings.csv')    # end with 'Defensive.Rebound'

data <- left_join(data, data_2k, by = 'Player')
colSums(is.na(data))
rowSums(is.na(data))
data <- data[complete.cases(data), ]   # select rows without NA


#=================================================================================
write.csv(data, "data_final.csv", row.names=FALSE)  # save the data to file


rm(list = ls())
