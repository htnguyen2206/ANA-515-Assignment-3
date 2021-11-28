install.packages('tidyverse')
install.packages('dplyr')
install.packages('stringr')
install.packages('lubridate')
install.packages('ggplot2')
install.packages('readr')

library(tidyverse)
library(dplyr)
library(stringr)
library(lubridate)
library(ggplot2)
library(readr)

storm1990 <- read.csv("StormEvents_details-ftp_v1.0_d1990_c20210803.csv")

myvars <- c("BEGIN_DATE_TIME","END_DATE_TIME", "EPISODE_ID","EVENT_ID","STATE","STATE_FIPS","CZ_TYPE","CZ_FIPS","SOURCE","BEGIN_LAT","BEGIN_LON","END_LAT","END_LON")

newdata <- storm1990[myvars]

newdata1 <- mutate(newdata, BEGIN_DATE_TIME=dmy_hms(BEGIN_DATE_TIME),END_DATE_TIME = dmy_hms(END_DATE_TIME))

str_to_lower(newdata1$STATE)

filter(newdata1, "CZ_TYPE"=="C")

select(newdata1, -CZ_TYPE)

str_pad(newdata1$CZ_FIPS, width=3, side="left",pad="0")

unite(newdata1,"NEWFIPS",c("STATE","CZ_FIPS"))

rename_all(newdata1,tolower)

us_state_info<-data.frame(state=state.name, region=state.region, area=state.area)

Newset<- data.frame(table(newdata1$STATE))

newset1<-rename(Newset, c("state"="Var1"))

us_state_info1<- mutate_all(us_state_info, toupper) 

merged1 <- merge(x=newset1,y=us_state_info1,by.x="state", by.y="state")

storm_plot <- ggplot(merged1,aes(x=area, y=Freq))+
  geom_point(aes(color=region))+
  labs(x="Land area (square miles)", y="# of storm events in 1990")
storm_plot


