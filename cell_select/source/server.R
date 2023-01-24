server <- function(input, 
                   output, 
                   session) {
  
  output$sig_pheno_preview_text <- shiny::renderUI({
    shiny::HTML(paste(
      "<b>Figure preview</b>",
      "<i>Use side panel to download the full, high-resolution image.</i>"
    ))  
  })
    
  #### Update celltype options in #### 
  update_choices <- function(selected=input$sig_pheno_plot_cell_choice){
    celltypes <- sort(unique(
      results[q <= input$sig_pheno_plot_q_threshold &
                fold_change >= input$sig_pheno_plot_foldchange,]$CellType))  
    shiny::updateSelectInput(session, "sig_pheno_plot_cell_choice",
                             choices = celltypes,
                             selected = selected)
  }
 
  run_task <- function(){ 
    withProgress(
      
      message='Please wait',
      detail='Creating network plot...',
      value=0, {
        n <- 3
        incProgress(1/n, detail = "Updating dropdown options.")
        update_choices()
        incProgress(2/n, detail = "Constructing network.")
        res <- MultiEWCE::ggnetwork_plot_full(
          phenotype_to_genes = phenotype_to_genes, 
          results = results, 
          hpo = hpo,  
          cell_type = input$sig_pheno_plot_cell_choice, 
          q_threshold = input$sig_pheno_plot_q_threshold, 
          fold_threshold = input$sig_pheno_plot_foldchange) 
        
        # incProgress(2/n, detail = "Checking results.")
        # if(nrow(res$phenos)==0){
        #   stop("No rows left in data after filtering.")
        # }
        incProgress(3/n, detail = "Finished constructing network.") 
      })
   
    #### Make plot ####
    output$sig_pheno_plot <- plotly::renderPlotly({res$plot})  
    #### Render table #####
    output$sig_pheno_dataframe <- DT::renderDT(
      MultiEWCE::create_dt(dat = res$phenos[,-c("hover")], 
                           buttons = c("copy", "csv", "excel") ) 
    )
    ##### Download table ####
    #### Download plot ####
    output$download_sig_pheno_plot <- shiny::downloadHandler(
      filename = paste0("sig_pheno_",
                        input$sig_pheno_plot_cell_choice,Sys.Date(),
                        ".png"),
      contentType = file.path("image","png"),
      content = function(filename) {
        grDevices::png(
          filename = filename, 
          width = input$sig_pheno_plot_width,
          height = input$sig_pheno_plot_height
        )
        methods::show(res$phenos)
        grDevices::dev.off()
      })
  }
  shiny::observe({ 
    run_task()
  })
  shiny::reactive({    
    run_task() 
  })  
}
