#' Did a set of tables change between versions?
#' 
#' @description If table attributes changed, then downstream processes relying on an expected structure may fail. This checks for common structural changes leading to such issues.
#'
#' @param newest (list) Tables from the newest version of a data package, where inputs are returned from \code{read_tables()}.
#' @param previous (list) Tables from the previous version of a data package, where inputs are returned from \code{read_tables()}.
#'
#' @return (list) A list of differences.
#' @export
#'
#' @examples
compare_tables <- function(newest, 
                           previous) {
  
  # For each table of "newest", perform checks on matching "previous"
  
  # Compare data frames
  # Column names in "previous" exist in "newest"
  # Number of columns in "previous" are the same as "newest"
  # Number of rows in "previous" < "newest"
  
  # Compare dataTable metadata
  # Object name of "previous" == "newest"
  # Checksum of "previous" != "newest"
  # Column names in "previous" exist in "newest"
  # Number of columns in "previous" are the same as "newest"
  # Number of rows in "previous" < "newest"
  # Column classes of "previous" == "newest"
  # Field delimiter of "previous" == "newest"
  # Number of header lines of "previous" == "newest"
  # datetime format string of "previous" == "newest"
  
  return(differences)
  
}