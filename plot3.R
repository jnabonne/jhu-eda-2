# loading required libraries (should be installed, the script wont)
library(ggplot2)
library(dplyr)

# downloading dataset (each time to get its latest version)
file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
file_path <- "NEI_data.zip"
download.file(file_url, destfile=file_path, method="curl")
unzip(file_path)

# reading (and unzipping on-the-fly) dataset's 2 files
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# summing after filtering for Baltimore and grouping by year and sources types
tot3 <- nei %>% 
  filter(fips=="24510") %>% 
  group_by(year, type) %>% 
  summarize(total=sum(Emissions))

# building plot
p3 <- qplot(data=tot3, year, total, col=type, geom="path",
	ylab="emissions (tons)",
	main="Total emissions of PM2.5 in Baltimore City per type of sources")

# printing plot then copying into png file
print(p3)
dev.copy(png, "plot3.png", width=480, height=480)
dev.off() # always closing dev
