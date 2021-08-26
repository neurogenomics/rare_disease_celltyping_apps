server <- function(input, output, session) {
  
  sig_pheno_plot_object <- reactive(ggnetwork_plot_full(phenotype_to_genes = phenotype_to_genes, 
                                                        all_results_merged = all_results_merged, 
                                                        hpo = hpo, 
                                                        disease_descriptions = disease_descriptions, 
                                                        cell_type = input$sig_pheno_plot_cell_choice, 
                                                        q_threshold = input$sig_pheno_plot_q_threshold, 
                                                        fold_threshold = input$sig_pheno_plot_foldchange))
  

  
  output$sig_pheno_plot <- plotly::renderPlotly(
      plotly::ggplotly(sig_pheno_plot_object(), tooltip = "hover")
    )
  
  
  
  output$download_sig_pheno_plot <- downloadHandler(
                                        filename = paste0("sig_pheno_",input$sig_pheno_plot_cell_choice,Sys.Date(),".png"),
                                        content = function(filename) {
                                        png(filename, width = input$sig_pheno_plot_width, height = input$sig_pheno_plot_height)
                                        print(sig_pheno_plot_object())
                                        dev.off()
                                        }, contentType = "image/png")
  
  output$sig_pheno_preview_text <- renderUI({HTML("<b>Figure preview</b> <i>Use side panel to download the full, high resolution image</i>")})

  updateSelectInput(session,"sig_pheno_plot_cell_choice", 
                    choices = unique(all_results_merged$CellType), selected =NULL)
  
  output$sig_pheno_dataframe <- DT::renderDT(get_cell_ontology(cell = input$sig_pheno_plot_cell_choice,
                                                               results = all_results_merged,
                                                               q_threshold = input$sig_pheno_plot_q_threshold,
                                                               fold_threshold = input$sig_pheno_plot_foldchange,
                                                               phenotype_to_genes = phenotype_to_genes, 
                                                               hpo = hpo ))

  }
