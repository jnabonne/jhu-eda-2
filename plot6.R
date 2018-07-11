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

# getting idx and value of SCC codes for coal related sources
idx_motor <- grepl("motor", scc$Short.Name, ignore.case=1)
motor_scc <- scc[idx_motor,]$SCC

# filtering by motor scc codes and fips corresponding to Baltimore & LA County
tot6 <- nei %>% 
  filter(SCC %in% motor_scc & (fips=="24510" | fips=="06037")) %>% 
  group_by(year, fips) %>% 
  summarize(total=sum(Emissions))

# building plot (but does not display it yet)
p6 <- qplot(data=tot6, year, total, color=fips, geom="path",
           ylab="emissions (tons)",
           main="PM2.5 total emissions for motor vehicules sources")

# printing plot while modifying legend on-the-fly
print(p6 + scale_colour_hue(name="Location", breaks=c("06037", "24510"),
                     labels=c("LA County", "Baltimore City")))

# copying plot into png file
dev.copy(png, "plot6.png", width=480, height=480)
dev.off() # always closing dev
