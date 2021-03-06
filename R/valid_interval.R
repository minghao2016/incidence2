#' Is the interval a valid date character
#'
#' @param the_interval An interval string.
#'
#' @return a logical value
#' @noRd
is_date_interval <- function(the_interval) {
  valid_intervals <- "day|week|month|quarter|year"
  grepl(valid_intervals, the_interval, ignore.case = TRUE)
}
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
#' Validate potential character values for interval
#'
#' Characters are valid for intervals if they are of the form "day", "week",
#' "month", etc. They can ALSO be valid if they are characters that convert to
#' numbers.
#'
#' @param the_interval A character string of length one.
#'
#' @return The character string OR a numeric value.
#' @noRd
valid_interval_character <- function(the_interval, standard = TRUE) {
  if (is.character(the_interval)) {
    if (!is_date_interval(the_interval)) {
      suppressWarnings({
        the_interval <- as.numeric(the_interval)
      })
      if (is.na(the_interval)) {
        stop(paste('The interval must be a number or one of the following:',
                   '"day", "week", "month", "quarter" or "year"'),
             call. = FALSE
        )
      }
    } else {
      valid_intervals <- "^\\d?\\s?(day|week|month|quarter|year)s?$"
      must_be_standard <- !grepl(valid_intervals, the_interval, ignore.case = TRUE)
      if (!standard && must_be_standard) {
        stop(sprintf("The interval '%s' implies a standard and cannot be used with `standard = FALSE`",
                     the_interval))
      }
    }
  }
  the_interval
}
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
#' Check to make sure an interval is valid for integer dates
#'
#' This will try to convert the interval if its a character, but complain if
#' it doesn't pass check.
#'
#' @param interval Either an integer or character.
#'
#' @return Interval or it will stop.
#' @noRd
valid_interval_integer <- function(interval) {
  if (is.character(interval)) {
    res <- try(valid_interval_character(interval), silent = TRUE)
    if (inherits(res, "try-error")) {
      msg <- sprintf("The interval '%s' is not valid. Please supply an integer.", interval)
      stop(msg, call. = FALSE)
    } else if (is.character(res)) {
      msg <- sprintf(
        "The interval '%s' can only be used for Dates, not integers or numerics.",
        interval
      )
      stop(msg, call. = FALSE)
    }
  }
  interval
}
# -------------------------------------------------------------------------
