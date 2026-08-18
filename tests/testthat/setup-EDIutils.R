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
# Configure sensitive data filtering for vcr recording
sensitive_list <- list("<<github_api_token>>" = Sys.getenv('GITHUB_TOKEN'))
if (nzchar(Sys.getenv("EDI_API_KEY"))) {
  sensitive_list[["<<edi_api_key>>"]] <- Sys.getenv("EDI_API_KEY")
}

invisible(vcr::vcr_configure(
  dir = vcr::vcr_test_path("fixtures"),
  filter_sensitive_data = sensitive_list,
  filter_request_headers = list(`auth-token` = "<<<not-my-bearer-token>>>"),
  filter_response_headers = list(`auth-token` = "<<<not-my-bearer-token>>>")
))

# Throttle real HTTP requests to avoid PASTA rate limits (e.g. HTTP 429)
# Note: httr's response callback is only invoked on actual network requests,
# ensuring vcr cassette replays remain instantaneous.
throttle_delay <- as.numeric(Sys.getenv("EDI_TEST_THROTTLE_DELAY", "1"))
if (is.finite(throttle_delay) && throttle_delay > 0) {
  httr::set_callback("response", function(req, res) {
    Sys.sleep(throttle_delay)
    return(NULL)
  })
}

