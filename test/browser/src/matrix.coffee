_ = if m4th? then m4th else require.call null, "../../src/index"

M = _.matrix

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

    it "creates empty matrix by array", ->
      B = M []
      expect(B.array).toEqual []
      expect(B.rows).toBe 0
      expect(B.columns).toBe 0
      expect(B.get 0, 0).not.toBeDefined()

    it "creates empty matrix by rows", ->
      B = M 0
      expect(B.array).toEqual []
      expect(B.rows).toBe 0
      expect(B.columns).toBe 0
      expect(B.get 0, 0).not.toBeDefined()

    it "creates square matrices by array", ->
      B = M [
        1, 2, 3
        4, 5, 6
        7, 8, 9
      ]
      expect(B.rows).toBe 3
      expect(B.columns).toBe 3
      expect(B.get 1, 2).toBe 6

    it "first rounds up rows and then columns if needed (1)", ->
      B = M [
        1, 2
        3, 4
        5, 6
      ]
      expect(B.rows).toBe 3
      expect(B.columns).toBe 2
      expect(B.get 1, 1).toBe 4
      expect(B.get 2, 2).not.toBeDefined()

    it "first rounds up rows and then columns if needed (2)", ->
      B = M [
        1, 2, 3
        4, 5, 6
        7
      ]
      expect(B.rows).toBe 3
      expect(B.columns).toBe 3
      expect(B.get 1, 1).toBe 5
      expect(B.get 2, 0).toBe 7
      expect(B.get 2, 1).not.toBeDefined()

    it "creates rectangular matrices", ->
      B = M 2,[
        1, 2, 3
        4, 5, 6
      ]
      expect(B.rows).toBe 2
      expect(B.columns).toBe 3
      expect(B.get 1, 2).toBe 6

    it "creates rectangular matrices and round up columns if not set", ->
      B = M 2,[
        1, 2, 3, 4
        5, 6, 7
      ]
      expect(B.rows).toBe 2
      expect(B.columns).toBe 4
      expect(B.get 1, 2).toBe 7
      expect(B.get 1, 3).not.toBeDefined()

    it "creates matrix with size and array", ->
      B = M 2, 3,[
        1, 2, 3
        4, 5, 6
      ]
      expect(B.rows).toBe 2
      expect(B.columns).toBe 3
      expect(B.get 1, 2).toBe 6

    it "creates matrix with size and array and ignores extra array elements", ->
      B = M 2, 3,[
        1, 2, 3
        4, 5, 6
        7, 8, 9
      ]
      expect(B.rows).toBe 2
      expect(B.columns).toBe 3
      expect(B.get 1, 2).toBe 6

    it "creates matrix with size and array and ignores missing array elements", ->
      B = M 2, 3,[
        1, 2, 3
        4, 5
      ]
      expect(B.rows).toBe 2
      expect(B.columns).toBe 3
      expect(B.get 1, 1).toBe 5
      expect(B.get 1, 2).not.toBeDefined()

    it "creates empty square matrices", ->
      B = M 3
      (expect B.rows).toBe 3
      (expect B.columns).toBe 3
      (expect B.get 1, 2).not.toBeDefined()

    it "creates empty rectangular matrices", ->
      B = M 2, 3
      (expect B.rows).toBe 2
      (expect B.columns).toBe 3
      (expect B.get 1, 2).not.toBeDefined()


  describe "get()", ->

    it "gets a matrix entry", ->
      (expect A.get 0, 0).toBe 1
      (expect A.get 0, 1).toBe 3
      (expect A.get 1, 0).toBe 2
      (expect A.get 1, 2).toBe 6

    it "gets a column vector entry without column index", ->
      v = M 3, [2, 3, 4]
      (expect v.get 0).toBe 2
      (expect v.get 1).toBe 3
      (expect v.get 2).toBe 4


  describe "set()", ->

    it "sets a matrix entry", ->
      (expect A.get 0, 0).toBe 1
      (expect (A.set 0, 0, 3).get 0, 0).toBe 3
      (expect A.get 1, 2).toBe 6
      (expect (A.set 1, 2, 7).get 1, 2).toBe 7


  describe "isSize()", ->

    it "returns true on a same sized matrix", ->
      (expect A.isSize A).toBe true
      (expect A.isSize A2).toBe true

    it "returns false on a different sized matrix", ->
      (expect A.isSize M []).toBe false
      (expect A.isSize M 3, [ 1, 2, 3 ]).toBe false

    it "returns false on a different sized matrix", ->
      (expect A.isSize M []).toBe false
      (expect A.isSize M 1, [ 1, 2, 3 ]).toBe false


  describe "isSquare()", ->

    it "returns true on square matrix", ->
      (expect (M []).isSquare()).toBe true
      (expect (M [1]).isSquare()).toBe true
      (expect (M [ 1, 2, 3, 4 ]).isSquare()).toBe true

    it "returns false on a not square matrix", ->
      (expect A.isSquare()).toBe false


  describe "clone()", ->

    it "clones a matrix", ->
      B = A.clone()
      (expect B).not.toBe A
      (expect B).toEqual A

    it "clones to an existing matrix", ->
      B = A.clone A2
      (expect B).not.toBe A
      (expect B).toBe A2
      (expect B).toEqual A

  describe "each()", ->

    it "iterates matrix entries", ->
      call = 0
      exp = [
        [1,0,0], [3,0,1], [5,0,2]
        [2,1,0], [4,1,1], [6,1,2]
      ]
      A.each (val, r, c) ->
        (expect val).toBe exp[call][0]
        (expect r).toBe exp[call][1]
        (expect c).toBe exp[call][2]
        call += 1
      (expect call).toBe exp.length

    it "is chainable", ->
      (expect A.each (->)).toBe A

    it "binds 'this' to matrix", ->
      A.each ->
        (expect @).toBe A

  describe "eachDiagonal()", ->

    it "iterates matrix diagonal entries", ->
      call = 0
      exp = [[1,0,0], [4,1,1]]
      A.eachDiagonal (val, i, j) ->
        (expect val).toBe exp[call][0]
        (expect i).toBe exp[call][1]
        (expect j).toBe exp[call][2]
        call += 1
      (expect call).toBe exp.length

    it "is chainable", ->
      (expect A.eachDiagonal (->)).toBe A

    it "binds 'this' to matrix", ->
      A.eachDiagonal ->
        (expect @).toBe A


  describe "reduce()", ->

    it "reduces a matrix", ->
      B = A.clone()
      s = B.reduce (x, y) -> x + y
      (expect B).toEqual A # matrix unchanged?
      # correct result?
      (expect s).toEqual 21

    it "reduces a matrix with initial value", ->
      B = A.clone()
      s = B.reduce ((x, y) -> x + y), 11
      (expect B).toEqual A # matrix unchanged?
      # correct result?
      (expect s).toEqual 32

    it "binds 'this' to matrix", ->
      A.reduce ->
        (expect @).toBe A

  describe "reduceDiagonal()", ->

    it "reduces the diagonal of a matrix", ->
      B = A.clone()
      s = B.reduceDiagonal (x, y) -> x + y
      (expect B).toEqual A # matrix unchanged?
      # correct result?
      (expect s).toEqual 5

    it "reduces the diagonal of a matrix with initial value", ->
      B = A.clone()
      s = B.reduceDiagonal ((x, y) -> x + y), 11
      (expect B).toEqual A # matrix unchanged?
      # correct result?
      (expect s).toEqual 16

    it "binds 'this' to matrix", ->
      A.reduceDiagonal ->
        (expect @).toBe A


  describe "reduceRows()", ->

    it "reduces all rows of a matrix", ->
      B = A.clone()
      array = B.reduceRows (x, y) -> x + y
      (expect B).toEqual A # matrix unchanged?
      # correct result?
      (expect array).toEqual [9, 12]

    it "reduces all rows of a matrix with initial value", ->
      B = A.clone()
      array = B.reduceRows ((x, y) -> x + y), 2
      (expect B).toEqual A # matrix unchanged?
      # correct result?
      (expect array).toEqual [11, 14]

    it "binds 'this' to matrix", ->
      A.reduceRows ->
        (expect @).toBe A


  describe "map()", ->

    it "maps to a new matrix", ->
      B = A.clone()
      C = B.map (x) -> x*x
      (expect C).not.toBe B # not in place ?
      # adapted correctly ?
      (expect C).toEqual A2

    it "maps a matrix in place", ->
      B = A.clone()
      C = B.map ((x) -> x*x), B
      (expect C).toBe B # A returned ?
      (expect C).toEqual A2 # B adapted correctly ?

    it "maps a matrix to a different matrix", ->
      B = A.clone()
      C = A.clone()
      D = B.map ((x) -> x*x), C
      (expect B).toEqual A # B adapted correctly ?
      (expect D).toBe C # A returned ?
      (expect D).toEqual A2 # B adapted correctly ?

    it "maps two matrices to a new matrix", ->
      B = A.clone()
      B2 = A2.clone()
      C = B.map B2, (a, b) -> b - a
      (expect C).toEqual A2_A
      (expect C).not.toBe B
      (expect B).toEqual A
      (expect B2).toEqual A2

    it "maps two matrices to the first matrix in place", ->
      B = A.clone()
      B2 = A2.clone()
      C = B.map B2, ((a, b) -> b - a), B
      (expect C).toEqual A2_A
      (expect C).toBe B
      (expect B2).toEqual A2


  describe "times()", ->

    it "multiplies a matrix", ->
      B = A.clone()
      C = B.times 3
      (expect C).not.toBe B # not in place ?
      (expect B).toEqual A # source not changed ?
      (expect C).toEqual A3 # adapted correctly ?

    it "multiplies a matrix in place", ->
      B = A.clone()
      C = B.times 3, B
      (expect C).toBe B # B returned ?
      (expect C).toEqual A3 # B adapted correctly ?


  describe "fill()", ->

    it "fills a matrix", ->
      B = A.clone()
      C = B.fill 7
      (expect C).not.toBe B # not in place ?
      (expect C).toEqual M 2,[  # adapted correctly ?
        7, 7, 7
        7, 7, 7
      ]


  describe "add()", ->

    it "adds two matrices", ->
      B = A2_A.clone()
      B2 = A.clone()
      C = B.add(B2) # tested function
      (expect C).toEqual A2 # expected result?
      (expect C).not.toBe B # not in place?
      (expect C).not.toBe B2
      (expect B).toEqual A2_A # source unchanged ?
      (expect B2).toEqual A

    it "adds two matrices to the second matrix", ->
      B = A2_A.clone()
      B2 = A.clone()
      C = B.add(B2, B2) # tested function
      (expect C).toEqual A2 # expected result?
      (expect C).toBe B2 # in place ?
      (expect C).not.toBe B # not in place?
      (expect B).toEqual A2_A # source unchanged ?


  describe "minus()", ->

    it "subtracts two matrices", ->
      B = A2.clone()
      B2 = A.clone()
      C = B.minus B2 # tested function
      (expect C).toEqual A2_A # expected result?
      (expect C).not.toBe B # not in place?
      (expect C).not.toBe B2
      (expect B).toEqual A2 # source unchanged ?
      (expect B2).toEqual A


  describe "transp()", ->

    it "transposes a matrix", ->
      B = A.clone()
      C = B.transp() # tested function
      (expect C).toEqual M 3,[ # expected result?
        1, 2
        3, 4
        5, 6
      ]
      (expect C).not.toBe B # not in place?
      (expect B).toEqual A # source unchanged ?

    it "transposes a matrix in place", ->
      C = A.transp A # tested function
      (expect C).toEqual M 3,[ # expected result?
        1, 2
        3, 4
        5, 6
      ]
      (expect C).toBe A # in place?
      (expect C.array).toBe A.array


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
      (expect C).toEqual M 2,[ # expected result?
        34, -4,  23,  20
        -1, 28, -32, -23
      ]
      (expect A2).toEqual A # source unchanged ?
      (expect B2).toEqual B # source unchanged ?


  describe "toString() function", ->

    it "returns a matrix as string", ->
      (expect A.toString()).toBe "1 3 5\n2 4 6"


  describe "I()", ->

    it "creates a new identity matrix", ->
      (expect M.I 3).toEqual M [
        1, 0, 0
        0, 1, 0
        0, 0, 1
      ]
      (expect M.I 2, 3).toEqual M 2,[
        1, 0, 0
        0, 1, 0
      ]


  describe "diag()", ->

    it "creates a new diagonal matrix from a column vector", ->
      (expect M.diag [2, 3, 4]).toEqual M [
        2, 0, 0
        0, 3, 0
        0, 0, 4
      ]

    it "can use an existing buffer", ->
      T = (M.I 3).fill 5
      D = M.diag [2, 3, 4], T
      (expect D).toEqual M [
        2, 0, 0
        0, 3, 0
        0, 0, 4
      ]
      (expect D).toBe T
