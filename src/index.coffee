# create global index if in browser
index =
  matrix: require "./matrix"
  lu:     require "./luDecomposition"
  ud:     require "./udDecomposition"

if window?
  window.m4th = index
