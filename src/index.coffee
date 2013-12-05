# create global index if in browser
index =
  matrix: require "./matrix"
  lu:     require "./lu"
  ud:     require "./ud"

if window?
  window.m4th = index
