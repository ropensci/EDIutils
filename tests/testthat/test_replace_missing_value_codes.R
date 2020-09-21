context("Replace missing value codes")

library(EDIutils)

testthat::test_that("replace_missing_value_codes()", {
  
  # Parameterize --------------------------------------------------------------
  
  eml <- EDIutils::api_read_metadata("knb-lter-hfr.118.31")
  data_names <- EDIutils::api_read_data_entity_names("knb-lter-hfr.118.31")
  data_urls <- xml2::xml_text(
    xml2::xml_find_all(eml, ".//physical/distribution/online/url"))
  attributes <- xml2::xml_find_all(eml, ".//attributeList/attribute")
  attributeNames <- xml2::xml_text(
    xml2::xml_find_all(eml, ".//attributeList/attribute/attributeName"))
  ants <- data.table::fread(
    data_urls[data_names %in% "hf118-01-ants.csv"], 
    strip.white = TRUE)
  
  # Test inputs ---------------------------------------------------------------
  
  # Both x and eml are required
  expect_error(
    replace_missing_value_codes(
      eml = "not_an_xml_object"),
    regexp = "Both arguments 'x' and 'eml' are required.")
  expect_error(
    replace_missing_value_codes(
      x = data.frame(a = c(1,2,3))),
    regexp = "Both arguments 'x' and 'eml' are required.")
  
  # x is a data frame
  expect_error(
    replace_missing_value_codes(
      x = c(1,2,3),
      eml = "not_an_xml_object"),
    regexp = "'x' should be a data.frame")
  
  # eml is an xml_document xml_node
  expect_error(
    replace_missing_value_codes(
      x = data.frame(a = c(1,2,3)),
      eml = "not_an_xml_object"),
    regexp = "'eml' should be an 'xml_document' 'xml_node'")
  
  # with is a character
  expect_error(
    replace_missing_value_codes(
      x = ants,
      eml = eml,
      with = 42),
    regexp = "'with' should be a character.")
  
  # file cannot be found in the eml
  expect_error(
    replace_missing_value_codes(
      x = ants,
      eml = eml,
      with = 42),
    regexp = "'with' should be a character.")

  # Test function -------------------------------------------------------------
  
  # Create test data. Add "NaN" missing value codes to data and metadata.
  ants$abundance[1:2] <- "NaN"
  node <- xml2::xml_find_all(
    attributes[attributeNames == "abundance"], ".//missingValueCode/code")
  xml2::xml_text(node) <- "NaN"
  
  r <- replace_missing_value_codes(ants, eml, with = NA)
  expect_true(is.numeric(r$abundance))
  expect_false(any(r$abundance %in% "NaN"))

})
