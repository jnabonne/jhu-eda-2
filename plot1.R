# downloading dataset (each time to get its latest version)
file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
file_path <- "NEI_data.zip"
download.file(file_url, destfile=file_path, method="curl")
unzip(file_path)

# reading (and unzipping on-the-fly) dataset's 2 files
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# summing emissions per years
tot1 <- tapply(nei$Emissions, nei$year, sum)

# building plot
plot(names(tot1), tot1, type='b',
     xlab="year", ylab="emissions (tons)",
     main="Total emissions of PM2.5 in the US")

# copying plot into png file
dev.copy(png, "plot1.png", width=480, height=480)
dev.off() # always closing dev
