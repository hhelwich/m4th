expect = (require "chai").expect

M = require "../src/matrix"

describe "Matrix", ->

  A = null
  A2 = null
  A3 = null
  A2_A = null

  beforeEach ->

    A  =   M 2,[
      1,  3,  5
      2,  4,  6
    ]
    # a_{ij}^2
    A2 =   M 2,[
      1,  9, 25
      4, 16, 36
    ]
    # a_{ij}*3
    A3 =   M 2,[
      3,  9, 15
      6, 12, 18
    ]
    # A2 - A
    A2_A = M 2,[
      0,  6, 20
      2, 12, 30
    ]

  describe "Constructor", ->

    it "creates empty matrices", ->
      B = M []
      expect(B.array).to.deep.equal []
      expect(B.rows).to.equal 0
      expect(B.columns).to.equal 0

    it "creates square matrices by array", ->
      B = M [
        1, 2, 3
        4, 5, 6
        7, 8, 9
      ]
      expect(B.rows).to.equal 3
      expect(B.columns).to.equal 3

    it "creates rectangular matrices", ->
      B = M 2,[
        1, 2, 3
        4, 5, 6
      ]
      expect(B.rows).to.equal 2
      expect(B.columns).to.equal 3

    it "creates empty square matrices", ->
      B = M 3
      (expect B.rows).to.equal 3
      (expect B.columns).to.equal 3
      (expect B.get 1, 2).to.be.undefined

    it "creates empty rectangular matrices", ->
      B = M 2, 3
      (expect B.rows).to.equal 2
      (expect B.columns).to.equal 3
      (expect B.get 1, 2).to.be.undefined

    it "throws on wrong row value", ->
      expect(-> M 2, [ 1, 2, 3 ]).to.throw()

    it "uses floor square array size as columns if no columns value is given", ->
      A = M [ 1, 2, 3, 4, 5, 6 ]
      (expect A.rows).to.equal 2
      (expect A.columns).to.equal 3

    it "throws on irregular array size", ->
      expect(-> M [ 1, 2, 3, 4, 5, 6, 7 ]).to.throw()


  describe "get()", ->

    it "gets a matrix entry", ->
      (expect A.get 0, 0).to.equal 1
      (expect A.get 0, 1).to.equal 3
      (expect A.get 1, 0).to.equal 2
      (expect A.get 1, 2).to.equal 6

    it "gets a column vector entry without column index", ->
      v = M 3, [2, 3, 4]
      (expect v.get 0).to.equal 2
      (expect v.get 1).to.equal 3
      (expect v.get 2).to.equal 4


  describe "set()", ->

    it "sets a matrix entry", ->
      (expect A.get 0, 0).to.equal 1
      (expect (A.set 0, 0, 3).get 0, 0).to.equal 3
      (expect A.get 1, 2).to.equal 6
      (expect (A.set 1, 2, 7).get 1, 2).to.equal 7


  describe "isSize()", ->

    it "returns true on a same sized matrix", ->
      (expect A.isSize A).to.be.true
      (expect A.isSize A2).to.be.true

    it "returns false on a different sized matrix", ->
      (expect A.isSize M []).to.be.false
      (expect A.isSize M 3, [ 1, 2, 3 ]).to.be.false

    it "returns false on a different sized matrix", ->
      (expect A.isSize M []).to.be.false
      (expect A.isSize M 1, [ 1, 2, 3 ]).to.be.false


  describe "isSquare()", ->

    it "returns true on square matrix", ->
      (expect (M []).isSquare()).to.be.true
      (expect (M [1]).isSquare()).to.be.true
      (expect (M [ 1, 2, 3, 4 ]).isSquare()).to.be.true

    it "returns false on a not square matrix", ->
      (expect A.isSquare()).to.be.false


  describe "clone()", ->

    it "clones a matrix", ->
      B = A.clone()
      (expect B).not.to.equal A
      (expect B).to.deep.equal A

    it "clones to an existing matrix", ->
      B = A.clone A2
      (expect B).not.to.equal A
      (expect B).to.equal A2
      (expect B).to.deep.equal A

  describe "each()", ->

    it "iterates matrix entries", ->
      call = 0
      exp = [
        [1,0,0], [3,0,1], [5,0,2]
        [2,1,0], [4,1,1], [6,1,2]
      ]
      A.each (val, r, c) ->
        (expect val).to.equal exp[call][0]
        (expect r).to.equal exp[call][1]
        (expect c).to.equal exp[call][2]
        call += 1
      (expect call).to.equal 6

    it "is chainable", ->
      (expect A.each (->)).to.equal A

  describe "map()", ->

    it "maps to a new matrix", ->
      B = A.clone()
      C = B.map (x) -> x*x
      (expect C).not.to.equal B # not in place ?
      # adapted correctly ?
      (expect C).to.deep.equal A2

    it "maps a matrix in place", ->
      B = A.clone()
      C = B.map ((x) -> x*x), B
      (expect C).to.equal B # A returned ?
      (expect C).to.deep.equal A2 # B adapted correctly ?

    it "maps a matrix to a different matrix", ->
      B = A.clone()
      C = A.clone()
      D = B.map ((x) -> x*x), C
      (expect B).to.deep.equal A # B adapted correctly ?
      (expect D).to.equal C # A returned ?
      (expect D).to.deep.equal A2 # B adapted correctly ?

    it "maps two matrices to a new matrix", ->
      B = A.clone()
      B2 = A2.clone()
      C = B.map B2, (a, b) -> b - a
      (expect C).to.deep.equal A2_A
      (expect C).not.to.equal B
      (expect B).to.deep.equal A
      (expect B2).to.deep.equal A2

    it "maps two matrices to the first matrix in place", ->
      B = A.clone()
      B2 = A2.clone()
      C = B.map B2, ((a, b) -> b - a), B
      (expect C).to.deep.equal A2_A
      (expect C).to.equal B
      (expect B2).to.deep.equal A2


  describe "times()", ->

    it "multiplies a matrix", ->
      B = A.clone()
      C = B.times 3
      (expect C).not.to.equal B # not in place ?
      (expect B).to.deep.equal A # source not changed ?
      (expect C).to.deep.equal A3 # adapted correctly ?

    it "multiplies a matrix in place", ->
      B = A.clone()
      C = B.times 3, B
      (expect C).to.equal B # B returned ?
      (expect C).to.deep.equal A3 # B adapted correctly ?


  describe "fill()", ->

    it "fills a matrix", ->
      B = A.clone()
      C = B.fill 7
      (expect C).not.to.equal B # not in place ?
      (expect C).to.deep.equal M 2,[  # adapted correctly ?
        7, 7, 7
        7, 7, 7
      ]


  describe "add()", ->

    it "adds two matrices", ->
      B = A2_A.clone()
      B2 = A.clone()
      C = B.add(B2) # tested function
      (expect C).to.deep.equal A2 # expected result?
      (expect C).not.to.equal B # not in place?
      (expect C).not.to.equal B2
      (expect B).to.deep.equal A2_A # source unchanged ?
      (expect B2).to.deep.equal A

    it "adds two matrices to the second matrix", ->
      B = A2_A.clone()
      B2 = A.clone()
      C = B.add(B2, B2) # tested function
      (expect C).to.deep.equal A2 # expected result?
      (expect C).to.equal B2 # in place ?
      (expect C).not.to.equal B # not in place?
      (expect B).to.deep.equal A2_A # source unchanged ?


  describe "minus()", ->

    it "subtracts two matrices", ->
      B = A2.clone()
      B2 = A.clone()
      C = B.minus B2 # tested function
      (expect C).to.deep.equal A2_A # expected result?
      (expect C).not.to.equal B # not in place?
      (expect C).not.to.equal B2
      (expect B).to.deep.equal A2 # source unchanged ?
      (expect B2).to.deep.equal A


  describe "transp()", ->

    it "transposes a matrix", ->
      B = A.clone()
      C = B.transp() # tested function
      (expect C).to.deep.equal M 3,[ # expected result?
        1, 2
        3, 4
        5, 6
      ]
      (expect C).not.to.equal B # not in place?
      (expect B).to.deep.equal A # source unchanged ?

    it "transposes a matrix in place", ->
      C = A.transp A # tested function
      (expect C).to.deep.equal M 3,[ # expected result?
        1, 2
        3, 4
        5, 6
      ]
      (expect C).to.equal A # in place?
      (expect C.array).to.equal A.array


  describe "mult()", ->

    it "multiplies two matrices", ->
      A = M 2,[
        -4,  1,  6
        -2,  5, -3
      ]
      B = M 3,[
        -4, -1,  1, 6
         0,  4, -3, 2
         3, -2,  5, 7
      ]
      A2 = A.clone();
      B2 = B.clone();
      C = A2.mult B2 # tested function
      (expect C).to.deep.equal M 2,[ # expected result?
        34, -4,  23,  20
        -1, 28, -32, -23
      ]
      (expect A2).to.deep.equal A # source unchanged ?
      (expect B2).to.deep.equal B # source unchanged ?


  describe "toString() function", ->

    it "returns a matrix as string", ->
      (expect A.toString()).to.equal "1 3 5\n2 4 6"


  describe "I()", ->

    it "creates a new identity matrix", ->
      (expect M.I 3).to.deep.equal M [
        1, 0, 0
        0, 1, 0
        0, 0, 1
      ]
      (expect M.I 2, 3).to.deep.equal M 2,[
        1, 0, 0
        0, 1, 0
      ]


  describe "diag()", ->

    it "creates a new diagonal matrix from a column vector", ->
      (expect M.diag [2, 3, 4]).to.deep.equal M [
        2, 0, 0
        0, 3, 0
        0, 0, 4
      ]

    it "can use an existing buffer", ->
      T = (M.I 3).fill 5
      D = M.diag [2, 3, 4], T
      (expect D).to.deep.equal M [
        2, 0, 0
        0, 3, 0
        0, 0, 4
      ]
      (expect D).to.equal T
