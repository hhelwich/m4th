M = require './matrix'

###
  A very basic LU decomposition implementation without pivoting. Decomposition is done in place. Given buffer must
  be square and regular. The values of L below the diagonal are stored. The ones on the diagonal and the zeros
  above the diagonal are not stored. The values of U on and above the diagonal are stored. The zero values below
  the diagonal are not stored.
###

decomposeLU = (A) ->
# TODO add pivoting (also more accurate?)
# TODO allow non square matrices
  for i in [0...A.width] by 1 # iterate columns of A
    # calculate U
    for j in [i...A.width] by 1
      for k in [0...i] by 1
        A.set(i, j, A.get(i, j) - A.get(i, k) * A.get(k, j)) # -=
    # calculate L
    for j in [i+1...A.width] by 1
      for k in [0...i] by 1
        A.set(j, i, A.get(j, i) - A.get(j, k) * A.get(k, i)) # -=
      A.set(j, i, A.get(j, i) / A.get(i, i)) # -=
  A


module.exports = decomposeLU