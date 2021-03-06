% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.R, R/scale_x_incidence.R
\name{plot.incidence2}
\alias{plot.incidence2}
\alias{facet_plot}
\alias{facet_plot.incidence2}
\alias{scale_x_incidence}
\title{Plotting functions}
\usage{
\method{plot}{incidence2}(
  x,
  fill = NULL,
  stack = TRUE,
  title = NULL,
  col_pal = vibrant,
  alpha = 0.7,
  color = NA,
  xlab = "",
  ylab = NULL,
  n_breaks = 6,
  show_cases = FALSE,
  border = "white",
  na_color = "grey",
  group_labels = TRUE,
  centre_ticks = FALSE,
  legend = c("right", "left", "bottom", "top", "none"),
  angle = 0,
  format = NULL,
  ...
)

facet_plot(x, ...)

\method{facet_plot}{incidence2}(
  x,
  facets = NULL,
  stack = TRUE,
  fill = NULL,
  title = NULL,
  col_pal = vibrant,
  alpha = 0.7,
  color = NA,
  xlab = "",
  ylab = NULL,
  n_breaks = 3,
  show_cases = FALSE,
  border = "white",
  na_color = "grey",
  group_labels = TRUE,
  centre_ticks = FALSE,
  legend = c("bottom", "top", "left", "right", "none"),
  angle = 0,
  format = NULL,
  nrow = NULL,
  ...
)

scale_x_incidence(
  x,
  n_breaks = 6,
  group_labels = TRUE,
  format = NULL,
  angle = 0,
  size = NULL,
  coord_equal = FALSE,
  ...
)
}
\arguments{
\item{x}{An \code{\link[=incidence]{incidence()}} object.}

\item{fill}{Which variable to color plots by. If NULL no distinction if made
for plot colors.}

\item{stack}{A logical indicating if bars of multiple groups should be
stacked, or displayed side-by-side. Only used if fill is not NULL.}

\item{title}{Optional title for the graph.}

\item{col_pal}{col_pal The color palette to be used for the groups; defaults
to \code{vibrant} (see \code{?palettes}).}

\item{alpha}{The alpha level for color transparency, with 1 being fully
opaque and 0 fully transparent; defaults to 0.7.}

\item{color}{The color to be used for the borders of the bars; NA for
invisible borders; defaults to \code{NA}.}

\item{xlab}{The label to be used for the x-axis; empty by default.}

\item{ylab}{The label to be used for the y-axis; by default, a label will be
generated automatically according to the time interval used in incidence
computation.}

\item{n_breaks}{n_breaks the ideal number of breaks to be used for the x-axis
labeling}

\item{show_cases}{if \code{TRUE} (default: \code{FALSE}), then each observation will be
colored by a border. The border defaults to a white border unless specified
otherwise. This is normally used outbreaks with a small number of cases.
Note: this can only be used if \code{stack = TRUE}}

\item{border}{If show_cases is TRUE this represents the color used for the
borders of the individual squares plotted (defaults to \code{"white"}).}

\item{na_color}{The colour to plot \code{NA} values in graphs (default: \code{grey}).}

\item{group_labels}{group_labels a logical value indicating whether labels x
axis tick marks are in week format YYYY-Www when plotting weekly incidence;
defaults to TRUE.}

\item{centre_ticks}{Should ticks on the x axis be centred on the bars. This
only applies to intervals that produce unambiguous labels (i.e \verb{1 day},
\verb{1 month}, \verb{1 quarter} or \verb{1 year}).  Defaults to \code{FALSE}.}

\item{legend}{Position of legend in plot.}

\item{angle}{Angle to rotate x-axis labels.}

\item{format}{Character string of desired format.  See \code{?strptime}.}

\item{...}{arguments passed to \code{\link[ggplot2:scale_date]{ggplot2::scale_x_date()}},
\code{\link[ggplot2:scale_date]{ggplot2::scale_x_datetime()}}, or \code{\link[ggplot2:scale_continuous]{ggplot2::scale_x_continuous()}},
depending on how the \verb{$date} element is stored in the incidence object.}

\item{facets}{Which variable to facet plots by.  If NULL will use all
group_labels of the incidence object.}

\item{nrow}{Number of rows.}

\item{size}{text size in pts.}

\item{coord_equal}{Should the x and y axis display with equal ratio.}
}
\value{
\itemize{
\item \code{facet_plot()} and \code{plot()} generate a \code{\link[ggplot2:ggplot]{ggplot2::ggplot()}} object.
}
}
\description{
incidence2 includes two plotting functions to simplify graph creation.
}
\details{
\itemize{
\item \code{plot} creates a one-pane graph of an incidence object.
\item \code{facet_plot} creates a multi-facet graph of a grouped incidence object.
If the object has no groups it returns the same output as a call to
\code{\link[=plot]{plot()}}.
\item If the \code{\link[=incidence]{incidence()}} object has a rolling average column then that
average will be overlaid on top.
}
}
\examples{
if (requireNamespace("outbreaks", quietly = TRUE)) {
  withAutoprint({
    data(ebola_sim_clean, package = "outbreaks")
    dat <- ebola_sim_clean$linelist

    inci <- incidence(dat,
                      date_index = date_of_onset,
                      interval = 7,
                      groups = hospital)

    inci2 <- incidence(dat,
                      date_index = date_of_onset,
                      interval = 7,
                      groups = c(hospital, gender))

    plot(inci)
    plot(inci, fill = hospital)
    plot(inci, fill = hospital, stack = FALSE)

    facet_plot(inci)
    facet_plot(inci2)
    facet_plot(inci2, facets = gender)
    facet_plot(inci2, facets = hospital, fill = gender)
  })
}
}
