library(tidyverse)
library(ggthemes)
library(ggmap)
library(ggrepel)
library(sf)
library(leaflet)
library(tidygeocoder)
library(rphylopic)

world_map = map_data("world") %>% 
  filter(! long > 180) #this prevents the weird lines through russia etc.

#subset groups for only some labels
mapping_groups <- read.csv(here("Figures", "data", "mapping_groups.csv"))
class_cats <- read.csv(here("Figures", "data", "class_cats.csv"))
#class_cats <- class_cats[!duplicated(class_cats$group_id),]

mapping_groups2 <- left_join(mapping_groups, class_cats, 
                             by = c("group_id"))

mapping_groups2$labels_ml <- str_wrap(mapping_groups2$labels, width = 20)

pdf(here("Figures", "Map", "map.pdf"), 10, 5)
ggplot() +
  geom_map(data = world_map, map = world_map, aes(x = long, y = lat, map_id = region), fill = "grey", alpha = 0.3) +
  coord_map("mollweide") +
  geom_label_repel(
    data = mapping_groups2[!duplicated(mapping_groups2$group_id),],
    aes(long, lat, label = labels_ml),
    size = 1.5, 
    force = 10, 
    max.overlaps = 17,
    point.padding = 0.5, 
    fill = "white",
    color = "black",
    segment.color = "grey",
    min.segment.length = 0, 
    seed = 20, 
    box.padding = unit(0.6, "lines"),
    segment.size = 0.4
  ) + theme_map() +
  geom_point(data = mapping_groups2, 
             aes(long, lat, color = domains, shape = Class),
             size = 2, alpha = 0.7) +
  theme(
    legend.position = "bottom", 
    legend.box = "vertical",
    #legend.background = element_rect(fill = "white", color = "black", linewidth = 0.2),
    legend.title = element_text(size = 8, face = "bold", margin = margin(b = 2)),  
    legend.text = element_text(size = 6),
    legend.key.size = unit(0.5, "lines")
  )+
  guides(
    color = guide_legend(position = "top"),
    shape = guide_legend(position = "bottom")
  )+ 
  scale_color_brewer(palette = "Set1") +
  geom_phylopic(  
    data = mapping_groups2,
    aes(x=long, y=lat, name = points, size=0.005), 
  ) 

dev.off()
