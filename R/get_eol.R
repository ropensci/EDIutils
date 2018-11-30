#' Get end of line (EOL) character
#'
#' @description
#'     Get EOL character of input file(s).
#'
#' @usage get_eol(path, file.name, os)
#'
#' @param path
#'     (character) A path to the target file directory.
#' @param file.name
#'     (character) The target file name.
#' @param os
#'     (character) The operating system in which this function is called
#'     called. Valid options are generated from \code{detect_os}.
#'
#' @return
#'     A character string representation of the EOL character.
#'
#' @export
#'


get_eol <- function(path, file.name, os){

  # Check arguments -----------------------------------------------------

  validate_arguments(x = as.list(environment()))

  # Validate file.name

  file_name <- validate_file_names(path, file.name)

  # Detect end of line character ----------------------------------------------

  if (os == 'mac'){ # Macintosh OS

    command <- paste0(
      'od -c ',
      path,
      '/',
      file.name
    )

    output <- system(
      command,
      intern = T
    )

    use_i <- stringr::str_detect(
      output,
      '\\\\r  \\\\n'
    )

    if (sum(use_i) > 0){
      eol <- '\\r\\n'
    } else {
      use_i <- stringr::str_detect(
        output,
        '\\\\n'
      )
      if (sum(use_i) > 0){
        eol <- '\\n'
      } else {
        eol <- '\\r'
      }
    }

  } else if ((os == 'win') | (os == 'lin')){ # Windows & Linux OS

    output <- readChar(
      paste0(
        path,
        '/',
        file.name
      ),
      nchars = 10000
    )

    eol <- parse_delim(output)

  }

  eol

}


# Parse delimiter from string -------------------------------------------------

parse_delim <- function(x){

  use_i <- stringr::str_detect(
    x,
    '\\r\\n'
  )

  if (sum(use_i) > 0){
    eol <- '\\r\\n'
  } else {
    use_i <- stringr::str_detect(
      x,
      '\\n'
    )
    if (sum(use_i) > 0){
      eol <- '\\n'
    } else {
      eol <- '\\r'
    }
  }

  eol

}


