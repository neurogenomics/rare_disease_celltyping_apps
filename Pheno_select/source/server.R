server <- function(input, output, session) {


  keywords_list <- reactive(process_search_terms(input$keywords)) # RegEx expression
  output$keywords_text <- renderText( paste("Search pattern (RegEx):", keywords_list()))
  keyword_dataframe_object <- reactive(keyword_search_df(keywords_list(), q_threshold = input$pheno_search_q_threshold,
                                                         fold_threshold = input$pheno_search_foldchange,
                                                         min_sd_from_mean = input$pheno_search_sd_from_mean))
  keyword_plot_object <- reactive(plot_phenotype_counts(keyword_dataframe_object(), input$keywords))
  output$keyword_plot <- renderPlotly(plot_phenotype_counts(keyword_dataframe_object(), input$keywords))
  output$keyword_df <- renderDT(keyword_dataframe_object())
  output$pheno_search_download <- downloadHandler(
    filename =paste0("Phenotype_search_",Sys.Date(),".png"),
    content = function(filename) {
      png(filename, width = input$pheno_search_width, height = input$pheno_search_height)
      print(keyword_plot_object())
      dev.off()
    },
  contentType = "image/png")


  }
