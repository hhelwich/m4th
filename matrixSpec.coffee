m = require 'math/matrix'

describe 'Matrix module', ->

  describe 'map() function', ->

    it 'should be able to map a matrix in place', ->
      A = [[1, 2], [3, 4], [5, 6]]
      B = m.map ((x) -> x*x), A
      expect(B).toBe A # in place ?
      expect(B).toEqual [[1, 4], [9, 16], [25, 36]] # adapted correctly ?

    it 'should be able to map to another matrix', ->
      A = [[1, 2], [3, 4], [5, 6]]
      B = [[], [], []]
      C = m.map ((x) -> x-1), A, B
      expect(C).toBe B # B returned ?
      expect(A).toEqual [[1, 2], [3, 4], [5, 6]] # A not changed ?
      expect(B).toEqual [[0, 1], [2, 3], [4, 5]] # B adapted correctly ?


  describe 'times() function', ->

    it 'should be able to multiply a matrix in place', ->
      A = [[1, 2]]
      B = m.times(3, A)
      expect(B).toBe A # in place ?
      expect(B).toEqual [[3, 6]] # adapted correctly ?

    it 'should be able to multiply to another matrix', ->
      A = [[1, 2]]
      B = [[]]
      C = m.times(3, A, B)
      expect(C).toBe B # B returned ?
      expect(A).toEqual [[1, 2]] # A not changed ?
      expect(B).toEqual [[3, 6]] # B adapted correctly ?


  describe 'height() function', ->

    it 'should give correct height for an empty matrix', ->
      expect(m.height([])).toEqual 0

    it 'should fail for empty 2 dim matrix', ->
      expect(-> m.height([[]])).toThrow()

    it 'should give correct height for a rectangular matrix', ->
      expect(m.height([[1, 2], [3, 4], [5, 6]])).toEqual 2


  describe 'width() function', ->

    it 'should give correct width for an empty matrix', ->
      expect(m.width([])).toEqual 0

    it 'should fail for empty 2 dim matrix', ->
      expect(-> m.width([[]])).toThrow()

    it 'should give correct width for a rectangular matrix', ->
      expect(m.width([[1, 2], [3, 4], [5, 6]])).toEqual 3
