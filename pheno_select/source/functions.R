#' Create Phenotype keyword search pattern 
#' 
#' This creates a regex search pattern to find all phenotypes containing the  
#' keywords entered by the user. The search expression is not case sensitive and 
#' uses an "or" operator, so the phenotype only needs to contain one of the 
#' keywords. The function also removes any spaces. 
#' 
#' @param keywords phenotype related keywords separated by ",".
#' @returns A regex pattern used to search for keywords.
#' @export
#' @examples
#' keywords <- "muscle, fatigue, heart"
#' Terms <- process_search_terms(keywords = keywords) 
 process_search_terms <- function(keywords) {
  keywords <- strsplit(keywords, ",")[[1]]
  output = c()
  for (i in seq(1, length(keywords))){
    cur = keywords[i]
    while (substr(cur, 1,1) == " ") {
      cur = substr(cur, 2, nchar(cur))
    }
    while (substr(cur, nchar(cur), nchar(cur)) == " ") {
      cur = substr(cur, 1, nchar(cur)-1)
    }
    output = append(output, paste0("(?i)", cur))
  }
  output <- paste(output, collapse = "|")
  return(output)
}


#' Subset the RD EWCE results using phenotype keywords 
#' 
#' This finds all results related to phenotypes that contain the kewords entered 
#' into the \code{process_search_terms} function. It further subests by
#' fold change and q value thresholds. 
#' 
#' @param Terms the regex search pattern generated by 
#' \code{process_search_terms}.
#' @param q_threshod q value maximum threshold.
#' @param fold_threhold fold change minimum threshold.
#' @param min_sd_from_mean Z score threshold.
#' 
#' @returns A data frame of subset of RD EWCE results.
#' @export 
#' @examples 
#' results <- readRDS(file.path("data","Descartes_All_Results.rds"))
#' keywords <- "muscle, fatigue, heart"
#' Terms <- process_search_terms(keywords = keywords)
#' DF <- keyword_search_df(Terms = Terms) 
keyword_search_df <- function(Terms, 
                              q_threshold = 0.05,
                              fold_threshold = 1,
                              min_sd_from_mean = 0) {

  # remove as charcater below ?
  Phenos <- as.character(unique(phenotype_to_genes$Phenotype[
    stringr::str_detect(phenotype_to_genes$Phenotype, 
                        pattern = Terms)
    ]))
  DF <- results[results$Phenotype %in% Phenos &
                results$q <= q_threshold & 
                results$fold_change >= fold_threshold &
                results$sd_from_mean >= min_sd_from_mean, ]
  return(DF)
}


#' Plot bar chart of RD EWCE subset 
#' 
#' Should redo this figure. Possibly reuse a better one from the report
#' 
#' @param DF The RD EWCE results subset to be visualised.
#' @param keywords the keyword string (used to create title).
#' 
#' @returns a bar chart <ggplot>
#' @export
#' @examples 
#' results <- readRDS(file.path("data","Descartes_All_Results.rds"))
#' keywords <- "muscle, fatigue, heart"
#' Terms <- process_search_terms(keywords = keywords)
#' DF <- keyword_search_df(Terms = Terms)
#' plot_phenotype_counts(DF = DF, keywords = keywords)
plot_phenotype_counts <- function(DF, 
                                  keywords,
                                  interactive=TRUE) { 
  #### Aggregate counts ####
  counts_df <- unique(DF[,.(count=data.table::uniqueN(Phenotype),
                            mean_fold_change=round(mean(fold_change),3),
                            mean_q=round(mean(q),3),
                            mean_sd_from_mean=round(mean(sd_from_mean),3),
                            phenotypes=paste(
                              stringr::str_wrap(paste(unique(Phenotype),
                                                      collapse = ", ")),
                              sep = "<br>"
                            )
                            ), 
                         by="CellType"][,c("CellType","count",
                                           "mean_fold_change",
                                           "mean_q",
                                           "mean_sd_from_mean",
                                           "phenotypes")])
  #### Make subtitle ####
  ## plotly doesn't inherit subtitle arg from ggplot,
  ## so need to append it to the title.
  subtitle <-  paste0(shQuote(paste(keywords,collapse = ", ")),
                      " (",formatC(length(unique(DF$Phenotype)),
                                   big.mark = ",")," phenotypes)")
  #### Make plot ####
  plt <- ggplot(counts_df, aes(x = CellType,
                        y = count,
                        fill = mean_fold_change,
                        mean_q = mean_q,
                        mean_sd_from_mean = mean_sd_from_mean,
                        phenotype = phenotypes)) + 
    geom_col() +   
    labs(title = paste0("Enrichment counts associated with:\n",
                        subtitle
                        ),  
         x = "Cell type", 
         y = "Phenotype count",
         fill = "Mean fold change") +
    scale_y_continuous(breaks = scales::pretty_breaks(),
                       expand = expansion(mult = c(0, .1))) +
    scale_fill_viridis_c(option = "magma") +
    theme_bw() + 
    theme(axis.text.x = element_text(angle = 45, 
                                     vjust = 0.5, hjust = 1, 
                                     size = 10)) 
  if(isTRUE(interactive)){
    plotly::ggplotly(plt) |> 
      plotly::layout(hoverlabel = list(align = "left"),
                     margin = list(l = 0, r = 0,
                                   b = 0, t = 70,
                                   pad = 0) )
  } else {
    return(plt)
  }
}


#' Interactive DT
#'
#' Generate an interactive data table with download buttons.
#' @param dat Data to show.
#' @param caption Table caption.
#' @param scrollY Maximum height (in pixels) before defaulting to scrolling.
#' @param buttons Download button types to include in table.
#'
#' @family general
#' @export
#' @examples
#' create_dt(dat = mtcars)
create_dt <- function(dat,
                      caption = "",
                      buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                      scrollY = 400){
  requireNamespace("DT")
  DT::datatable(
    data = dat,
    caption = caption,
    extensions = 'Buttons',
    options = list( dom = 'Bfrtip',
                    buttons = buttons,
                    scrollY = scrollY,
                    scrollX=TRUE,
                    scrollCollapse = TRUE,
                    paging = FALSE,
                    columnDefs = list(list(className = 'dt-center',
                                           targets = "_all"))
    )
  )
}
