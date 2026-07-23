#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      14/11/2025                             ##
##                  Creating a ShinyApp                        ##
##                        Global.R                             ##
##        code by Diego Panici (d.panici@exeter.ac.uk)         ##
#################################################################


# G1 Load large wood, river, and bridge data ----
# lw_points <- st_read("C:/Users/jp780/OneDrive - University of Exeter/Documents/GSS/GEOM184-GIS/wk08/LW_layer.shp")
# river <- st_read("C:/Users/jp780/OneDrive - University of Exeter/Documents/GSS/GEOM184-GIS/wk08/RiverExe.shp")
# bridges <- st_read("C:/Users/jp780/OneDrive - University of Exeter/Documents/GSS/GEOM184-GIS/wk08/BridgesExe.shp")
lw_points <- st_read("LW_layer.shp")
river <- st_read("RiverExe-dissolved.shp")
bridges <- st_read("BridgesExe.shp")

#Convert vectors to CRS 4326
# lw_points <- st_transform(lw_points, crs = 4326)
lw_points <- st_transform(lw_points, crs = 3857)
lw_coords <- st_coordinates(lw_points)
river <- st_transform(river, crs = 4326)
river <- st_union(river)
river <- st_sf(geometry=st_sfc(river), crs=4326)
bridges <- st_transform(bridges, crs = 4326)

# Perform clustering
clusters <- st_read("clusters.shp")
clusters <- st_transform(clusters, crs = 4326)

# Mitigation spots
mitigation_zones <- st_read("mitigation_zones.shp")
mitigation_zones <- st_transform(mitigation_zones, crs = 4326)

# Dynamically generate colours based on number of unique clusters
num_clusters <- length(unique(clusters$CLUSTER_ID))
pal_clusters <- colorFactor(palette = colorRampPalette(brewer.pal(12, "Paired"))(num_clusters), domain = clusters$CLUSTER_ID)

# Load the heatmap
heatmap <- rast("heatmap.tif")
heatmap <- project(heatmap, crs(river))
pal_heatmap <- colorNumeric(palette = "inferno", domain = na.omit(values(heatmap)), na.color = "transparent")
