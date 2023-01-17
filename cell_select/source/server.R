server <- function(input, 
                   output, 
                   session) {   
  #### Make plot ####
  ## Make function
  sig_pheno_plot_object <- shiny::reactive(
    MultiEWCE::ggnetwork_plot_full(
      phenotype_to_genes = phenotype_to_genes, 
      results = results, 
      hpo = hpo,  
      cell_type = input$sig_pheno_plot_cell_choice, 
      q_threshold = input$sig_pheno_plot_q_threshold, 
      fold_threshold = input$sig_pheno_plot_foldchange) 
  ) 
  #### Run function ####
  output$sig_pheno_plot <- plotly::renderPlotly(
      plotly::ggplotly(p = sig_pheno_plot_object()$plot, 
                       tooltip = "hover")
    ) 
  #### Download plot ####
  output$download_sig_pheno_plot <- shiny::downloadHandler(
    filename = paste0("sig_pheno_",input$sig_pheno_plot_cell_choice,Sys.Date(),".png"),
    contentType = "image/png",
    content = function(filename) {
      grDevices::png(
        filename = filename, 
        width = input$sig_pheno_plot_width,
        height = input$sig_pheno_plot_height
      )
      print(sig_pheno_plot_object())
      grDevices::dev.off()
    })
  
  output$sig_pheno_preview_text <- shiny::renderUI({
    shiny::HTML(paste(
      "<b>Figure preview</b>",
      "<i>Use side panel to download the full, high-resolution image.</i>"
    ))
  })

  shiny::updateSelectInput(session,"sig_pheno_plot_cell_choice", 
                           choices = unique(results$CellType), 
                           selected = NULL)
  
  output$sig_pheno_dataframe <- DT::renderDT(
    MultiEWCE::create_dt(dat = sig_pheno_plot_object()$phenos, 
                         buttons = "csv") 
  )
}
