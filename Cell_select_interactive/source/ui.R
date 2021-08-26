ui <- fluidPage(style="padding:0px;",
  theme = shinythemes::shinytheme(theme = "cerulean"),

  navbarPage("Rare Disease EWCE",

            tabPanel("Cell Select",
               sidebarLayout(
                   sidebarPanel("Enriched phenotypes by cell",
                      selectInput("sig_pheno_plot_cell_choice","Select cell", choices= NULL, selected = NULL),
                      numericInput("sig_pheno_plot_q_threshold", "q-value threshold", value = 0.005,min = 0,max =1,step=0.0005),
                      numericInput("sig_pheno_plot_foldchange", "Minimum expression fold change", value = 1),
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
                     plotlyOutput("sig_pheno_plot"),
                     DT::DTOutput("sig_pheno_dataframe")
                     ))

            ), # cell select tabPanel bracket

     tabPanel("About" ,
              fluidRow(
                h2("Links", align="center"),
                div(align="center",
                    actionButton(inputId="homeLink", label = "Home",width = "150px", icon=icon("home"),
                                  onclick = "window.open('http://google.com', '_blank')"),
                    actionButton("HPO", label = "HPO", width = "150px",icon=icon("male"),
                                 onclick="window.open('https://hpo.jax.org/app/browse/term/HP:0000001')"),
                    actionButton("Descartes", label = "Descartes",width="150px",icon=icon("dna"),
                                 onclick="window.open('https://descartes.brotmanbaty.org/')"),
                    actionButton("Neurogenomics Lab", label = "Neurogenomics",width="150px",icon=icon("globe"),
                               onclick="window.open('https://www.neurogenomics.co.uk/')"),
                    actionButton("Neurogenomics Lab", label = "Github",width="150px",icon=icon("github"),
                               onclick="window.open('https://github.com/neurogenomics/')")
                  ),
                h2("About", align = "center"),
                p("Expression weighted cell-type enrichment (EWCE) analysis was performed with 100000 reps on
                  over 9000 rare disease associated gene sets from the Human phenotype ontology (HPO).
                  Human scRNA-seq data was obtained from the Descartes human cell atalas. This allows us to
                  identify the cell types that are significnatly associated with the primary genetic susceptibility
                  for the disease. This site provides resources for retrieving subsets of the results, allowing
                  specialists to make use of findings related to their field of study.", align = "center"),
                br(),
                p("This Cell select app allows you to select a cell type of interest, and set significance and fold
                  change thresholds to retrieve subsets of the results and produce an interactive graph generated
                  using ggnetwork, ggplot and some bespoke functions, for visualisation.", align = "center")
                )
              )#, #<- links tabPanel bracket

     # tabPanel("About",
     #          h2("About"),
     #          p("describe the cell select app, provide, links to descarets etc.."),
     #          ) #<- About tab panel

  ) # <- navbarpage
)
