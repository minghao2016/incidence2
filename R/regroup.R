#' Regroup 'incidence' objects
#'
#' This function regroups an [incidence()] object across the specified groups.
#' The resulting [incidence()] object will contains counts summed over
#' the groups present in the input.
#'
#' @param x An [incidence()] object.
#' @param groups The groups to sum over.  If `NULL` (default) then the function
#'   ignores all groups.
#'
#' @examples
#' if (requireNamespace("outbreaks", quietly = TRUE)) {
#'   withAutoprint({
#'     data(ebola_sim_clean, package = "outbreaks")
#'     dat <- ebola_sim_clean$linelist
#'     i <- incidence(dat,
#'                    date_index = date_of_onset,
#'                    groups = c(gender, hospital))
#'
#'     i %>% regroup()
#'
#'     i %>% regroup(hospital)
#'   })
#' }
#'
#' @export
regroup <- function(x, groups = NULL){

  if (!inherits(x, "incidence2")) {
    stop(sprintf(
      "x should be an 'incidence2' object.",
      class(x)))
  }

  # check groups present
  groups <- eval(substitute(alist(groups)))[[1]]
  groups <- arg_to_values(groups)
  column_names <- names(x)
  check_presence(groups, column_names)

  date_var <- get_dates_name(x)
  count_var <- get_counts_name(x)
  cumulate <- attr(x, "cumulative")
  interval <- get_interval(x)

  if (!is.null(groups)) {
    tbl <- grouped_df(x, c(date_var, groups))
  } else {
    tbl <- grouped_df(x, date_var)
  }
  tbl <- summarise(tbl, count = sum(.data[[count_var]]))

  # create subclass of tibble
  tbl <- tibble::new_tibble(tbl,
                            groups = groups,
                            date = date_var,
                            count = count_var,
                            interval = interval,
                            cumulative = cumulate,
                            nrow = nrow(tbl),
                            class = "incidence2"
  )
  tbl <- tibble::validate_tibble(tbl)

  if (has_weeks(x)) {
    week_start <- get_week_start(interval)
    week_var <- get_date_group_names(x)
    date_var <- get_dates_name(x)
    tbl[[week_var]] <- aweek::date2week(tbl[[date_var]], week_start, floor_day = TRUE)
    tbl <- dplyr::relocate(tbl, .data[[week_var]], .after = .data[[date_var]])
    attr(tbl, "date_group") <- week_var
  }

  tbl
}
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
#' Pool 'incidence' objects
#'
#' Pool was a function from the original incidence package that has now been
#'   deprecated in favour of [regroup()]
#'
#' @param ... Not used.
#'
#' @keywords internal
#' @export
pool <- function(...) {
  stop("The pool function has been deprecated.  Please use regroup() instead.")
}
# -------------------------------------------------------------------------


