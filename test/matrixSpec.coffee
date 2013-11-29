expect = (require "chai").expect

M = require "../lib/matrix"

describe "Matrix module", ->

  A = null
  A2 = null
  A3 = null
  A2_A = null

  beforeEach ->

    A  =   M [ 1,  3,  5
               2,  4,  6 ], 3
    # a_{ij}^2
    A2 =   M [ 1,  9, 25
               4, 16, 36 ], 3
    # a_{ij}*3
    A3 =   M [ 3,  9, 15
               6, 12, 18 ], 3
    # A2 - A
    A2_A = M [ 0,  6, 20
               2, 12, 30 ], 3

  describe "Matrix constructor", ->

    it "should be able to create a new empty matrix", ->

      B = M []
      expect(B.array).to.deep.equal []
      expect(B.height).to.equal 0
      expect(B.width).to.equal 0

    it "should be able to create a new square matrix without width param", ->

      B = M [ 1, 2, 3
              4, 5, 6
              7, 8, 9 ]
      expect(B.height).to.equal 3
      expect(B.width).to.equal 3

    it "should be able to create a new rectangular matrix", ->

      B = M [ 1, 2, 3
              4, 5, 6 ], 3
      expect(B.height).to.equal 2
      expect(B.width).to.equal 3

    it "should be able to create a new empty square matrix", ->

      B = M 3
      (expect B.height).to.equal 3
      (expect B.width).to.equal 3
      (expect B.get 1, 2).to.be.undefined

    it "should be able to create a new empty rectangular matrix", ->

      B = M 3, 2
      (expect B.height).to.equal 2
      (expect B.width).to.equal 3
      (expect B.get 1, 2).to.be.undefined

    it "should throw on wrong width", ->

      expect(-> M [ 1, 2, 3 ], 2).to.throw()

    it "should throw on param call with not square array size", ->

      expect(-> M [ 1, 2, 3 ]).to.throw()


  describe "get() function", ->

    it "gets matrix elements", ->

      expect(A.get(0, 0)).to.equal 1
      expect(A.get(0, 1)).to.equal 3
      expect(A.get(1, 0)).to.equal 2
      expect(A.get(1, 2)).to.equal 6


  describe "set() function", ->

    it "sets matrix elements", ->

      expect(A.get(0, 0)).to.equal 1
      expect(A.set(0, 0, 3).get(0, 0)).to.equal 3
      expect(A.get(1, 2)).to.equal 6
      expect(A.set(1, 2, 7).get(1, 2)).to.equal 7


  describe "isSameSize() function", ->

    it "should return true on same sized matrices", ->

      expect(A.isSameSize(A)).to.be.true
      expect(A.isSameSize(A2)).to.be.true

    it "should return false on different sized matrices", ->

      expect(A.isSameSize(M [])).to.be.false
      expect(A.isSameSize(M [ 1, 2, 3 ], 3)).to.be.false


  describe "isSquare() function", ->

    it "should return true on square matrices", ->

      expect((M []).isSquare()).to.be.true
      expect((M [1]).isSquare()).to.be.true
      expect((M [1, 2
                 3, 4]).isSquare()).to.be.true

    it "should return false on not square matrices", ->

      expect(A.isSquare()).to.be.false


  describe "clone() function", ->

    it "should be able to clone a matrix", ->

      B = A.clone()
      expect(B).not.to.equal A
      expect(B).to.deep.equal A

    it "should be able to clone to an existing matrix", ->

      B = A.clone(A2)
      expect(B).not.to.equal A
      expect(B).to.equal A2
      expect(B).to.deep.equal A


  describe "map() function", ->

    it "should be able to map to a new matrix", ->

      B = A.clone()
      C = B.map((x) -> x*x)
      expect(C).not.to.equal B # in place ?
      # adapted correctly ?
      expect(C).to.deep.equal A2

    it "should be able to map a matrix in place", ->
      B = A.clone()
      C = B.map ((x) -> x*x), B
      expect(C).to.equal B # A returned ?
      expect(C).to.deep.equal A2 # B adapted correctly ?

    it "should be able to map a matrix to a different matrix", ->
      B = A.clone()
      C = A.clone()
      D = B.map ((x) -> x*x), C
      expect(B).to.deep.equal A # B adapted correctly ?
      expect(D).to.equal C # A returned ?
      expect(D).to.deep.equal A2 # B adapted correctly ?


  describe "times() function", ->

    it "should multiply a matrix (and create a new instance)", ->
      B = A.clone()
      C = B.times(3)
      expect(C).not.to.equal B # not in place ?
      expect(B).to.deep.equal A # source not changed ?
      expect(C).to.deep.equal A3 # adapted correctly ?

    it "should be able to multiply a matrix in place", ->
      B = A.clone()
      C = B.times(3, B)
      expect(C).to.equal B # B returned ?
      expect(C).to.deep.equal A3 # B adapted correctly ?


  describe "fill() function", ->

    it "fills to a new matrix", ->
      B = A.clone()
      C = B.fill(7)
      expect(C).not.to.equal B # not in place ?
      expect(C).to.deep.equal M [ 7, 7, 7
                            7, 7, 7 ], 3 # adapted correctly ?


  describe "zip() function", ->

    it "maps two matrices to a new one", ->
      B = A.clone()
      B2 = A2.clone()
      C = B.zip(((a, b) -> b - a), B2)
      expect(C).to.deep.equal A2_A
      expect(C).not.to.equal B
      expect(B).to.deep.equal A
      expect(B2).to.deep.equal A2

    it "maps two matrices to the first in place", ->
      B = A.clone()
      B2 = A2.clone()
      C = B.zip(((a, b) -> b - a), B2, B)
      expect(C).to.deep.equal A2_A
      expect(C).to.equal B
      expect(B2).to.deep.equal A2


  describe "add() function", ->

    it "adds two matrices to a new one", ->
      B = A2_A.clone()
      B2 = A.clone()
      C = B.add(B2) # tested function
      expect(C).to.deep.equal A2 # expected result?
      expect(C).not.to.equal B # not in place?
      expect(C).not.to.equal B2
      expect(B).to.deep.equal A2_A # source unchanged ?
      expect(B2).to.deep.equal A

    it "adds two matrices to the second matrix", ->
      B = A2_A.clone()
      B2 = A.clone()
      C = B.add(B2, B2) # tested function
      expect(C).to.deep.equal A2 # expected result?
      expect(C).to.equal B2 # in place ?
      expect(C).not.to.equal B # not in place?
      expect(B).to.deep.equal A2_A # source unchanged ?


  describe "minus() function", ->

    it "subtrats two matrices to a new matrix", ->
      B = A2.clone()
      B2 = A.clone()
      C = B.minus(B2) # tested function
      expect(C).to.deep.equal A2_A # expected result?
      expect(C).not.to.equal B # not in place?
      expect(C).not.to.equal B2
      expect(B).to.deep.equal A2 # source unchanged ?
      expect(B2).to.deep.equal A


  describe "transp() function", ->

    it "transposes a matrix to a new matrix", ->
      B = A.clone()
      C = B.transp() # tested function
      expect(C).to.deep.equal M [ 1, 2
                            3, 4
                            5, 6 ], 2 # expected result?
      expect(C).not.to.equal B # not in place?
      expect(B).to.deep.equal A # source unchanged ?

    it "transposes a matrix in place", ->
      C = A.transp A # tested function
      expect(C).to.deep.equal M [ 1, 2
                            3, 4
                            5, 6 ], 2 # expected result?
      expect(C).to.equal A # in place?
      expect(C.array).to.equal A.array


  describe "mult() function", ->

    it "multiplies two matrices to a new matrix", ->
      A = M [ -4,  1,  6
              -2,  5, -3 ], 3
      B = M [ -4, -1,  1, 6
               0,  4, -3, 2
               3, -2,  5, 7 ], 4
      A2 = A.clone();
      B2 = B.clone();
      C = A2.mult(B2) # tested function
      expect(C).to.deep.equal M [ 34, -4,  23,  20
                            -1, 28, -32, -23 ], 4 # expected result?
      expect(A2).to.deep.equal A # source unchanged ?
      expect(B2).to.deep.equal B # source unchanged ?


  describe "toString() function", ->

    it "should return the matrix as string", ->
      expect(A.toString()).to.equal "1 3 5\n2 4 6"


  describe "I()", ->

    it "creates a new identity matrix", ->
      expect(M.I(3)).to.deep.equal M [ 1, 0, 0
                                 0, 1, 0
                                 0, 0, 1 ]
      expect(M.I(3, 2)).to.deep.equal M [ 1, 0, 0
                                    0, 1, 0 ], 3


  describe "diag()", ->

    it "creates a new diagonal matrix from a column vector", ->
      expect(M.diag(M [2, 3, 4], 1)).to.deep.equal M [ 2, 0, 0
                                                 0, 3, 0
                                                 0, 0, 4 ]

    it "can use existing buffer", ->
      T = (M.I 3).fill 5
      D = M.diag((M [2, 3, 4], 1), T)
      expect(D).to.deep.equal M [ 2, 0, 0
                            0, 3, 0
                            0, 0, 4 ]
      expect(D).to.equal T
