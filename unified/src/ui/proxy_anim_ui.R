shiny::tabPanel(
  title = "Cell Select",
  fluidRow(
    column(
      width = 4, 
      selectInput(inputId="celltype_selection", 
                  label="Select CellType :",
                  selected = "Microglia",
                  choices=c("Microglia","Astrocytes")),
      selectInput(inputId="ctd_selection", 
                  label="Select CellTypeDataset :",
                  selected = "DescartesHuman",
                  choices=c("DescartesHuman","HumanCellLandscape")),
      numericInput(inputId="q_threshold", 
                  label="Select maximum q-value:", 
                  min = 0, max = 1, value = 0.05, step = 0.01),
      numericInput(inputId="fold_threshold", 
                   label="Select minimum fold-change:", 
                   min = -100, max = 100, value = 1, step = .5) 
      ),
    column(
      width = 8,
      visNetworkOutput(outputId = "network_proxy_focus", height = "400px")
    )
  )
  # verbatimTextOutput("code_proxy_focus")
  
)

