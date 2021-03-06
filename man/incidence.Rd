% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/incidence.R
\name{incidence}
\alias{incidence}
\title{Compute the incidence of events}
\usage{
incidence(
  x,
  date_index,
  groups = NULL,
  interval = 1L,
  first_date = NULL,
  last_date = NULL,
  na_as_group = TRUE,
  standard = TRUE,
  count = NULL
)
}
\arguments{
\item{x}{A tibble or a data frame (see Note) representing a linelist.}

\item{date_index}{The time index of the given data.  This should be the name,
with or without quotation, corresponding to a date column in x of the
class:  integer, numeric, Date, POSIXct, POSIXlt, and character. (See Note
about \code{numeric} and \code{character} formats)}

\item{groups}{An optional vector giving the names of the groups of
observations for which incidence should be grouped.  This can be given with
or without quotation.`}

\item{interval}{An integer or character indicating the (fixed) size of the
time interval used for computing the incidence; defaults to 1 day. This can
also be a text string that corresponds to a valid date interval: day, week,
month, quarter, or year. (See Note).}

\item{first_date, last_date}{optional first/last dates to be used. When
these are \code{NULL} (default), the dates from the first/last dates are taken
from the observations. If these dates are provided, the observations will
be trimmed to the range of [first_date, last_date].}

\item{na_as_group}{A logical value indicating if missing group values (NA)
should treated as a separate category (\code{TRUE}) or removed from
consideration (\code{FALSE}).}

\item{standard}{(Only applicable where date_index references a Date object)
When \code{TRUE} (default) and the \code{interval} one of "week", "month", "quarter",
or "year", then this will cause the bins for the counts to start at the
beginning of the interval (See Note).}

\item{count}{The count variable of the given data.  If NULL (default) the
data is taken to be a linelist of individual observations.}
}
\value{
An incidence2 object.  This is a subclass of tibble that represents
and aggregated count of observations grouped according to the specified
interval and, optionally, the given groups.  By default it will contain the
following columns:
\itemize{
\item \strong{bin_date}:  The dates marking the left side of the bins used for
counting events. When \code{standard = TRUE} and the interval represents weeks,
months, quarters, or years, the first date will represent the first
standard date (See Interval specification, below).
\item \strong{-groups-}: If specified, column(s) containing the categories of the
given groups.
\item \strong{count}: The aggregated observation count.
}

If a "week" interval is specified then the object may also contain
additional columns:
\itemize{
\item \strong{weeks}: Dates in week format (YYYY-Www), where YYYY corresponds to the
year of the given week and ww represents the numeric week of the year.
This will be a produced from the function \code{\link[aweek:date2week]{aweek::date2week()}}. Note that
these will have a special \code{"week_start"} attribute indicating which day of
the ISO week the week starts on (see Weeks, below).
}
}
\description{
Compute the incidence of events
}
\note{
\subsection{Input data (\code{dates})}{
\itemize{
\item \strong{Decimal (numeric) dates}: will be truncated with a warning
\item \strong{Character dates} should be in the unambiguous \code{yyyy-mm-dd} (ISO 8601)
format. Any other format will trigger an error.
}
}

\subsection{Interval specification (\code{interval})}{
If \code{interval} is a valid character (e.g. "week" or "1 month"), then
the bin will start at the beginning of the interval just before the first
observation by default. For example, if the first case was recorded on
Wednesday, 2018-05-09:
\itemize{
\item "week"    : first day of the week (i.e. Monday, 2018-05-07) (defaults to
ISO weeks, see "Week intervals", below)
\item "month"   : first day of the month (i.e. 2018-05-01)
\item "quarter" : first day of the quarter (i.e. 2018-04-01)
\item "year"    : first day of the calendar year (i.e. 2018-01-01)
}

These default intervals can be overridden with \code{standard = FALSE}, which
sets the interval to begin at the first observed case.
}

\subsection{Week intervals}{

It is possible to construct standardized
incidence objects standardized to any day of the week thanks to the
\code{\link[aweek:date2week]{aweek::date2week()}} function from the \pkg{aweek} package. The default
state is to use ISO 8601 definition of weeks, which start on Monday. You can
specify the day of the week an incidence object should be standardised to by
using the pattern "{n} {W} weeks" where "{W}" represents the weekday in an
English or current locale and "{n}" represents the duration, but this can be
ommitted.  Below are examples of specifying weeks starting on different days
assuming we had data that started on 2016-09-05, which is ISO week 36 of
2016:
\itemize{
\item interval = "2 monday weeks" (Monday 2016-09-05)
\item interval = "1 tue week" (Tuesday 2016-08-30)
\item interval = "1 Wed week" (Wednesday 2016-08-31)
\item interval = "1 Thursday week" (Thursday 2016-09-01)
\item interval = "1 F week" (Friday 2016-09-02)
\item interval = "1 Saturday week" (Saturday 2016-09-03)
\item interval = "Sunday week" (Sunday 2016-09-04)
}

It's also possible to use something like "3 weeks: Saturday"; In addition,
there are keywords reserved for specific days of the week:
\itemize{
\item interval = "week", standard = TRUE (Default, Monday)
\item interval = "ISOweek"  (Monday)
\item interval = "EPIweek"  (Sunday)
\item interval = "MMWRweek" (Sunday)
}

The "EPIweek" specification is not strictly reserved for CDC epiweeks, but
can be prefixed (or posfixed) by a day of the week: "1 epiweek: Saturday".

}

The intervals for "month", "quarter", and "year" will necessarily vary in the
number of days they encompass and warnings will be generated when the first
date falls outside of a calendar date that is easily represented across the
interval.
}
\examples{
if (requireNamespace("outbreaks", quietly = TRUE)) {
  withAutoprint({
    data(ebola_sim_clean, package = "outbreaks")
    dat <- ebola_sim_clean$linelist


    # daily incidence
    dat \%>\%
      incidence(date_of_onset)

    # weekly incidence
    dat \%>\%
      incidence(date_of_onset, interval = "week", standard = FALSE)

    # starting on a Monday
    dat \%>\%
      incidence(date_of_onset, interval = "isoweek")

    # starting on a Sunday
    dat \%>\%
      incidence(date_of_onset, interval = "epiweek")

    # starting on a Saturday
    dat \%>\%
      incidence(date_of_onset, interval = "saturday epiweek")

    # group by gender
    dat \%>\%
      incidence(date_of_onset, interval = 7, groups = gender)

    # group by gender and hospital
    dat \%>\%
      incidence(date_of_onset,
                interval = "2 weeks",
                groups = c(gender, hospital))
  })
}

# use of first_date
dat <- data.frame(dates = Sys.Date() + sample(-3:10, 10, replace = TRUE))
dat \%>\% incidence(dates,
                  interval = "week",
                  first_date = Sys.Date() + 1)
}
