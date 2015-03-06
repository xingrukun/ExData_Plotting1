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

# strptime(targetData$Date, "%d/%m/%Y")

png(filename = "plot1.png", bg = "white")

hist(targetData$Global_active_power, col = "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")

dev.off()