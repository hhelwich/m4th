module.exports =

  # checks if actual matrix has the same size and all element number values are similar
  toApprox: (expected, maxEps = 0) ->
    if not expected.isSameSize(@actual)
      return false
    for i in [0...expected.width] by 1
      for j in [0...expected.height] by 1
        if (Math.abs @actual.get(j, i) - expected.get(j, i)) > maxEps
          return false
    true
