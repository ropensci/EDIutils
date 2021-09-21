context("Delete journal citation")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  journalCitationId <- create_journal_citation(
    packageId = get_test_package(), 
    articleDoi = "https://doi.org/10.1890/11-1026.1",
    articleTitle = "Corridors promote fire via connectivity and edge effects",
    journalTitle = "Ecological Applications",
    tier = "staging")
  res <- delete_journal_citation(journalCitationId, "staging")
  expect_true(res)
})