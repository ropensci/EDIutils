context("Create journal citation")

testthat::test_that("create_journal_citation() works", {
  skip_if_logged_out()
  journalCitationId <- create_journal_citation(
    packageId = get_test_package(), 
    articleDoi = "10.1890/11-1026.1",
    articleUrl = "https://doi.org/10.1890/11-1026.1",
    articleTitle = "Corridors promote fire via connectivity and edge effects",
    journalTitle = "Ecological Applications",
    relationType = "IsCitedBy",
    env = "staging")
  expect_type(journalCitationId, "double")
  res <- delete_journal_citation(journalCitationId, env = "staging")
  expect_true(res)
})
