library(ggplot2)
library(viridis)
library(tidyverse)

class_cats <- read.csv(".../ACDB_datarelease/Figures/data")

class_cats_plot <- 
  ggplot(class_cats, aes(x = reorder(as.factor(domains), -table(domains)[domains]), fill = Class)) + 
  geom_bar() +  
  labs(x = "Domains", y = "Count in database") +
  scale_y_continuous(limits=c(0,65), breaks=seq(0,65,by=5)) +
  scale_fill_viridis(option="turbo", alpha = 1, begin = 0.01, discrete=TRUE) +
  theme_bw()
