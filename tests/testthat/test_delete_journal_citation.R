context("Delete journal citation")

testthat::test_that("delete_journal_citation() works", {
  # Also tested in test_create_journal_citation.R
  vcr::skip_if_vcr_off()
  journalCitationId <- 183
  vcr::use_cassette("delete_journal_citation", {
    res <- delete_journal_citation(journalCitationId, env = "staging")
  })
  expect_true(res)
})
