#' Did a set of tables change between versions?
#' 
#' @description If table attributes changed, then downstream processes relying on an expected structure may fail. This checks for common structural changes in the tables (not EML, see \code{compare_eml()}).
#'
#' @param newest (list) Tables from the newest version of a data package, where inputs are returned from \code{read_tables()}.
#' @param previous (list) Tables from the previous version of a data package, where inputs are returned from \code{read_tables()}.
#'
#' @return (character) A vector of check results
#' 
#' @export
#'
#' @examples
#' 
#' compare_tables(
#'   newest = read_tables(api_read_metadata("knb-lter-hfr.118.32")),
#'   previous = read_tables(api_read_metadata("knb-lter-hfr.118.31")))
#' 
compare_tables <- function(newest, 
                           previous) {
  
  results <- list()
  
  # File names
  
  if (all(names(newest) %in% names(previous)) &
      all(names(previous) %in% names(newest))) {
    results <- c(results, "Table names are the same")
  } else {
    results <- c(results, "Table names are different")
  }
  
  # Within table checks
  
  for (i in names(newest)) {
    if (i %in% names(previous)) {
      
      # Column names
      
      colnames_newest <- colnames(newest[[i]])
      colnames_previous <- colnames(previous[[which(names(previous) %in% i)]])
      if (all(colnames_newest %in% colnames_previous) & 
          all(colnames_previous %in% colnames_newest)) {
        results <- c(results, paste0("Column names of ", i, " are the same"))
      } else {
        results <- c(results, paste0("Column names of ", i, " are different"))
      }
      
      # Number of columns
      
      ncol_newest <- ncol(newest[[i]])
      ncol_previous <- ncol(previous[[which(names(previous) %in% i)]])
      if (ncol_newest == ncol_previous) {
        results <- c(results, paste0("Number of columns in ", i, " are the same"))
      } else {
        results <- c(results, paste0("Number of columns in ", i, " are different"))
      }
      
      # Number of rows
      
      nrow_newest <- nrow(newest[[i]])
      nrow_previous <- nrow(previous[[which(names(previous) %in% i)]])
      if (nrow_newest == nrow_previous) {
        results <- c(results, paste0("Number of rows in ", i, " are the same"))
      } else {
        results <- c(results, paste0("Number of rows in ", i, " are different"))
      }
      
    }
    
  }
  
  return(unlist(results))
  
}







