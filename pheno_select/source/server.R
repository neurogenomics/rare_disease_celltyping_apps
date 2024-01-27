server <- function(input, 
                   output, 
                   session) {

  keywords_list <- reactive({
    input$keywords
  })
  
  output$keywords_text <- renderText( 
    paste("Search pattern (regex):", keywords_list())
  )
  
  keyword_dataframe_object <- reactive({
    keyword_search_df(results = results,
                      keywords = keywords_list(), 
                      filters = list(ctd = input$ctd_selection),
                      q_threshold = input$q_threshold,
                      fold_threshold = input$fold_threshold,
                      min_sd_from_mean = input$min_sd_from_mean)
  })
  
  keyword_plot_object <- reactive({
    MultiEWCE::plot_bar_summary(results = keyword_dataframe_object(), 
                                keywords = input$keywords,
                                count_var = "hpo_name", 
                                group_var = "CellType",
                                show_plot = FALSE) 
  })
  
  output$keyword_plot <- plotly::renderPlotly({
    MultiEWCE::plot_bar_summary(results = keyword_dataframe_object(),
                                keywords = input$keywords,
                                count_var = "hpo_name", 
                                group_var = "CellType",
                                show_plot = FALSE) 
  })
  
  output$keyword_df <- DT::renderDT(
    MultiEWCE::create_dt(dat = keyword_dataframe_object(),
                         buttons = c("csv","excel"))
  )
  
  output$pheno_search_download <- downloadHandler(
    filename = paste0("Phenotype_search_",Sys.Date(),".png"),
    content = function(filename) {
      grDevices::png(filename = filename, 
                     width = input$pheno_search_width, 
                     height = input$pheno_search_height)
      methods::show(keyword_plot_object())
      grDevices::dev.off()
    },
  contentType = file.path("image","png")) 
}
