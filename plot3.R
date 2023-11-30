###                     ###
### Plotting for Plot 3 ###
###                     ###

#                                   #
# Getting and Cleaning the data set #
#                                   #


#Set your working directory
setwd('C:/Users/rober/OneDrive/data-projects/coursera/plot_project_1')

#Install necessary packages
library(lubridate)
library(dplyr)


#Check to see if data folder exists, create one if not
if(!file.exists('./data')){dir.create('./data')}


#Check to see if data file exists, create it if not

if (!file.exists('./data/power_data.zip')) {
    
    #URL path to data
    fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
    
    #Download the file and rename it. Enter your information in the destfile argument
    download.file(fileURL, destfile = './data/household_power_consumption.zip')
    
    #Unzip the file once downloaded
    unzip('./data/household_power_consumption.zip', exdir = 'data', overwrite = TRUE)
    
    #Create new var to read the data into R
    rawData <- read.table('data/household_power_consumption.txt', header = TRUE, na.strings = '?', sep = ';')
    
    #Create new date/time column
    rawData$Date <- dmy(rawData$Date)
    
    rawData$DateTime <- ymd(rawData$Date)+hms(rawData$Time)
    
    #Filter out to dates specified in the exercise
    rawData <- rawData %>% filter(Date == "2007-02-01" | Date == "2007-02-02")
    
    #Make specified columns numeric
    rawData <- rawData %>% mutate_at(c('Global_active_power', 'Global_reactive_power', 'Voltage', 'Global_intensity', 'Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), as.numeric)
    
    #Write a clean data set back to the directory
    write.table(rawData,file='data/clean_data.txt',sep='|',row.names=FALSE)
    
} else {
    
    #If clean data already exists, pull that for use
    rawData <- read.table(rawData,file='data/clean_data.txt',sep='|',row.names=FALSE)
    
}

#                         #
# Create the plot and PNG #
#                         #

#Identify path for PNG to reside
png_path <- "C:/Users/rober/OneDrive/data-projects/coursera/plot_project_1/ExData_Plotting1/plot3.png"

#Identify PNG characteristics
width <- 480
height <- 480

#Open PNG
png(file = png_path, width = width, height = height)

#Create plot
plot(rawData$DateTime, rawData$Sub_metering_1, type = "s", ylab = "Energy sub metering", xlab = " ")
points(rawData$DateTime, rawData$Sub_metering_2, type = "s", col = "red")
points(rawData$DateTime, rawData$Sub_metering_3, type = "s", col = "blue")

legend("topright", legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), lty = "solid", col = c("black", "red", "blue"))

#End process
dev.off()
