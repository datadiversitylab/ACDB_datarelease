library(ape)
library(diversitree)
library(ggtree)

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
bin_domains <- dcast(data_complete,Ordr~domains,fun.aggregate = function(x){as.integer(length(x) > 0)})
colnames(bin_domains)[11] <- "Culture"
bin_domains$Culture <- factor(ifelse(bin_domains$Culture == 0, 1, 0))

#Binarize based on culture
birdData <- bin_domains[which(bin_domains$Ordr %in%  BirdPhy_orders$tip.label),]
mammalData <- bin_domains[which(bin_domains$Ordr %in%  MamPhy_orders$tip.label),]

# Generate trees
## birds
### diversitree
row.names(birdData) <- birdData$Ordr

trait.plot(ladderize(BirdPhy_orders, right=FALSE), birdData, type="p",
           cols=list(antipredation=c("white", "black"), architecture=c("white", "black"),
                     foraging=c("white", "black"), mating=c("white", "black"), migration=c("white", "black"),
                     other=c("white", "black"), play = c("white", "black"), social = c("white", "black")), cex.lab=1)


trait.plot(ladderize(BirdPhy_orders, right=FALSE), birdData, type="p",
           cols=list(Culture=c("white", "black")), cex.lab=1)


### ggtree
t1 <- ggtree(BirdPhy_orders) + 
  xlim(0, 150) +
  geom_tiplab(size=2, offset=25)

gheatmap(t1, birdData[,-c(1, 11)], offset=0.2, width=0.2, low="white", 
         high="black", colnames_position = "top", 
         font.size=2, color="black",
         colnames_angle = 90)

gheatmap(t1, birdData[,c(10, 11)], offset=0.2, width=0.2, low="white", 
         high="black", colnames_position = "top", 
         font.size=2, color="black",
         colnames_angle = 90)



## mammals
row.names(mammalData) <- mammalData$Ordr

trait.plot(ladderize(MamPhy_orders, right=FALSE), mammalData, type="p",
           cols=list(antipredation=c("white", "black"), architecture=c("white", "black"),
                     foraging=c("white", "black"), mating=c("white", "black"), migration=c("white", "black"),
                     other=c("white", "black"), play = c("white", "black"), social = c("white", "black")), cex.lab=1)


trait.plot(ladderize(MamPhy_orders, right=FALSE), mammalData, type="p",
           cols=list(Culture=c("white", "black")), cex.lab=1)



