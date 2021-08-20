#' Get field delimiters of input files
#'
#' @description  
#'     Detect and return field delimiters of input files (tables).
#'
#' @usage 
#' detect_delimeter(
#'   path, 
#'   data.files, 
#'   os
#' )
#' 
#' @param path 
#'     (character) Path to files.
#' @param data.files
#'     (character) File names.
#' @param os
#'     (character) Operating system. Valid options are returned from  
#'     \code{EDIutils::detect_os}.
#' 
#' @return 
#'     (character) Field delimiters of input files.
#'     \item{"\\t"}{tab}
#'     \item{","}{comma}
#'     \item{";"}{semi-colon}
#'     \item{"|"}{pipe}
#'
#' @export
#'

detect_delimeter <- function(path, data.files, os){
  
  # Validate arguments --------------------------------------------------------
  
  # Validate arguments
  
  validate_arguments(x = as.list(environment()))
  
  # Validate data tables
  
  data_files <- validate_file_names(path, data.files)
  
  # Detect field delimiters ---------------------------------------------------
  # Loop through each table using reader::get.delim() to return the field
  # delimiter. Note: reader::get.delim() performance seems to be operating 
  # system specific.
  
  delim_guess <- c()
  data_path <- c()
  
  for (i in seq_along(data_files)){
    
    # Initialize output vector
    
    data_path[i] <- paste0(path, '/', data_files[i])
    
    if (os == "mac"){
      
      # Detect delimiter for table in Mac OS
      
      delim_guess[i] <- suppressWarnings(
        try(
          reader::get.delim(
            data_path[i],
            n = 1,
            delims = c('\t', ',', ';', '|')
          ), 
          silent = T
        )
      )
      
    } else if (os == "win"){
      
      # Detect delimiter for table in Windows OS
      
      delim_guess[i] <- suppressWarnings(
        try(
          reader::get.delim(
            data_path[i],
            n = 1,
            delims = c('\t', ',', ';', '|')
          ), 
          silent = T
        )
      )

    } else if (os == 'lin'){
      
      # Detect delimiter for table in Linux OS
      
      delim_guess[i] <- suppressWarnings(
        try(
          reader::get.delim(
            data_path[i],
            n = 1,
            delims = c('\t', ',', ';', '|')
          ), 
          silent = T
        )
      )
      
    }
    
    # Infer field delimiter (if necessary) ------------------------------------
    
    # If the field delimiter can't be determined, then infer it from the file 
    # name.
    
    if (is.na(delim_guess[i])){
      delim_guess[i] <- delimiter_infer(data_path[i])
    }
    
    # Check delimiters and provide manual override ----------------------------
    
    delim_guess[i] <- detect_delimeter_2(
      data.file = data_files[i],
      delim.guess = delim_guess[i]
    )
    
  }
  
  # Return --------------------------------------------------------------------
  
  delim_guess
  
}






#' Infer field delimiter from file name
#' 
#' @param x
#'   (character) File name including path
#'
#' @return
#'   (character) Delimiter
#' 
delimiter_infer <- function(x){
  
  # FIXME: The following method needs improvement. 

  if (stringr::str_detect(x, '.csv$')){
    output <- ','
  } else if (stringr::str_detect(x, '.txt$')){
    output <- '\t'
  }
  
  warning(
    paste0(
      'Cannot detect field delimiter for ',
      x,
      ', assigning a value of "',
      output,
      '".'
    )
  )
  
  # Return
  
  output

}






#' Detect field delimiter 2
#' 
#' @description
#'     Secondary check on delimeter detection with manual override
#' 
#' @usage detect_delimeter_2(data.file, delim.guess)
#' 
#' @param data.file
#'     (character) Data file name.
#' @param delim.guess
#'     (character) Delimiter guessed from `detect_delimeter`.
#' 
#' @return
#'     If ambiguity exists, a manual overide option is presented.
#'     

detect_delimeter_2 <- function(data.file, delim.guess){
  
  # Get file extension
  
  file_ext <- substr(
    data.file,
    nchar(data.file)-3,
    nchar(data.file)
  )
  
  # Apply logic
  
  if (is.null(delim.guess) |
      ((delim.guess == ",") & (file_ext == ".txt")) |
      ((delim.guess == "\t") & (file_ext == ".csv")) |
      ((delim.guess == "|") & (file_ext == ".csv"))){
    
    # Send option for manual override
    
    message(
      paste0(
        "I'm having trouble identifying the field delimeter of ",
        data.file, 
        ". Enter the field delimeter of this file.",
        ' Valid options are:  ,  \\t  ;  |'
      )
    )
    
    answer <- readline('ENTER here: ')
    
    # Process user input (add escape characters)
    
    if (answer == "\\t"){
      answer <- "\t"
    }
    
  } else {
    
    answer <- delim.guess
    
  }
  
  answer
  
}