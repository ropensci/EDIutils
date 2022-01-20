# Occasionally we want to test with real HTTP calls to the API
if (Sys.getenv("EDI_USER") != "" & Sys.getenv("EDI_PASS") != "") {
  login(userId = Sys.getenv("EDI_USER"), userPass = Sys.getenv("EDI_PASS"))
}

# Most of the time we run mock tests
library("vcr")
vcr_dir <- vcr::vcr_test_path("fixtures")
if (!nzchar(Sys.getenv("EDI_TOKEN"))) {
  if (dir.exists(vcr_dir)) {
    # Fake API token to fool our package
    Sys.setenv("EDI_TOKEN" = "foobar")
  } else {
    # If there's no mock files nor API token, impossible to run tests
    stop("No API key nor cassettes, tests cannot be run.",
         call. = FALSE
    )
  }
}
invisible(vcr::vcr_configure(
  dir = vcr::vcr_test_path("fixtures"),
  filter_sensitive_data = list("<<github_api_token>>" = Sys.getenv('GITHUB_TOKEN')),
  filter_request_headers = list(`auth-token` = "<<<not-my-bearer-token>>>"),
  filter_response_headers = list(`auth-token` = "<<<not-my-bearer-token>>>")
))
vcr::check_cassette_names()
