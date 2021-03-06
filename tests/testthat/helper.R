if (!requireNamespace("RBackend", quietly = TRUE)) {
  stop("RBackend is needed to run the tests. Please install it.", call. = FALSE)
}

if (!requireNamespace("rjson", quietly = TRUE)) {
  stop("rjson is needed to run the tests. Please install it.", call. = FALSE)
}

test_it <- function(lst) {
  if (is.null(lst$DC_TYPE)) lst$DC_TYPE <- "NormalExercise"
  if (is.null(lst$DC_PEC)) lst$DC_PEC <- ""
  if (is.null(lst$DC_SOLUTION)) lst$DC_SOLUTION <- ""
  if (is.null(lst$DC_SCT)) lst$DC_SCT <- ""
  lst$DC_COMMAND <- "init"
  output <- rjson::fromJSON(RBackend::execute(rjson::toJSON(lst)))
  if (any(sapply(output, `[[`, "type") == "error")) {
    print(output)
    stop("init failed")
  }
  lst$DC_COMMAND <- "submit"
  rjson::fromJSON(RBackend::execute(rjson::toJSON(lst)))
}

get_sct_payload <- function(output) {
  if (any(sapply(output, `[[`, "type") == "error")) {
    print(output)
    stop("an error occured")
  }
  output[sapply(output, `[[`, "type") == "sct"][[1]]$payload
}

get_error_payload <- function(output) {
  if (any(sapply(output, `[[`, "type") == "sct")) {
    print(output)
    stop("no error occured")
  }
  output[sapply(output, `[[`, "type") == "error"][[1]]$payload
}

passes <- function(output, mess_patt = NULL) {
  sct_payload <- get_sct_payload(output)
  expect_true(sct_payload$correct)
  if (!is.null(mess_patt)) {
    expect_true(grepl(mess_patt, sct_payload$message))
  }
}

fails <- function(output, mess_patt = NULL) {
  sct_payload <- get_sct_payload(output)
  expect_false(sct_payload$correct)
  if (!is.null(mess_patt)) {
    expect_true(grepl(mess_patt, sct_payload$message))
  }
}

fb_contains <- function(output, mess_patt, fixed = TRUE) {
  sct_payload <- get_sct_payload(output)
  expect_true(grepl(mess_patt, sct_payload$message, fixed = fixed))
}

fb_excludes <- function(output, mess_patt, fixed = TRUE) {
  sct_payload <- get_sct_payload(output)
  expect_false(grepl(mess_patt, sct_payload$message, fixed = fixed))
}

error <- function(output, mess_patt = NULL) {
  error_payload <- get_error_payload(output)
  expect_false(is.null(error_payload))
  if (!is.null(mess_patt)) {
    expect_true(grepl(mess_patt, error_payload))
  }
}

line_info <- function(output, line_start, line_end, column_start, column_end) {
  sct_payload <- get_sct_payload(output)
  expect_equal(sct_payload$line_start, line_start)
  expect_equal(sct_payload$line_end, line_end)
  if(!missing(column_start)) expect_equal(sct_payload$column_start, column_start)
  if(!missing(column_end)) expect_equal(sct_payload$column_end, column_end)
}

print_fb <- function(output) {
  sct_payload <- get_sct_payload(output)
  cat("\n", "FBM: \"", testwhat:::trim(sct_payload$message), "\"\n", sep = "")
}