library(ggplot2)
library(viridis)
library(tidyverse)
library(here)
class_cats <- read.csv(here("DDL/ACDB_folder/ACDB_datarelease/Figures/data/class_cats.csv"))

class_cats_plot <- 
  ggplot(class_cats, aes(x = reorder(as.factor(domains), -table(domains)[domains]), fill = Class)) + 
  geom_bar() +  
  labs(x = "Domains", y = "Count in database") +
  scale_y_continuous(limits=c(0,65), breaks=seq(0,65,by=5)) +
  scale_fill_manual(values=c('midnightblue','lightblue', 'turquoise')) +
  theme_classic()

saveRDS(class_cats_plot, here("DDL/ACDB_folder/ACDB_datarelease/Figures/class_cats_plot.rda"))
ggsave(here("DDL/ACDB_folder/ACDB_datarelease/Figures/class_cats_plot.pdf"), plot=class_cats_plot, width=10, units="in")
