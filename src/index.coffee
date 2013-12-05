# create global index if in browser

if window?
  window.m4th =
    matrix: require "./matrix"
    lu:     require "./luDecomposition"
    ud:     require "./udDecomposition"
