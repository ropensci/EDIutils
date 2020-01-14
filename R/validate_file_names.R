#' Validate file names
#'
#' @description  
#'     Identify whether input data file names exist in the specified directory.
#'
#' @usage validate_file_names(path, data.files)
#' 
#' @param path 
#'     (character) A character string specifying a path to the dataset working 
#'     directory.
#' @param data.files
#'     A list of character strings specifying the names of the data files of 
#'     your dataset.
#' 
#' @return 
#'     A warning message if the data files don't exist at path, and which of
#'     the input data files are missing.
#'     
#'     The full names of files listed in the data.files argument.
#'
#' @export
#'

validate_file_names <- function(path, data.files){
  
  # Validate file presence ----------------------------------------------------
  
  # Index data.files in path
  files <- list.files(path)
  use_i <- data.files %in% files
  
  # Throw an error if any data.files are missing
  if (sum(use_i) != length(data.files)){
    stop(
      paste0(
        "\nThese files don't exist in the specified directory:\n", 
        paste(data.files[!use_i], collapse = "\n")
      ),
      call. = FALSE
    )
  }
  
  # Check file naming convention ----------------------------------------------
  
  # Index file names that are not composed of alphanumerics and underscores
  use_i <- stringr::str_detect(
    string = tools::file_path_sans_ext(data.files), 
    pattern = "([:blank:]|([:punct:]^_))"
  )
  
  # Issue warning if this best practice is not followed
  if (any(isTRUE(use_i))) {
    warning(
      paste0(
        "Composing file names from only alphanumerics and underscores is a ",
        "best practice. These files don't follow this recommendation:\n",
        paste(data.files[use_i], collapse = "\n"),
        "\nPlease consider renaming these files."
      ),
      call. = FALSE
    )
  }

  # Get file names ------------------------------------------------------------

  files <- list.files(path)
  use_i <- stringr::str_detect(string = files,
                      pattern = stringr::str_c("^", data.files, collapse = "|"))
  data_files <- files[use_i]
  
  # Reorder file names to match input ordering --------------------------------
  
  data_files_out <- c()
  for (i in 1:length(data.files)){
    use_i <- stringr::str_detect(string = data_files,
                        pattern = stringr::str_c("^", data.files[i], collapse = "|"))
    data_files_out[i] <- data_files[use_i]
  }
  
  data_files_out

}
