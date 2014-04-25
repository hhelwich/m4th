

M = require "./matrix"

creator = require "ut1l/create/object"
T = require "ut1l/create/throwable"
fail = T "MatrixException"

###
  A very basic LU decomposition implementation without pivoting. Decomposition is done in place. Given buffer must
  be square and regular. The values of L below the diagonal are stored. The ones on the diagonal and the zeros
  above the diagonal are not stored. The values of U on and above the diagonal are stored. The zero values below
  the diagonal are not stored.
###


luDecompConstructor = (A, T = do A.clone) ->
  # TODO add pivoting (also more accurate?)
  # TODO allow non square matrices
  for i in [0...T.columns] by 1 # iterate columns of A
    # calculate U
    for j in [i...T.columns] by 1
      for k in [0...i] by 1
        T.set i, j, (T.get i, j) - (T.get i, k) * (T.get k, j) # -=
    # calculate L
    for j in [i+1...T.columns] by 1
      for k in [0...i] by 1
        T.set j, i, (T.get j, i) - (T.get j, k) * (T.get k, i) # -=
      T.set j, i, (T.get j, i) / (T.get i, i) # -=
  @lu = T
  return


luDecompPrototype =

  ### Calculate X = A^-1 * B in place or not in place ###

  solve: (B, T = do B.clone) ->
    A = @lu
    if B.rows != A.columns or not B.isSize T
      fail "unmatching matrix dimension"

    # solve L*Y = B; calculate Y = L^-1 * B
    for k in [0...A.columns] by 1
      for i in [k+1...A.columns] by 1
        for j in [0...T.columns] by 1
          T.set i, j, (T.get i, j) - (T.get k, j) * (A.get i, k) # -=
    # solve U*X = Y; calculate X = U^-1 * Y = U^-1 *L^-1 * B = A^-1 * B
    for k in [A.columns-1..0] by -1
      for j in [0...T.columns] by 1
        T.set k, j, (T.get k, j) / (A.get k, k) # /=
      for i in [0...k] by 1
        for j in [0...T.columns] by 1
          T.set i, j, (T.get i, j) - (T.get k, j) * (A.get i, k) # -=
    T

  getInverse: ->
    I = M.I @lu.columns
    @solve I, I



module.exports = creator luDecompConstructor, luDecompPrototype
