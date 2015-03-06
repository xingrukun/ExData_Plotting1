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

png(filename = "plot2.png", bg = "white")

Sys.setlocale("LC_ALL", "USA") #change the locale
par(ps = 12)
with(targetData, plot(targetData$Date_time, targetData$Global_active_power, 
                      type = "l", xlab = "", 
                      ylab = "Global Active Power (kilowatts)"))

dev.off()