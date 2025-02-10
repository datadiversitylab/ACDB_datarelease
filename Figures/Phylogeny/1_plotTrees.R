library(ape)
library(ggtree)
library(ggplot2)
library(stringr)
library(ggpubr)

# ACC data
data <- read.csv(here("Figures", "data", "class_cats.csv"))
data <- data[,c(5, 4)]
data$Ordr <- toupper(data$Ordr)

# Phylogenies
MamPhy_orders <- read.tree(here("Figures", "Phylogeny", "MamPhy_orders.tre"))
BirdPhy_orders <- read.tree(here("Figures", "Phylogeny", "BirdPhy_orders.tre"))

# Add missing classes
totalOrders <- c(MamPhy_orders$tip.label, BirdPhy_orders$tip.label)
missing_orders <- totalOrders[!totalOrders %in%  data$Ordr]
data_orders <- cbind.data.frame(Ordr = missing_orders, domains = NA)
data_complete <- rbind.data.frame(data,data_orders)

#Binarize based on domains
bin_domains <- data.frame(dcast(data_complete,Ordr~domains,fun.aggregate = function(x){as.numeric(length(x) > 0)}))
colnames(bin_domains)[11] <- "culture"
bin_domains$culture <- ifelse(bin_domains$culture == 0, 1, 0)

#Reformat dataset
col_names <- names(bin_domains)
bin_domains[,col_names] <- lapply(bin_domains[,col_names] , factor)

#Fix cases
bin_domains$Ordr <- str_to_sentence(bin_domains$Ordr)
BirdPhy_orders$tip.label <- str_to_sentence(BirdPhy_orders$tip.label)
MamPhy_orders$tip.label <- str_to_sentence(MamPhy_orders$tip.label)

#Binarize based on culture
birdData <- bin_domains[which(bin_domains$Ordr %in%  BirdPhy_orders$tip.label),]
mammalData <- bin_domains[which(bin_domains$Ordr %in%  MamPhy_orders$tip.label),]

# Plot trees
## birds
row.names(birdData) <- birdData$Ordr

t1 <- ggtree(BirdPhy_orders, layout = "fan",
             open.angle = 180) + 
  xlim(0, 150)+ 
  geom_tiplab(size=3, offset=22, align=FALSE)

##Plot of each of the domains
gheatmap(t1, birdData[,-c(1, 11)], offset=0.2, width=0.2, 
          colnames_position = "top", 
         font.size=2, color="white",
         colnames_angle = 90)+
  scale_fill_manual(values = c("grey", "red"))

##Just "culture"
smallDs <- cbind.data.frame(Culture = factor(birdData[,11]))
row.names(smallDs) <- birdData$Ordr
tn <- gheatmap(t1, smallDs, offset=0.2, width=0.1, low="white", 
         high="black", colnames_position = "top", 
         font.size=2, color="white",
         colnames_angle = 90)+
  scale_fill_manual(values = c("grey", "red"))

vertebrate_data <- data.frame(species = BirdPhy_orders$tip.label,
                              name = BirdPhy_orders$tip.label)
t2 <- revts(tn) %<+%
  vertebrate_data +
  scale_x_continuous("Time (Ma)", breaks = seq(-120, 0, 100),
                     labels = seq(120, 0, -100), limits = c(-120, 0),
                     expand = expansion(mult = 0)) +
  scale_y_continuous(guide = NULL) +
  coord_geo_radial(dat = "epochs", end = 0.5 * pi) +
  theme_classic(base_size = 16)

fPlot_birds <- ggarrange(tn, t2)

pdf(here("Figures", "Phylogeny", "Birds.pdf"), width = 15, height = 15 )
fPlot_birds
dev.off()


## mammals
row.names(mammalData) <- mammalData$Ordr

t1 <- ggtree(MamPhy_orders, layout = "fan",
             open.angle = 180) + 
  xlim(0, 300)+ 
  geom_tiplab(size=3, offset=30, align=FALSE)

##Plot of each of the domains
gheatmap(t1, mammalData[,-c(1, 11)], offset=0.2, width=0.2, 
         colnames_position = "top", 
         font.size=2, color="white",
         colnames_angle = 90)+
  scale_fill_manual(values = c("grey", "red"))

##Just "culture"
smallDs <- cbind.data.frame(Culture = factor(mammalData[,11]))
row.names(smallDs) <- mammalData$Ordr
tn <- gheatmap(t1, smallDs, offset=0.2, width=0.1, low="white", 
               high="black", colnames_position = "top", 
               font.size=2, color="white",
               colnames_angle = 90)+
  scale_fill_manual(values = c("grey", "red"))

vertebrate_data <- data.frame(species = MamPhy_orders$tip.label,
                              name = MamPhy_orders$tip.label)
t2 <- revts(tn) %<+%
  vertebrate_data +
  scale_x_continuous("Time (Ma)", breaks = seq(-200, 0, 100),
                     labels = seq(200, 0, -100), limits = c(-200, 0),
                     expand = expansion(mult = 0)) +
  scale_y_continuous(guide = NULL) +
  coord_geo_radial(dat = "epochs", end = 0.5 * pi) +
  theme_classic(base_size = 16)

fPlot_Mammals <- ggarrange(tn, t2)

pdf(here("Figures", "Phylogeny", "Mammals.pdf"), width = 15, height = 15 )
fPlot_Mammals
dev.off()


