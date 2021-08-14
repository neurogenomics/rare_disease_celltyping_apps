ui <- fluidPage(style="padding:0px;",
  theme = shinytheme(theme = "cerulean"),
  
      tabPanel("Phenotype search",
               sidebarLayout(
                 sidebarPanel("Search Phenotypes",
                              br(),
                              a("Explore ontology", href="https://hpo.jax.org/app/browse/term/HP:0000001"),
                              textInput("keywords", "Enter search terms separated by comma",
                                        value = "weight, exercise"),
                              numericInput("pheno_search_q_threshold", "q-value threshold", value = 0.005,min = 0,max =1,step=0.0005),
                              numericInput("pheno_search_foldchange", "Minimum expression fold change", value = 1),
                              numericInput("pheno_search_sd_from_mean", "Minimum standard deviations from mean", value = 0),
                              sliderInput("pheno_search_width", "Download image width (px)",
                                          min = 400, max = 4000, value = 600, step = 100),
                              sliderInput("pheno_search_height", "Download image height (px)",
                                          min = 400, max = 4000, value = 600, step = 100),
                              downloadLink("pheno_search_download", "Download figure"),
                              width = 2
                              ),
                 mainPanel(
                   #tabsetPanel(
                     #tabPanel("Figure",
                              #textOutput("keywords_text"),
                              plotlyOutput("keyword_plot"),#),
                     #tabPanel("Data",
                              br(),
                              DTOutput("keyword_df")#),
                     #tabPanel("Info")
                   #)
                   )
                   ))


)
