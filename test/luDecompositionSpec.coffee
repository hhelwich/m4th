chai = require "chai"
expect = chai.expect

chai.use require "./approxAssertion"


M = require "../lib/matrix"
_ = require "../lib/luDecomposition"

describe "LU decomposition module", ->

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


  describe "LU decomposition", ->

    it "decomposes a matrix", ->
      _A = A.clone()
      lu = _ _A
      expect(_A).to.deep.equal A # input untouched?
      expect(lu.lu).to.deep.equal LU # correct decomposition?

    it "can decompose in place", ->
      _A = A.clone()
      lu = _ _A, _A
      expect(lu.lu).to.deep.equal LU # correct decomposition?
      expect(lu.lu).to.equal _A # in place ?

  describe "solve()", ->

    it "solves an equation", ->
      _B = B.clone()
      C = (_ A).solve _B
      expect(_B).to.deep.equal B # input untouched?
      expect(A.mult(C)).to.approx B, 0.0000000000001 # correct solution?

    it "can solve in place", ->
      _B = B.clone()
      C = (_ A).solve _B, _B
      expect(C).to.equal _B # in place ?
      expect(A.mult(C)).to.approx B, 0.0000000000001 # correct solution?


  describe "getInverse()", ->

    it "returns the inverse of the source matrix", ->
      _A = A.clone()
      B = (_ _A).getInverse()
      expect(_A).to.deep.equal A # input untouched?
      # correct solution?
      expect(A.mult(B)).to.approx (M.I 3), 0.000000000000001
      expect(B.mult(A)).to.approx (M.I 3), 0.00000000000001
