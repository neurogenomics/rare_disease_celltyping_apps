
# Plot ontology associated with cell type - issue 10 ###########################


library(ontologyPlot)
library(ontologyIndex)
data(hpo)


# Try this data instead? -
# hpo = get_OBO("data/hp.obo", propagate_relationships = "is_a", extract_tags = "minimal")

# # (not needed?)
phenotype_to_genes = data.table::fread(input = "data/phenotype_to_genes.txt",
                                        skip = 1, header=FALSE,
                                        col.names = c("ID", "Phenotype", "EntrezID", "Gene",
                                                      "Additional", "Source", "LinkID"))
# # load ewce results (not needed?)
all_results_merged <- readRDS("data/Descartes_All_Results.rds")


## Functions ####################################################################



#' Subset RD EWCE results data by cell type, fold change and q value
#'
#' I have written similar functions in other scripts in the source, but I think
#' this is the one I reference most often. May be worth checking through for redundancies.
#' directory. This also adds a HPO term id column for the subset though.
#' @param cell The cell type of interest <string>
#' @param q_threshold The q value threshold of significance
#' @param fold_threshold The fold change threshold
#' @param phenotype_to_genes The HPO Ids with associated gene lists downloaded from HPO website
#' @param hpo The HPO Ontology data object
#' @returns A data frame of the selected subset of RD EWCE results with HPO ID column added.
#' @export
get_cell_ontology = function(cell, 
                             results, 
                             q_threshold, 
                             fold_threshold, 
                             phenotype_to_genes,hpo){
  
  message("get_cell_ontology")
  phenotype_to_genes = data.table::fread(input = "data/phenotype_to_genes.txt", 
                                         skip = 1, 
                                         header=FALSE, 
                                         col.names =  c("ID", "Phenotype", "EntrezID", "Gene",
                                                        "Additional", "Source", "LinkID")) 
  #### Check that celltype is available ####
  if(!any(cell %in% unique(results$CellType))){
    cell_orig <- cell
    cell <- unique(results$CellType)[1]
    message("ERROR!: cell '" ,cell_orig,"' not found in results.\n ",
            "Defaulting to first CellType available: '",cell,"'")
  }
  signif_cell_data <- results[(CellType==cell) & (q<=q_threshold) & (fold_change>=fold_threshold),]
  #### Check that the table isn't empty after filtering ####
  if(nrow(signif_cell_data)==0){
    message("ERROR!: phenos table is empty.")
  }
  signif_cell_data = add_hpo_termid_col(cells = signif_cell_data, 
                                        phenotype_to_genes = phenotype_to_genes,
                                        hpo = hpo)
  return(signif_cell_data)
}


#' Get HPO Id from phenotype name.
#'
#' I have done this more efficiently elsewhere using the hpo data object.
#' May be worth replacing, or just add the HPO Id to all datapoints in the results permanently.
#' Alternative method: \code{hpo$id[match(term_name, hpo$name)]}
#' This function is called by the add_hpo_termid_col function, which is called by the get_cell_ontology
#' function when selecting a subset of the data and then adding a HPO id column.
#' @param phenotype Phenotype name from the HPO <string>
#' @param phenotype_to_genes The hpo terms with gene list annotations data frame from hpo website
#'
#' @returns The HPO Id <string>
#'
#' @export
get_hpo_termID = function(phenotype, 
                          phenotype_to_genes){
  # message("get_hpo_termID")
  return(phenotype_to_genes$ID[phenotype_to_genes$Phenotype == phenotype][1])
}



#' Add HPO term Id column to dataframe.
#'
#' This adds the HPO term id column to the subest of ewce results data to be plotted
#' in the cell select app. It also checks if it is a valid HPO term id to pevent error and adds
#' a boolean column where TRUE if term is valid. If the HPO Id is not correct, it caused
#' an error in the ontologyPlot package
#' @param cells The dataframe of subset of RD EWCE results to be plotted in the cell select app.
#' @param phenotype_to_genes The hpo terms with gene list annotations data frame from hpo website
#' @param hpo The HPO ontology data object
#' @returns The subset of ewce result data frame with a HPO Id column added.
#' @export
add_hpo_termid_col = function(cells, 
                              phenotype_to_genes, 
                              hpo) {
  
  # message("add_hpo_termid_col")
  HPOtermID = c()
  ValidTerm = c()
  for (p in cells$list){
    # print(p)
    termid = get_hpo_termID(phenotype = p, 
                            phenotype_to_genes = phenotype_to_genes)
    ValidTerm = append(ValidTerm,(termid %in% hpo$id))
    HPOtermID = append(HPOtermID, termid)
  }
  cells$HPO_term_Id = HPOtermID
  cells$HPO_term_valid = ValidTerm
  return(cells)
}





#' Plot graph of phenotypes in the RD EWCE Results subsetted by Cell type
#'
#' This subsets the results, using other functions from this script, by cell type,
#' q value, and fold change. It then plots a graph/ network of the phenotypes and
#' colors the nodes by their fold change or q value (see the \code{heatmapped_value} param).
#' The ontologyPlot package did not have prebuilt options to create the heatmap, so the
#' colours are assigned manually to each phenotype in this function. There must be a more
#' efficent way to do this. Atleas it may be good to replace the for loop with one of the
#' apply functions.
#' @param results The RD EWCE results dataframe
#' @param cell The cell type of interest <string>
#' @heatmapped_value "q", "fold change" or "p" <string>
#' @param q_threshold The q value threshold of significance
#' @param fold_threshold The fold change threshold
#' @param phenotype_to_genes The HPO Ids with associated gene lists downloaded from HPO website
#' @param hpo The HPO Ontology data object
#' @returns A ontologyPlot plot of the network of phenotypes in a subset of RD EWCE Results
#' @export
one_cell_ontology_plot_heatmap = function(results, 
                                          cell = "Bladder cells", 
                                          heatmapped_value = "q",
                                          q_threshold, 
                                          fold_threshold, 
                                          phenotype_to_genes, 
                                          hpo){
  #' heatmapped_value = "q", "fold_change", or "p". In other words, any continuous variable from the all_cell_ontology to be mapped on to the heatmap colors
  #' reverse_heatmap - reverse recommended for q or p values, so the lowest "most significant" value is red
  message("one_cell_ontology_plot_heatmap")
  cells = get_cell_ontology(cell = cell, 
                            results = results, 
                            q_threshold = q_threshold, 
                            fold_threshold = fold_threshold,
                            phenotype_to_genes = phenotype_to_genes,
                            hpo = hpo)
  cells = cells[cells$HPO_term_valid,]

  if (heatmapped_value == "q"){
    values = cells$q
  } else if (heatmapped_value == "p"){
    values = cells$p
  } else if (heatmapped_value == "fold change"){
    values = cells$fold_change
  } else {
    print("invalid heatmapped_value, enter 'p', 'q', or 'fold change'"); return(0)
    }
  names(values) = cells$HPO_term_Id
  values = sort(values)

  # creating the list of colors for the heatmap
  heatpallette = heat.colors(length(values))
  heat = c()
  prev = 0
  index = 1
  next_index = 1
  # this was necessary so equal values have the same color mapped to them
  for (v in values){
    if (v == prev) {
      heat = append(heat, heatpallette[index])
      next_index = next_index + 1
    } else if (v > prev){
      index = index + next_index
      next_index = 1
      prev = v
      heat = append(heat, heatpallette[index])
    }
  }
  if (heatmapped_value == "fold change" ) {
    heat = rev(heat)}
  
  # Trying to make legend
  # library(ggplot2)
  # vdf = data.frame(values)
  # vdf$colors = heat.colors(n=length(values), rev=TRUE)
  # vdf$fv = factor(round(values,2))
  # plt <- ggplot(vdf[c(1, nrow(vdf)),], aes(x = values, y=values, color = fv )) +
  #   geom_point() +
  #   scale_color_manual(values=heat.colors(n=2, rev=TRUE), name= "Fold change")
  # ledge = cowplot::get_legend(plt)
  
  return (ontologyPlot::onto_plot(hpo,terms=names(values), fillcolor = heat, shape = "rect"))
}


# Testing ######################################################################


# q_threshold = 0.05
# fold_threshold = 1
# results=all_results_merged
# ## Significant celltype test
# cell = subset(results, q<=q_threshold & fold_change>=fold_threshold)$CellType[1]
# ## Non-significant celltype test
# ## cell = subset(results, q>=q_threshold)$CellType[1]
# 
# one_cell_ontology_plot_heatmap(results = results, 
#                                cell = cell, 
#                                heatmapped_value = "fold change",
#                                q_threshold = q_threshold, 
#                                fold_threshold = fold_threshold, 
#                                phenotype_to_genes = phenotype_to_genes, 
#                                hpo = hpo)
# 
