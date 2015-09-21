#' Create a test.
#'
#' A test encapsulates a series of expectations about small, self-contained
#' set of functionality.  Each test is contained in a \link{context} and
#' contains multiple expectation generated by \code{\link{expect_that}}.
#'
#' Tests are evaluated in their own environments, and should not affect
#' global state.
#'
#' When run from the command line, tests return \code{NULL} if all
#' expectations are met, otherwise it raises an error.
#'
#' @param desc test name.  Names should be kept as brief as possible, as they
#'   are often used as line prefixes.
#' @param code test code containing expectations
#' @export
#' @examples
#' test_that("trigonometric functions match identities", {
#'   expect_that(sin(pi / 4), equals(1 / sqrt(2)))
#'   expect_that(cos(pi / 4), equals(1 / sqrt(2)))
#'   expect_that(tan(pi / 4), equals(1))
#' })
#' # Failing test:
#' \dontrun{
#' test_that("trigonometric functions match identities", {
#'   expect_that(sin(pi / 4), equals(1))
#' })
#' }
#test_that <- function(desc, code) {
#   if (require(testthat)) {
#     testthat::test_that(desc, code)
#   } else {
#     stop("You require the testthat package in order to run the testwhat package.")
#   }
# }


test_that <- function(desc, code) {
 test_code(desc, substitute(code), env = parent.frame())
 invisible()
}

# Generate error report from traceback.
#
# @keywords internal
# @param error error message
# @param traceback traceback generated by \code{\link{create_traceback}}
error_report <- function(error, traceback) {
  msg <- gsub("Error.*?: ", "", as.character(error))

  if (length(traceback) > 0) {
    user_calls <- paste0(traceback, collapse = "\n")
    msg <- paste0(msg, user_calls)
  } else {
    # Need to remove trailing newline from error message to be consistent
    # with other messages
    msg <- gsub("\n$", "", msg)
  }

  expectation(NA, msg, "no error occured")
}

# Executes a test.
#
# @keywords internal
# @param description the test name
# @param code the code to be tested, needs to be an unevaluated expression
#   i.e. wrap it in substitute()
# @param env the parent environment of the environment the test code runs in
test_code <- function(description, code, env) {
  rep <- get_reporter()
  if (!rep$continue) return()  # test not necessary (e.g., previous failure)

  new_test_environment <- new.env(parent = env)
  rep$start_test(description)
  on.exit(rep$end_test())
  res <- suppressMessages(try_capture_stack(
    code, new_test_environment))

  if (is.error(res) && res$message != get_stop_msg()) {
    traceback <- create_traceback(res$calls)
    report <- error_report(res, traceback)
    rep$add_result(report)
  }
}
