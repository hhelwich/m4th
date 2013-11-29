
toApprox = (expected, actual, upper, maxEps = 0) ->
  if not expected.isSameSize(actual)
    return false
  for c in [0...expected.width] by 1
    for r in [0...(if upper then c+1 else expected.height)] by 1
      dif = Math.abs actual.get(r, c) - expected.get(r, c)
      if not isFinite(dif) or dif > maxEps
        return false
  true


module.exports =

  # checks if actual matrix has the same size and all element number values are similar
  toApprox: (expected, maxEps) ->
    toApprox expected, @actual, false, maxEps

  toApproxUpper: (expected, maxEps) ->
    toApprox expected, @actual, true, maxEps



