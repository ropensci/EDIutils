#' Get date time format string
#'
#' @description
#'     Get format of ISO 8601 formatted character string.
#'
#' @usage get_datetime_format(x)
#'
#' @param x
#'     (character) A vector of dates and times created with
#'     `EDIutils::datetime_to_iso8601`.
#'
#' @return
#'     (character) A datetime format string if only one is found, otherwise
#'     a vector of datetime format strings are returned.
#'
#' @export
#'

get_datetime_format <- function(x){

  # Check arguments -----------------------------------------------------------

  if (missing(x)){
    stop('Input argument "x" is missing!')
  }
  if (sum(is.na(x)) == length(x)){
    stop('Input argument "x" cannot be entirely NA.')
  }

  # Remove NA -----------------------------------------------------------------

  x <- x[!is.na(x)]

  # Parse datetime strings ----------------------------------------------------

  use_i <- stringr::str_count(x, pattern = ":")
  use_i_t <- stringr::str_count(x, pattern = "T")

  Mode <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
  }

  use_i <- Mode(use_i)
  use_i_t <- Mode(use_i_t)

  if (use_i == 2){
    output <- 'YYYY-MM-DDThh:mm:ss'
  }
  if (use_i == 1){
    output <- 'YYYY-MM-DDThh:mm'
  }
  if ((use_i == 0) & ((use_i_t == 1))){
    output <- 'YYYY-MM-DDThh'
  }
  if ((use_i == 0) & ((use_i_t != 1))){
    output <- 'YYYY-MM-DD'
  }

  # Output --------------------------------------------------------------------

  output

}
