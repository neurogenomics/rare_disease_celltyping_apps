server <- function(input, 
                   output, 
                   session) {

  keywords_list <- reactive(
    # RegEx expression
    process_search_terms(input$keywords)
  )
  output$keywords_text <- renderText( 
    paste("Search pattern (regex):", keywords_list())
  )
  keyword_dataframe_object <- reactive(
    keyword_search_df(Terms = keywords_list(), 
                      q_threshold = input$pheno_search_q_threshold,
                      fold_threshold = input$pheno_search_foldchange,
                      min_sd_from_mean = input$pheno_search_sd_from_mean)
  )
  keyword_plot_object <- reactive(
    plot_phenotype_counts(DF = keyword_dataframe_object(),
                          keywords = input$keywords)
  )
  output$keyword_plot <- plotly::renderPlotly(
    plot_phenotype_counts(DF = keyword_dataframe_object(), 
                          keywords = input$keywords)
  )
  output$keyword_df <- DT::renderDT(
    create_dt(dat = keyword_dataframe_object(),
              buttons = c("csv","excel"))
  )
  output$pheno_search_download <- downloadHandler(
    filename = paste0("Phenotype_search_",Sys.Date(),".png"),
    content = function(filename) {
      grDevices::png(filename = filename, 
                     width = input$pheno_search_width, 
                     height = input$pheno_search_height)
      print(keyword_plot_object())
      grDevices::dev.off()
    },
  contentType = file.path("image","png")) 
}
