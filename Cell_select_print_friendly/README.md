# EWCE rare disease web app

A web app to display interactive figures and tables of the results generated from whole body analysis of human cells using EWCE to detect cell types enriched for rare disease phenotypes.

## Quickstart 
Make sure you add the phenotypes_to_genes.txt file to the data directory, download it [here](http://purl.obolibrary.org/obo/hp/hpoa/phenotype_to_genes.txt).

## Phenotype search
Search for phenotypes containing keywords using RegEx. A barchart displaying enriched phenotype counts for each cell and a dataframe of the retrieved phenotypes will be displayed.  

## Cell select
Choose a cell from dropdown menu. It will display a graph of enriched phenotypes and the "is a" relationships between them. It also gives a dataframe of the relevant results.  

## SearchByGene.R
This slowed down the app too much but can try it out. Also included a html doc of an example output.
