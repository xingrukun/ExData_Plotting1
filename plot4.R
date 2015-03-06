targetData <- read.table("household_power_consumption.txt", 
                         sep = ";", na.strings = "?", nrows = 1, header = TRUE)
targetData <- targetData[0, ]

chunkSize <- 100000
currLine <- 1
repeat {
    rawData <- read.table("household_power_consumption.txt", 
                          col.names = names(targetData), 
                          sep = ";", na.strings = "?", 
                          nrows = chunkSize, skip = currLine)
    currLine <- currLine + chunkSize
    rowsRead <- nrow(rawData)
    targetData <- rbind(targetData, 
                        rawData[which(rawData$Date == "1/2/2007" | 
                                          rawData$Date == "2/2/2007"), ])
    if(rowsRead != chunkSize) {
        break
    }
}

targetData$Date_time <- paste(targetData$Date, targetData$Time, sep = " ")
targetData$Date_time <- strptime(targetData$Date_time, "%d/%m/%Y %H:%M:%S")

png(filename = "plot4.png", bg = "white")

Sys.setlocale("LC_ALL", "USA") #change the locale
par(ps = 12)
par(mfrow = c(2, 2))

with(targetData, plot(targetData$Date_time, targetData$Global_active_power, 
                      type = "l", xlab = "", 
                      ylab = "Global Active Power"))

with(targetData, plot(targetData$Date_time, targetData$Voltage, 
                      type = "l", xlab = "datetime", ylab = "Voltage"))

with(targetData, {
    plot(targetData$Date_time, targetData$Sub_metering_1, col = "black", 
         type = "l", xlab = "", ylab = "Energy sub metering")
    points(targetData$Date_time, targetData$Sub_metering_2, col = "red", type = "l")
    points(targetData$Date_time, targetData$Sub_metering_3, col = "blue", type = "l")
    legend("topright", lwd = 1, col = c("black", "red", "blue"),  
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})

with(targetData, plot(targetData$Date_time, targetData$Global_reactive_power, 
                      type = "l", xlab = "datetime", ylab = "Global_reactive_power"))

dev.off()