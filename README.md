Rare Disease Celltyping apps
================
<h4> ¶ Creators: ¶ </h4> ¶ Bobby Gordon-Smith, Jai Chapman, Brian M.
Schilder, Nathan G. Skene
<h4> ¶ README updated: <i>Jan-24-2023</i> ¶ </h4>

## Components

### [Home page](https://neurogenomics.github.io/rare_disease_celltyping_apps/home)

The HTML, CSS, and images for the website are stored in the `home/`
directory. If you put the contents of this directory up as its own
GitHub repo, you can then access the website using Github pages.

It provides links to the interactive version of the cell select app, but
I haven’t included the print-friendly version (which uses the
`ontologyPlot` package rather than `ggnetwork`).

### [Pheno select app](https://neurogenomics.shinyapps.io/pheno_select)

Select results by phenotype.

### [Cell select app](https://neurogenomics.shinyapps.io/cell_select/)

Select results by cell type. Currently uses the [version originally
created](https://ovrhuman.shinyapps.io/Cell_select_ggnetwork/) by
@bobGSmith.

### [Cell select print friendly](https://ovrhuman.shinyapps.io/Cell_select_ggnetwork/)

This is basically the same as the interactive version of the app. The
plot is better suited to printing (as it has less overlapping, and the
way it is laid out more clearly represents the ontology levels).
However, this type of plot was not supported by `plotly` and could not
be interactive.

## Contact

### [Neurogenomics Lab](https://www.neurogenomics.co.uk/)

UK Dementia Research Institute  
Department of Brain Sciences  
Faculty of Medicine  
Imperial College London  
[GitHub](https://github.com/neurogenomics)  
[DockerHub](https://hub.docker.com/orgs/neurogenomicslab)

<br>
