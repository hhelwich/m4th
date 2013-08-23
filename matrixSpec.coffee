M = require 'math/matrix'

describe 'Matrix module', ->

  A = null
  A2 = null
  A3 = null

  beforeEach ->

    A  = M [ 1,  3,  5
             2,  4,  6 ], 3
    A2 = M [ 1,  9, 25
             4, 16, 36 ], 3
    A3 = M [ 3,  9, 15
             6, 12, 18 ], 3

  describe 'Matrix constructor', ->

    it 'should be able to create a new empty matrix', ->

      B = M []
      expect(B.array).toEqual []
      expect(B.height).toBe 0
      expect(B.width).toBe 0

    it 'should be able to create a new square matrix without width param', ->

      B = M [ 1, 2, 3
              4, 5, 6
              7, 8, 9 ]
      expect(B.height).toBe 3
      expect(B.width).toBe 3

    it 'should be able to create a new rectangular matrix', ->

      B = M [ 1, 2, 3
              4, 5, 6 ], 3
      expect(B.height).toBe 2
      expect(B.width).toBe 3

  describe 'clone() function', ->

    it 'should be able to clone a matrix', ->

      B = A.clone()
      expect(B).not.toBe A
      expect(B).toEqual A

    it 'should be able to clone to an existing matrix', ->

      B = A.clone(A2)
      expect(B).not.toBe A
      expect(B).toBe A2
      expect(B).toEqual A

  describe 'map() function', ->

    it 'should be able to map to a new matrix', ->

      B = A.clone()
      C = B.map((x) -> x*x)
      expect(C).not.toBe B # in place ?
      # adapted correctly ?
      expect(C).toEqual A2

    it 'should be able to map a matrix in place', ->
      B = A.clone()
      C = B.map ((x) -> x*x), B
      expect(C).toBe B # A returned ?
      expect(C).toEqual A2 # B adapted correctly ?

    it 'should be able to map a matrix to a different matrix', ->
      B = A.clone()
      C = A.clone()
      D = B.map ((x) -> x*x), C
      expect(B).toEqual A # B adapted correctly ?
      expect(D).toBe C # A returned ?
      expect(D).toEqual A2 # B adapted correctly ?


  describe 'times() function', ->

    it 'should multiply a matrix (and create a new instance)', ->
      B = A.clone()
      C = B.times(3)
      expect(C).not.toBe B # not in place ?
      expect(B).toEqual A # source not changed ?
      expect(C).toEqual A3 # adapted correctly ?

    it 'should be able to multiply a matrix in place', ->
      B = A.clone()
      C = B.times(3, B)
      expect(C).toBe B # B returned ?
      expect(C).toEqual A3 # B adapted correctly ?


  describe 'toString() function', ->

    it 'should return the matrix as string', ->
      expect(A.toString()).toBe '1 3 5\n2 4 6'
