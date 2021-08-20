context('read_table()')
library(EDIutils)

testthat::test_that('convert.missing.value()', {
  # numeric
  numbers <- c(1, 2, 3, NA, NaN, "-99999")
  codes <- c("NA", "NaN", "-99999")
  res <- convert_missing_value(numbers, codes, type = "numeric")
  expect_equal(class(res), "numeric")
  expect_equal(sum(is.na(res)), 3)
  # character
  characters <- c(" one ", " two", "three ", NA, "-99999")
  codes <- c("NA", "-99999")
  res <- convert_missing_value(characters, codes, type = "character")
  expect_equal(class(res), "character")
  expect_equal(sum(is.na(res)), 2)
})




testthat::test_that("strip.white, na.strings, add.units", {
  eml <- EDIutils::read_metadata("knb-lter-hfr.118.32")
  d <- EDIutils::read_tables(eml, strip.white = TRUE, na.strings = "", add.units = TRUE)
  expect_true(!any(na.omit(d$`hf118-01-ants.csv`$trap.num == ""))) # all "" are converted to NA
  expect_true(all(c("unit_hl", "unit_rel", "unit_rll") %in% colnames(d$`hf118-02-functional-traits.csv`))) # unit columns created for each numeric variable
  expect_equal(unique(d$`hf118-01-ants.csv`$unit_abundance), "number") # column contains variable's unit
  expect_equal(unique(d$`hf118-02-functional-traits.csv`$unit_hl), "millimeter")
})
