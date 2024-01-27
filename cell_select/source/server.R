server <- function(input, 
                   output, 
                   session) {
  method = "ggnetwork"
  shiny::updateSelectInput(inputId = "sig_pheno_plot_cell_choice",
                           choices = celltypes,
                           selected = celltypes[[1]])
  #### Update celltype options in #### 
  update_choices <- function(selected=input$sig_pheno_plot_cell_choice){
    if(!is.null(input$sig_pheno_plot_foldchange)){
      celltypes <- sort(unique(
        results[q <= input$sig_pheno_plot_q_threshold &
                fold_change >= input$sig_pheno_plot_foldchange &
                ctd == input$sig_pheno_plot_ctd_choice,]$CellType
          )
        )  
      shiny::updateSelectInput(session, "sig_pheno_plot_cell_choice",
                               choices = celltypes,
                               selected = selected)
    } 
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
          # results = results, 
          hpo = hpo, 
          interactive=TRUE,
          method = method,
          filters = list(CellType = input$sig_pheno_plot_cell_choice,
                         ctd = input$sig_pheno_plot_ctd_choice), 
          q_threshold = input$sig_pheno_plot_q_threshold, 
          fold_threshold = input$sig_pheno_plot_foldchange) 
        
        # incProgress(2/n, detail = "Checking results.")
        # if(nrow(res$data)==0){
        #   stop("No rows left in data after filtering.")
        # }
        incProgress(3/n, detail = "Finished constructing network.") 
      })
   
    #### Make plot ####
    if(method=="ggnetwork"){
      output$sig_pheno_plot <- plotly::renderPlotly({res$plot})    
    } else {
      output$sig_pheno_plot <- visNetwork::renderVisNetwork({res$plot})
    }
    
    # output$sig_pheno_plot_cell_choice  <- shiny::renderUI({
    #   
    # })
    #### Render table #####
    output$sig_pheno_dataframe <- DT::renderDT(
      MultiEWCE::create_dt(dat = KGExplorer::graph_to_dt(res$data), 
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
  # shiny::reactive({    
  #   run_task() 
  # })  
}
