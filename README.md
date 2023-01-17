# Rare Disease EWCE website and apps  

## Components

### Home

The HTML, CSS, and images for the webite are stored in the `home/` directory. 
If you put the contents of this directory up as its own GitHub repo, you can then access the website using Github pages. 

It provides links to the interactive version of the cell select app, but I haven't included the print-friendly version (which uses the `ontologyPlot` package rather than `ggnetwork`).

I made it as separate apps linked from an HTML website because it ran very slowly when I included all the functionality in a single app. I think shiny apps preload everything, even if not currently in use. 

### Pheno select app

Select resutls by phenotype.

### Cell select app

Select results by cell type.

### Cell select print friendly
This is basically the same as the interactive version of the app. The plot is better suited to printing (as it has less overlapping, and the way it is laid out more clearly represents the ontology levels). However, this type of plot was not supported by `plotly` and could not be interactive. 





