% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check-call.R
\name{test_call}
\alias{test_call}
\alias{test_function}
\alias{test_function_v2}
\alias{check_function}
\alias{check_operator}
\alias{check_arg}
\alias{check_equal.ArgumentState}
\title{Test whether a student correctly called a function/operator}
\usage{
test_function(name, args = NULL, index = 1, eval = TRUE,
  eq_condition = "equivalent", not_called_msg = NULL,
  args_not_specified_msg = NULL, incorrect_msg = NULL)

test_function_v2(name, args = NULL, index = 1, eval = TRUE,
  eq_condition = "equivalent", not_called_msg = NULL,
  args_not_specified_msg = NULL, incorrect_msg = NULL)

check_function(state, name, index = 1, not_called_msg = NULL,
  append = TRUE)

check_operator(state, name, index = 1, append = TRUE,
  not_called_msg = NULL)

check_arg(state, arg, arg_not_specified_msg = NULL, append = TRUE)

\method{check_equal}{ArgumentState}(state, incorrect_msg = NULL,
  eval = TRUE, eq_condition = "equivalent", append = TRUE, ...)
}
\arguments{
\item{name}{name of the function/operator as a string, e.g. \code{"mean"} or
\code{"+"}}

\item{args}{character vector of argument names that the student should have
supplied in the function calls.}

\item{index}{integer that specifies which call of \code{name} in the
solution code will be checked.}

\item{eval}{logical vector indicating whether and how to compare arguments.
If \code{eval} is \code{NA}, student and solution argument are not
compared. If \code{eval} is \code{FALSE}, the string versions of the
arguments are compared. If \code{eval} is \code{TRUE}, the argument in the
student code is evaluated in the student environment and the argument in
the solution code is evaluated in the solution environment, and their
results are compared. Setting this to \code{FALSE} can be useful, e.g., to
test whether the student supplied a large predefined object, or when you're
in a sub-SCT where the environments are not unambiguously available.}

\item{eq_condition}{character vector indicating how to perform the
comparison for each argument. See \code{\link{is_equal}}}

\item{not_called_msg}{custom feedback message in case the student did not
call the function often enough.}

\item{args_not_specified_msg}{custom feedback message in case the student did
call the function with the arguments listed in \code{args}}

\item{incorrect_msg}{custom feedback message in case the student did not call
the function with the same argument values as in the sample solution. You
can specify a vector of arguments with the same length as \code{args}, to
have argument-specific custom feedback.}

\item{state}{state to start from (for \code{check_} functions)}

\item{append}{Whether or not to append the feedback to feedback built in
previous states}

\item{arg}{name of argument to specify (for \code{check_arg})}

\item{arg_not_specified_msg}{custom message in case argument was not
specified (for \code{check_arg})}

\item{...}{S3 stuff}
}
\description{
Test whether a student called a function correctly. Note:
\code{test_function} and \code{test_function_v2} are now identical and either
can be used.
}
\examples{
\dontrun{
# Example 1
mean(1:3)

# SCT option 1
test_function("mean", args = "x")

# SCT option 2
ex() \%>\% check_function("mean") \%>\% check_arg("x") \%>\% check_equal()


# Example 2
mean(c(NA, 1, 2), na.rm = TRUE)

# SCT option 1
test_function("mean", args = c("x", "na.rm"))

# SCT option 2
funstate <- ex() \%>\% check_function("mean")
funstate \%>\% check_arg("x") \%>\% check_equal()
funstate \%>\% check_arg("na.rm") \%>\% check_equal()

# Example 3
5 + 4

# SCT
ex() \%>\% check_operator("+") \%>\% check_result() \%>\% check_equal()
}

}
