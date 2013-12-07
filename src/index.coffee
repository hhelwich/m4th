module.exports = index =
  matrix: require "./matrix"
  lu:     require "./lu"
  ud:     require "./ud"

# create global index if in browser
if window?
  window.m4th = index
