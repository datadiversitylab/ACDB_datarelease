library(reshape2)
library(here)
library(ape)
#devtools::install_github("daijiang/rtrees")
#library(rtrees)

tree <- read.nexus(here("Figures", "Phylogeny", "MamPhy_fullPosterior_BDvr_Completed_5911sp_topoCons_NDexp_MCC_v2_target.tre"))

# Mammals
## Assemble an ordinal tree
tips<-tree$tip.label
order<-unique(sapply(strsplit(tips,"_"),function(x) x[4]))
ii<-sapply(order,function(x,y) grep(x,y)[1],y=tips)
tree<-drop.tip(tree,setdiff(tree$tip.label,tips[ii]))
tree2 <- tree
newtips<-sapply(strsplit(tree2$tip.label,"_"),function(x) x[4])
tree2$tip.label <- newtips

write.tree(tree2, here("Figures", "Phylogeny", "MamPhy_orders.tre"))

#Birds
##Assemble an ordinal tree
load(here("Figures", "Phylogeny", "tree_bird_ericson.rda"))
tax <- read.csv( here("Figures", "Phylogeny", "BLIOCPhyloMasterTax.csv"))
tspecies <- tax[!duplicated(tax$IOCOrder),]
tspecies$Scientific <- sub(" ", "_", tspecies$Scientific)
all(tspecies$Scientific %in% tree_bird_ericson$tip.label) #check all species are in the dataset
to_drop <- tree_bird_ericson$tip.label[!tree_bird_ericson$tip.label  %in% tspecies$Scientific]
subset_orders <- drop.tip(tree_bird_ericson, to_drop)
newtips <- sapply(subset_orders$tip.label, function(i)   tspecies[which(i == tspecies$Scientific),"IOCOrder"])
subset_orders$tip.label <- newtips
write.tree(subset_orders, here("Figures", "Phylogeny", "BirdPhy_orders.tre"))
