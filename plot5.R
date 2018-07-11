# loading required library (should be installed, the script wont)
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

# getting idx and value of SCC codes for motor vehicule sources
# (assuming that all vehicule source are motorized)
idx_motor <- grepl("vehicle", scc$Short.Name, ignore.case=1)
motor_scc <- scc[idx_motor,]$SCC

# filtering by motor SCC codes, Baltimore and grouping by year
tot5 <- nei %>% 
# filter(SCC %in% motor_scc & fips=="24510" & type=="ON-ROAD") %>% 
  filter(SCC %in% motor_scc & fips=="24510") %>% 
  group_by(year) %>% 
  summarize(total=sum(Emissions))

# building plot
p5 <- qplot(data=tot5, year, total, geom="path", ylab="emissions (tons)",
  main="PM2.5 total emissions for motor vehicules sources in Baltimore")

# printing plot and copying into png file
print(p5)
dev.copy(png, "plot5.png", width=480, height=480)
dev.off() # always closing dev
