# microeco v0.15.0
library(microeco)
library(igraph)
# fix random seed
set.seed(123)

# read file
filename <- "test1.csv"
rawfile <- read.csv(filename, stringsAsFactors = FALSE)
# get all nodes
allnodes <- unique(c(rawfile[, 1], rawfile[, 2]))
# create square matrix
adj <- matrix(data = 0, nrow = length(allnodes), ncol = length(allnodes))
rownames(adj) <- allnodes
colnames(adj) <- allnodes
# assign values to matrix
for(i in 1:nrow(rawfile)){
  adj[rawfile[i, 1], rawfile[i, 2]] <- 1
}
# create directed network with igraph package; for undirected network: mode = "undirected"
# network <- graph.adjacency(adj, mode = "undirected")
network <- graph.adjacency(adj, mode = "directed")
# assign "colour" to edge attribute
edges <- t(sapply(1:ecount(network), function(x) ends(network, x)))
E(network)$colour <- unlist(lapply(seq_len(nrow(edges)), function(x) rawfile[rawfile[, 1] == edges[x, 1] & rawfile[, 2] == edges[x, 2], "colour"]))
# assing weight 1 to edge attribute
E(network)$weight <- rep.int(1, ecount(network))

# for microeco v0.15.0
# create trans_network with customized data for the following analysis
network_obj <- trans_network$new(dataset = NULL)
network_obj$taxa_level <- "OTU"
# assign network the object
network_obj$res_network <- network
# partition modules
# other options for directed network: "cluster_edge_betweenness", "cluster_infomap" ...
# for undirected network: "cluster_fast_greedy" ...
network_obj$cal_module(method = "cluster_walktrap")
# calculate all node topological properties
network_obj$get_node_table(node_roles = TRUE)
head(network_obj$res_node_table)
# filter NA
# node_table <- network_obj$res_node_table
# node_table <- subset(node_table, !is.na(z) & !is.na(p))
# network_obj$res_node_table <- node_table
# plot zipi
network_obj$plot_taxa_roles()
# add node attribute
V(network_obj$res_network)$roles <- network_obj$res_node_table$taxa_roles
# save network to gexf format
network_obj$save_network(filepath = "network.gexf")




# microeco v0.15.0
library(microeco)
library(igraph)
# fix random seed
s