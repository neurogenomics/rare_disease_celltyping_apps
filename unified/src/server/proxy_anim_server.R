dataan <- reactive({
  set.seed(2)
  results <- MultiEWCE::load_example_results(multi_dataset = TRUE, 
                                             save_dir = "data") 
  results2 <- results[input$ctd_selection %in% ctd,]
  celltypes <- unique(results2$celltypes)  
  celltype_selection <- if(!input$celltype_selection %in% celltypes){
    message("Selecting new valid input:",celltypes[1])
    celltypes[1]
  } else{
    input$celltype_selection
  }
  results3 <- MultiEWCE::subset_phenos(results = results2, 
                                       q_threshold = input$q_threshold,
                                       fold_threshold = input$fold_threshold,
                                       filters = list(CellType = celltype_selection)
  )
  return(
    list(data=results3,
         celltypes=celltypes,
         celltype_selection=celltype_selection)
  )
})

 
output$network_proxy_focus <- renderVisNetwork({  
  out <- dataan()
  # updateSelectInput(inputId = "celltype_selection",
  #                   selected = out$celltype_selection,
  #                   choices = out$celltypes) 
  MultiEWCE::ggnetwork_plot_full(results = out$data, 
                                 filters = list(CellType = input$celltype_selection,
                                                ctd = input$ctd_selection),
                                 q_threshold = input$q_threshold,
                                 fold_threshold = input$fold_threshold,
                                 method = "visnetwork", 
                                 show_plot = FALSE)$plot
})

observeEvent(input$ctd_selection, {
  celltypes <- dataan()$celltypes
  updateSelectInput(inputId = "celltype_selection",
                    selected = celltypes[1],
                    choices = celltypes) 
  showNotification("CellType options were updated.")
}, priority = 1)


observe({
  out <- dataan()
  # updateSelectInput(inputId = "celltype_selection",
  #                   selected = out$celltype_selection,
  #                   choices = out$celltypes) 
  isolate({
    MultiEWCE::ggnetwork_plot_full(results = out$data,
                                   filters = list(CellType = input$celltype_selection, 
                                                  ctd = input$ctd_selection),
                                   q_threshold = input$q_threshold,
                                   fold_threshold = input$fold_threshold,
                                   method = "visnetwork",
                                   show_plot=FALSE)
  })
})

# output$code_proxy_focus  <- renderText({
#   '
# observe({
#   visNetworkProxy("network_proxy_focus") %>%
#     visFocus(id = input$Focus, scale = input$scale_id)
# })
# 
# observe({
#   gr <- input$Group
#   isolate({
#     if(gr != "ALL"){
#       nodes <- dataan()$nodes
#       id <- nodes$id[nodes$group%in%gr]
#     }else{
#       id <- NULL
#     }
#     visNetworkProxy("network_proxy_focus") %>%
#       visFit(nodes = id)
#   })
# })
#  '
# })