M = require "./matrix"
createConstructor = (require "../util/obj").createConstructor

fail = (require "../util/log").fail


udDecompConstructor = (A, T = do A.clone, U = T, D = T) ->
  if not do T.isSquare
    fail "matrix must be square"
  @size = T.width
  for j in [@size-1..0] by -1
    for i in [j..0] by -1
      s = T.get i, j
      for k in [j+1...@size] by 1
        s -= (U.get i, k) * (D.get k, k) * (U.get j, k)
      if i == j
        D.set j, j, s
      else
        if (D.get j, j) == 0
          fail "not a regular matrix"
        U.set i, j, s / D.get j, j
  @ud = T

udDecompPrototype =

  solveDiagonal: (y, t = do y.clone) ->

    for i in [0...@size] by 1
      for j in [0...y.width] by 1
        t.set i, j, y.get(i, j) / @ud.get(i, i)
    t

  solveUnitTriangular: (y, transp, t = do y.clone) ->
    if transp # forward substitution
      for j in [0...y.width] by 1
        for i in [0...@size] by 1
          t.set i, j, y.get i, j
          for k in [0...i] by 1
            t.set i, j, (t.get i, j) - (@ud.get k, i) * (t.get k, j) # -=
    else # back substitution
      for j in [0...y.width] by 1
        for i in [@size-1..0] by -1
          t.set i, j, y.get i, j
          for k in [i+1...@size] by 1
            t.set i, j, (t.get i, j) - (@ud.get i, k) * (t.get k, j) # -=
    t

  solve: (y, t = do y.clone) ->
    # (nxm) X1 = U^-1 * Y
    @solveUnitTriangular y, false, t
    # (nxm) X2 = D^-1 * X1 = (U * D)^-1 * Y
    @solveDiagonal t, t
    # (nxm) X = U^-1^t * X2 = (U * D * U^t)^-1 * Y = A^-1 * Y
    @solveUnitTriangular t, true, t
    t

module.exports = createConstructor udDecompPrototype, udDecompConstructor