#' Title: Amazon X Ray
#' Purpose: Explore some X-Ray data
#' License: GPL>=3
#' Date: Dec 30 2020
#'

### 1. Set working directory to your specific movie
setwd("~/GitHub/class1/data")

# Turn off scientific notation
options(scipen = 999)

### 2. Load libraries to customize R
library(ggplot2)
library(ggthemes)

### 3. Read in data
# Use the read.csv function for your specific definedScenes.csv file
scenesDF   <- read.csv('lego_definedScenes.csv')

### 4. Apply functions to clean up data & get insights/analysis
# Use the names function to review the names of scenesDF
names(scenesDF)

# Review the bottom 6 records of scenesDF
tail(scenesDF)

# Clean up the raw data with a "global substitution"
scenesDF$id <- gsub('/xray/scene/', "", scenesDF$id)
tail(scenesDF)

# Change ID class from string to numeric
scenesDF$id <- as.numeric(scenesDF$id)

# Remove a column
scenesDF$fictionalLocation <- NULL

# Make a new column & review
scenesDF$length <- scenesDF$end - scenesDF$start 
head(scenesDF$length)

# Basic statistics
summary(scenesDF) 

### 5. Project artifacts ie visuals & (if applicable)modeling results/KPI
# Quick plot
hist(scenesDF$length)
summary((scenesDF$length/1000) %/% 60)
# Modulo ie "small measure" %% will return the remainder 
# While %/% returns the integer only

# Identify the outlier, review; note the double ==
subset(scenesDF, scenesDF$length == max(scenesDF$length))

# Or you can use a different function to find the row
maximumLength <- which.max(scenesDF$length) #16
scenesDF[maximumLength,]

# Encoding fix: scenesDF$name[9] is the issue
unique(scenesDF$name)
scenesDF$name <- stringi::stri_encode(scenesDF$name, "", "UTF-8")

################ BACK TO PPT FOR EXPLANATION ##################
ggplot(scenesDF[-16,], aes(colour = name)) + 
  geom_segment(aes(x = start, xend = end,
                   y = id,    yend = id), size = 3) +
  geom_text(data=scenesDF[-16,], aes(x = end, y = id, label = name), 
            size = 2.25, color = 'black', alpha = 0.5, check_overlap = TRUE) +
  theme_gdocs() + theme(legend.position = "none")

# End

