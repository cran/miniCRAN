tags <- "chron"

# Plot using defaults

if (interactive()){
  pdb <- pkgAvail(
    repos = c(CRAN = getOption("minicran.mran")),
    type = "source"
  )
} else {
  pdb <- cranJuly2014
}


if (interactive()) {
  dg <- makeDepGraph(tags, availPkgs = pdb  , includeBasePkgs = FALSE,
                     suggests = TRUE, enhances = TRUE)
  
  set.seed(43);
  plot(dg)
  
  
  # Move edge legend to top left
  set.seed(42);
  plot(dg, legendPosition = c(-1, 1))
  
  # Change font size and shape size
  set.seed(42);
  plot(dg, legendPosition = c(-1, 1), vertex.size = 20,  cex = 0.5)
  
  
  # Move vertex legend to top right
  set.seed(42);
  plot(dg, legendPosition = c(1, 1), vertex.size = 20,  cex = 0.5)
}