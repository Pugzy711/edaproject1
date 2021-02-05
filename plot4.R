## Reading the data

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
## plot 4:
par(mfrow=c(2,2),mar=c(4,4,2,1))
plot(yeardata$Time, yeardata$Global_active_power, xlab = "", ylab = "Global Active Power", type="l")
plot(yeardata$Time, yeardata$Voltage, xlab = "datetime", ylab = "Voltage", type="l")
plot(yeardata$Time, yeardata$Sub_metering_1, type = "l", xlim = NULL, ylim = NULL, xlab = "", ylab = "Energy sub Metering")
points(yeardata$Time, yeardata$Sub_metering_2, col = "red", type = "l")
points(yeardata$Time, yeardata$Sub_metering_3, col = "blue", type = "l")
legend("topright",lty = 1, bty = "n", legend = c("Sub_Metering_1","Sub_Metering_2", "Sub_Metering_3"),col = c("black", "red", "blue"), cex = 0.7)
plot(yeardata$Time, yeardata$Global_reactive_power, xlab = "datetime", ylab = "Global_Reactive_Power", type="l")
dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()