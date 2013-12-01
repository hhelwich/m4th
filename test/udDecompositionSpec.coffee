chai = require "chai"
expect = chai.expect

chai.use require "./approxAssertion"


M = require "../src/matrix"
_ = require "../src/udDecomposition"

describe "UD decomposition module", ->

  A = U = D = UD = B = null

  beforeEach ->

    # any square upper unit triangular matrix
    U = M [ 1, -2,  3
            0,  1, -4
            0,  0,  1 ]

    # any square diagonal matrix
    D = M [ 6,  0, 0
            0, -3, 0
            0,  0, 7 ]

    # spd matrix A = U * D * U^t
    A = (U.mult D).mult U.transp()

    # expected in place UD transpose B = U - I + D
    UD = (U.minus M.I U.height).add D

    B = M [ 3, -7
            5,  6
            9,  8 ], 2


  describe "UD decomposition", ->

    it "decomposes a spd matrix", ->

      _A = A.clone()
      ud = _ _A
      expect(_A).to.deep.equal A # input untouched?
      expect(ud.ud).to.approxUpper UD # correct decomposition?

    it "can decompose in place", ->

      _A = A.clone()
      ud = _ _A, _A
      expect(ud.ud).to.approxUpper UD # correct decomposition?
      expect(ud.ud).to.equal _A # in place ?


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