M = require 'math/matrix'
_ = require 'math/luDecomposition'

describe 'LU decomposition module', ->

  A = B = L = U = LU = null

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

    B = M [ 10, 4
             3, 8
            -2, 1 ], 2

    @addMatchers
      toApprox: (require './matcher').toApprox

  describe 'LU decomposition', ->

    it 'decomposes a matrix', ->
      _A = A.clone()
      lu = _ _A
      expect(_A).toEqual A # input untouched?
      expect(lu.lu).toEqual LU # correct decomposition?

    it 'can decompose in place', ->
      _A = A.clone()
      lu = _ _A, _A
      expect(lu.lu).toEqual LU # correct decomposition?
      expect(lu.lu).toBe _A # in place ?

  describe 'solve()', ->

    it 'solves an equation', ->
      _B = B.clone()
      C = (_ A).solve _B
      expect(_B).toEqual B # input untouched?
      expect(A.mult(C)).toApprox B, 0.0000000000001 # correct solution?

    it 'can solve in place', ->
      _B = B.clone()
      C = (_ A).solve _B, _B
      expect(C).toBe _B # in place ?
      expect(A.mult(C)).toApprox B, 0.0000000000001 # correct solution?
