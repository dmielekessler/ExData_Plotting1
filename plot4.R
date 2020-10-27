#This is a script for the the Coursera Exploratory Data Analysis Week 1 Peer Graded project.

# Establish the location of the initial data zip folder 
zipurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Store the current working directory as a text string for use in navigating to various folders 
dir <- getwd()

# Store the future zip folder name 
zipfolder <- "exdata_data_household_power_consumption"

# Store the data file name 
powerfile <- "household_power_consumption.txt"

# Store the plot1 file name and location
plot3 <- as.character(paste(dir, "plot4.png", sep = "/"))

# Store the location of the zip file 
zipcombine <- as.character(paste(dir, zipfolder, sep = "/"))

# Store the location of the data file 
filecombine <- as.character(paste(dir, powerfile, sep = "/"))

# If the zip file exists, remove it 
invisible(if(file.exists(zipcombine)) {file.remove(zipcombine)})

# If the data file exists, remove it
invisible(if(file.exists(filecombine)) {file.remove(filecombine)})

# If plot1 exists, remove it
invisible(if(file.exists(plot4)) {file.remove(plot4)})

# Download and store the zip file 
download.file(zipurl, destfile = zipcombine)
# (It appears one does not have to be logged in to coursera.org to complete this step)

# Unzip the file 
unzip(zipcombine)

#read in the data table
powerdata <- read.csv2(filecombine, header = TRUE, na.strings = "?")

#convert the date column to date formats
powerdata$Date <- as.Date(powerdata$Date, format = "%d/%m/%Y")

#subset the data to 2007-02-01 and 2007-02-02
powerdata <- subset(powerdata, Date == "2007/02/01" | Date == "2007/02/02")

#create a datetime field formatted as date time
powerdata$datetime  <- strptime(paste(powerdata$Date, powerdata$Time, sep = " "), format = "%Y-%m-%d %H:%M:%S")

#convert the last 7 columns to numeric
powerdata$Global_active_power <- as.numeric(powerdata$Global_active_power)
powerdata$Global_reactive_power <- as.numeric(powerdata$Global_reactive_power)
powerdata$Voltage <- as.numeric(powerdata$Voltage)
powerdata$Global_intensity <- as.numeric(powerdata$Global_intensity)
powerdata$Sub_metering_1 <- as.numeric(powerdata$Sub_metering_1)
powerdata$Sub_metering_2 <- as.numeric(powerdata$Sub_metering_2)
powerdata$Sub_metering_3 <- as.numeric(powerdata$Sub_metering_3)

#open the png device
#png(filename = "plot4.png", height = 480, width = 480)
#creating the plot
par(mfcol = c(2,2))
with(powerdata, plot(datetime, Global_active_power,
     ylab = "Global Active Power", xlab = "", type = "l"))
with(powerdata,
     plot(datetime, Sub_metering_1,
     ylab = "Energy Sub Metering", xlab = "", type = "l"))
with(powerdata, points(datetime, Sub_metering_2,
       col = "red", type = "l"))
with(powerdata, points(powerdata$datetime, powerdata$Sub_metering_3,
       col = "blue", type = "l"))
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1, bty = "n")
with(powerdata, plot(datetime, Voltage, type = "l"))
with(powerdata, plot(datetime, Global_reactive_power, type = "l"))
#close the graphics device
#dev.off()