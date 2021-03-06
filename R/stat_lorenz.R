
#' Values of Ordinary Lorenz Curve
#'
#' Provides ordinary Lorenz curve values for line plots
#'
#' @md
#' @inheritParams ggplot2::geom_path
#' @param geom which geom to use; defaults to "`path`".
#' @param desc If FALSE, the default, the population is arranged in ascending
#'   order along the x-axis. If TRUE, the population is arranged in descending
#'   order.
#'
#' @section Aesthetics:
#' \code{stat_lorenz()} understands the following aesthetics:
#' \itemize{
#' \item x (required: wealth of individual, or set of individuals if n aesthetic used)
#' \item n (optional: frequency of given observation x) }
#'
#' @references
#'   [Lorenz curve from Wikipedia](https://en.wikipedia.org/wiki/Lorenz_curve)
#' @importFrom ggplot2 layer
#' @export
#' @examples
#' library(gglorenz)
#'
#' ggplot(billionaires, aes(TNW)) +
#'     stat_lorenz()
#'
#' ggplot(billionaires, aes(TNW)) +
#'     stat_lorenz(desc = TRUE) +
#'     coord_fixed() +
#'     geom_abline(linetype = "dashed") +
#'     theme_minimal()
#'
#' \dontrun{
#' ggplot(freqdata, aes(x=value, n=freq)) +
#'     stat_lorenz() }
#'
stat_lorenz <- function(mapping = NULL, data = NULL,
                        geom = "path", position = "identity",
                        ...,
                        desc = FALSE,
                        show.legend = NA,
                        inherit.aes = TRUE) {
    layer(
        data = data,
        mapping = mapping,
        stat = StatLorenz,
        geom = geom,
        position = position,
        show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(
            desc = desc,
            ...
        )
    )
}

#' @rdname gglorenz-package
#' @format NULL
#' @usage NULL
#' @importFrom ggplot2 ggproto Stat
#' @importFrom ineq Lc
#' @export
StatLorenz <- ggproto("StatLorenz", Stat,
                      default_aes = aes(x = ..x..,
                                        y = ..ordinary_Lorenz_curve..,
                                        n = NULL),
                      required_aes = c("x"),
                      compute_group = function(data, scales, desc = FALSE) {

                          if (any(data$x < 0)) {
                              stop("stat_lorenz() requires a vector containing
                                   non-negative elements.", call. = FALSE)
                          }

                          if (any(names(data) == 'n') & any(data$n < 0)) {
                              stop("stat_lorenz() requires a vector containing
                                   non-negative frequencies", call. = FALSE)
                          }

                          if (any(names(data) == 'n')) {
                              Lc <- ineq::Lc(data$x, data$n)
                          } else {
                              Lc <- ineq::Lc(data$x)
                          }

                          if (desc) {
                              data.frame(x = 1 - Lc$p,
                                         ordinary_Lorenz_curve = 1 - Lc$L)
                          } else {
                              data.frame(x = Lc$p,
                                         ordinary_Lorenz_curve = Lc$L)
                          }
                      }
)
