## reading the data

# download zip file containing data if it hasn't already been downloaded
zipUrl<- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "household_power_consumption.zip"
if (!file.exists(zipFile)) {
    download.file(zipUrl, zipFile, mode = "wb")
}
# unzip zip file containing data if data directory doesn't already exist
datafile <- "household_power_consumption.txt"
if (!file.exists(datafile)) {
    unzip(zipFile)
}
# delete the zip file after it was unzipped
file.remove(zipFile)
# Read data - first sample to extract class names, then read whole data
initialdata <- read.table(datafile,sep = ";", na.strings = "?",header = TRUE, nrows = 100)
classes <- sapply(initialdata, class)
data <- read.table(datafile,sep = ";", na.strings = "?",header = TRUE, colClasses = classes)
yeardata <- subset(data, Date == "1/2/2007" | Date =="2/2/2007")
library(dplyr)
# change Date and year columns to Date classes
datetime <- paste(yeardata$Date, yeardata$Time)
datetime <- strptime(datetime, format = "%d/%m/%Y %H:%M:%S")
yeardata <- mutate(yeardata, Date = as.Date(Date, format = "%d/%m/%Y"), Time = datetime)

## plot 1:
with(yeardata, hist(Global_active_power, main = "Global Active Power", col = "red", breaks = 12, xlab = "Global Active Power (Kilowatts)", ylab = "Frequency"))
dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()

