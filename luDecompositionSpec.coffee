M = require 'math/matrix'
_ = require 'math/luDecomposition'

describe 'LU decomposition module', ->

  A = L = U = LU = null

  beforeEach ->

    A = M [ 1,  2,  3
            4,  5,  6
            7,  8,  0 ]

    L = M [ 1,  0,  0
            4,  1,  0
            7,  2,  1 ]

    U = M [ 1,  2,  3
            0, -3, -6
            0,  0, -9 ]

    LU = L.minus(M.I 3).add U

  describe 'LU decomposition', ->

    it 'decomposes a matrix', ->
      expect(_ A).toEqual LU
