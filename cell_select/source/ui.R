ui <- fluidPage(style="padding:0px;",
  theme = shinythemes::shinytheme(theme = "simplex"),

  navbarPage(a(href="https://neurogenomics.github.io/rare_disease_celltyping_apps/home/",
               "Rare Disease Celltyping"),

            tabPanel("Cell Select app",
               sidebarLayout(
                   sidebarPanel(
                     h4("Enriched phenotypes by cell type"), 
                      selectInput(inputId = "sig_pheno_plot_cell_choice",
                                  label = "Select cell type",
                                  choices = c("Microglia"),
                                  selected = "Microglia"),
                      selectInput(inputId = "sig_pheno_plot_ctd_choice",
                                  label = "Select cell type reference",
                                  choices = c("DescartesHuman",
                                              "HumanCellLandscape"),
                                  selected = "DescartesHuman"),
                      numericInput(inputId = "sig_pheno_plot_q_threshold", 
                                   label = "q-value threshold", 
                                   value = 0.0005,
                                   min = 0,max =1,step=0.0005),
                      numericInput(inputId = "sig_pheno_plot_foldchange",
                                   label ="Minimum expression fold change",
                                   value = 1),
                      #selectInput("sig_pheno_plot_heatmap", "Select heatmap", choices= c("fold change", "q","p"), selected = "fold change"),
                      #sliderInput("sig_pheno_plot_resolution", "Download image resolution (px)",
                      #            min = 400, max = 4000, value = 400, step = 100),
                      sliderInput("sig_pheno_plot_height", "Download image height (px)",
                                  min = 400, max = 4000, value = 1500, step = 100),
                      sliderInput("sig_pheno_plot_width", "Download image width (px)",
                                  min = 400, max = 4000, value = 1500, step = 100),
                      downloadLink("download_sig_pheno_plot", "Download figure"),
                      width=2
                      ),
                   mainPanel(
                     shiny::h4(uiOutput('sig_pheno_plot_cell_choice')),
                     plotly::plotlyOutput("sig_pheno_plot", height = "600px"),
                     DT::DTOutput("sig_pheno_dataframe"),
                     shiny::hr()
                     ))

            ), # cell select tabPanel bracket

     tabPanel("About" ,
              fluidRow(
                shiny::column(width = 8,offset = 2,
                  div(align="center",
                      h2("Links", align="center"),
                      actionButton(inputId="homeLink", label = "Home",width = "150px", icon=icon("home"),
                                    onclick = "window.open('http://google.com', '_blank')"),
                      actionButton("HPO", label = "HPO", width = "150px",icon=icon("male"),
                                   onclick="window.open('https://hpo.jax.org')"),
                      actionButton("Descartes", label = "Descartes",width="150px",icon=icon("dna"),
                                   onclick="window.open('https://descartes.brotmanbaty.org/bbi/human-gene-expression-during-development/')"), 
                      actionButton("Human Cell Landscape", label = "HCL",width="150px",icon=icon("dna"),
                                   onclick="window.open('https://db.cngb.org/HCL/')"), 
                      actionButton("Neurogenomics Lab", label = "Neurogenomics Lab",width="200px",icon=icon("globe"),
                                 onclick="window.open('https://www.neurogenomics.co.uk/')"),
                      actionButton("Github", label = "Github",width="200px",icon=icon("github"),
                                 onclick="window.open('https://github.com/neurogenomics/rare_disease_celltyping_apps')")
                    ),
                  div(align="center",
                    h2("About", align = "center"), 
                    h4(
                      a(href="https://bioconductor.org/packages/EWCE", 
                        "Expression Weighted Cell-type Enrichment (EWCE)"),
                     "analysis was performed with 100,000 reps on
                      over 9,000 rare disease associated gene sets from the",
                     a(href="https://hpo.jax.org/", "Human Phenotype Ontology (HPO)"),
                      "Human scRNA-seq data was obtained from the",
                     a(href="https://descartes.brotmanbaty.org/bbi/human-gene-expression-during-development/",
                       "Descartes human cell atalas."), "and",
                     a(href="https://db.cngb.org/HCL/",
                       "Human Cell Landscape"),".",
                      "This allows us to
                      identify the cell types that are significnatly associated with the primary genetic susceptibility
                      for the disease. This site provides resources for retrieving subsets of the results, allowing
                      specialists to make use of findings related to their field of study.", align = "center"),
                    br(),
                    h4("This Cell Select app allows you to select a cell type of interest, and set significance and fold
                      change thresholds to retrieve subsets of the results and produce an interactive graph generated
                      using ggnetwork, ggplot and some bespoke functions, for visualisation.", align = "center")
                    )
                  )
                )
              )#, #<- links tabPanel bracket
 
  ) # <- navbarpage
)
