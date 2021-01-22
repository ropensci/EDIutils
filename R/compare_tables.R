#' Are there meaningful differences between dataset tables?
#' 
#' @description If table attributes changed, then downstream processes relying on an expected structure may fail. This checks for common structural differences between tables, not EML describing the tables. This function augments \code{compare_eml()}, which stops short of checking table attributes.
#'
#' @param newest (list) Tables from the newest version of a data package. Use \code{read_tables()} to create this list.
#' @param previous (list) Tables from the previous version of a data package. Use \code{read_tables()} to create this list.
#'
#' @return (character) Attributes that differ between versions
#' 
#' @details 
#' Checked attributes:
#' \itemize{
#'   \item{File names}
#'   \item{Column names}
#'   \item{Number of columns}
#' }
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
  
  res <- list()
  
  # File names
  if (!all(names(newest) %in% names(previous)) &
      !all(names(previous) %in% names(newest))) {
    res <- c(res, "Table names are different")
  }

  for (i in names(newest)) {
    if (i %in% names(previous)) {
      # Column names
      colnames_newest <- colnames(newest[[i]])
      colnames_previous <- colnames(previous[[which(names(previous) %in% i)]])
      if (!all(colnames_newest %in% colnames_previous) & 
          !all(colnames_previous %in% colnames_newest)) {
        res <- c(res, paste0("Column names of ", i, " are different"))
      }
      # Number of columns
      ncol_newest <- ncol(newest[[i]])
      ncol_previous <- ncol(previous[[which(names(previous) %in% i)]])
      if (ncol_newest != ncol_previous) {
        res <- c(res, paste0("Number of columns in ", i, " are different"))
      }
    }
  }
  
  return(unlist(res))
  
}







