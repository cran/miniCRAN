#' Plots a package dependency graph.
#'
#' @param x Object to plot
#' @param pkgsToHighlight Optional character vector with names of package to
#'   highlight. If missing, defaults to packages used in original call to
#'   [makeDepGraph()]
#' @param main Title of plot
#' @param legendPosition Numeric vector of length 2, indicating (x, y) position
#'   of edge legend. Both values should be in the range `[-1; 1]`.  If `NULL`,
#'   the edge legend is not displayed.
#' @param shape Shape of edge.  See [igraph::igraph.plotting()]. Could be
#'   "none", "circle", "square", ...
#' @param vertex.size Size of vertex shape. [igraph::igraph.plotting()]
#' @param cex Vertex label size.
#' @param ... Ignored
#'
#' @importFrom igraph V plot.igraph
#' @export
#'
#' @family dependency functions
#'
#' @example inst/examples/example_plot.pkgDepGraph.R
#'
plot.pkgDepGraph <- function(
  x,
  pkgsToHighlight,
  main = paste(attr(x, "pkgs"), collapse = ", "),
  legendPosition = c(-1.2, -1),
  shape = "circle",
  vertex.size = 8,
  cex = 1,
  ...
) {
  class(x) <- "igraph"
  plotColours <- c("grey80", "orange")
  if (missing("pkgsToHighlight")) {
    pkgsToHighlight <- attr(x, "pkgs")
  }

  topLevel <- as.numeric(igraph::V(x)$name %in% pkgsToHighlight)
  vColor <- plotColours[1 + topLevel]
  vFont <- 1 + topLevel
  vShape <- c("none", shape)[1 + topLevel]

  edgeColor <- c(
    Imports = "red",
    Depends = "orange",
    Suggests = "grey80",
    Enhances = "blue",
    LinkingTo = "black"
  )
  eColor <- edgeColor[igraph::edge_attr(x, "type")]

  typesInGraph <- unique(igraph::edge_attr(x, "type"))
  edgeColor <- edgeColor[typesInGraph]
  # eColor    <- eColor[typesInGraph]

  par(mai = rep(0.25, 4))
  # browser()

  igraph::plot.igraph(
    x,
    vertex.size = vertex.size,
    edge.arrow.size = 0.5,
    edge.color = eColor,
    vertex.label.cex = cex,
    vertex.label.color = "black",
    vertex.color = vColor,
    vertex.shape = vShape,
    vertex.label.font = vFont,
    xlim = c(-1.5, 1)
  )
  pch1 <- rep(19, length(plotColours))
  pch2 <- rep(-8594, length(edgeColor)) #https://www.alanwood.net/unicode/arrows.html
  yjust <- function(x) 0.5 * (x + 1)
  xjust <- function(x) 1

  # Edge legend
  if (!is.null(legendPosition)) {
    legend(
      x = legendPosition[1],
      y = legendPosition[2],
      xjust = xjust(legendPosition[1]),
      yjust = yjust(legendPosition[2]),
      legend = names(edgeColor),
      col = edgeColor,
      pch = pch2,
      y.intersp = 0.75,
      cex = cex
    )
  }
  title(main, cex = cex)
}
