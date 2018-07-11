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

# getting idx and value of SCC codes for coal related sources
idx_coal <- grepl("coal", scc$Short.Name, ignore.case=1)
coal_scc <- scc[idx_coal,]$SCC

# filtering by coal scc codes and grouping by year
tot4 <- nei %>% 
  filter(SCC %in% coal_scc) %>% 
  group_by(year) %>% 
  summarize(total=sum(Emissions))

# building plot
p4 <- qplot(data=tot4, year, total, geom="path", ylab="emissions (tons)",
  main="US PM2.5 total emissions for coal combustion-related sources")

# printing plot then copying into png file
print(p4)
dev.copy(png, "plot4.png", width=480, height=480)
dev.off() # always closing dev
