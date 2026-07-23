#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      14/11/2025                             ##
##                  Creating a ShinyApp                        ##
##                       Server.R                              ##
##        code by Diego Panici (d.panici@exeter.ac.uk)         ##
#################################################################

# S1 Render leaflet map ----
# Leaflet map output

# Add popups for large wood points
observe({
  leafletProxy("map") %>%
    clearMarkers() %>%
    addCircleMarkers(data = mitigation_zones,
                     color = "black",
                     fillColor="red",
                     fillOpacity=0.7,
                     weight = 1,
                     radius = 10,
                     stroke=TRUE,
                     popup = ~paste("<b>Mitigation zone:</b>", zone_name),
                     group = "Mitigation Zones") %>%
    addCircleMarkers(data = clusters, fillColor = ~pal_clusters(CLUSTER_ID), color = "black",
                     weight = 1, radius = 5, stroke = TRUE, fillOpacity = 0.7,
                     popup = ~paste("<b>Type:</b>", LW_Type, "<br><b>Cluster ID:</b>", CLUSTER_ID),
                     group = "Large Wood")
})


output$map <- renderLeaflet({
  leaflet() %>% 
    setView(lng=-3.506037, lat=50.790392, zoom=11.3) %>%
    addProviderTiles (providers$OpenStreetMap, group = "Colour") %>%
    addPolylines(data = river, color = "blue", weight = 2, opacity = 0.8, group = "River") %>%
    addCircles(data = bridges,
               color = "black",
               fillColor="purple",
               fillOpacity=0.8,
               weight = 2,
               radius = 50,
               popup = ~paste("<b>Bridge Name:</b>", BRIDGE.NAM),
               group = "Bridges") %>%
    addRasterImage(heatmap, colors = pal_heatmap, opacity = 0.7, group = "Heatmap") %>%
    # addImageQuery(
    #   heatmap,
    #   layerId = "Heatmap",
    #   prefix = "Value: ",
    #   digits = 2,
    #   position = "topright",
    #   type = "mousemove",  # Show values on mouse movement
    #   options = queryOptions(position = "topright"),  # Remove the TRUE text
    #   group = "Heatmap"
    # )
    addLayersControl(
      # baseGroups = c("Colour"),
      overlayGroups = c("River", "Bridges", "Nearest distance", "Large Wood", "Heatmap", "Mitigation Zones"),
      options = layersControlOptions(collapsed = FALSE)
    )
})

