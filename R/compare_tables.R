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
  
  return(differences)
  
}