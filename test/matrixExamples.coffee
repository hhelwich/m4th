chai = require "chai"
expect = chai.expect

chai.use require "./approxAssertion"


M = require "../src/matrix"

describe "Matrix examples", ->


  describe "trace", ->

    A = null

    beforeEach ->
      A = M 3, [
        3, 5, 7, 8
        2, 6, 4, 9
        0, 2, 8, 3
      ]

    it "can be calculated with for loop", ->
      trace = 0
      for ij in [0...Math.min A.rows, A.columns] by 1
        trace += A.get ij, ij
      # validate
      (expect trace).to.equal 17

    it "can be calculated with eachDiagonal()", ->
      trace = 0
      A.eachDiagonal (val) ->
        trace += val
        return
      # validate
      (expect trace).to.equal 17

    it "can be calculated with reduceDiagonal()", ->
      add = (x, y) -> x + y
      trace = A.reduceDiagonal add
      # validate
      (expect trace).to.equal 17


  describe "norms", ->

    A = null

    beforeEach ->
      A = M [
        3, 5, 7
        2, 6, 4
        0, 2, 8
      ]

    describe "1 norm", ->

      it "can be calculated nicely", ->
        colSum = []
        A.each (val, i, j) ->
          if i == 0
            colSum[j] = 0
          colSum[j] += Math.abs val
          return
        norm = Math.max.apply null, colSum
        # validate
        (expect norm).to.equal 19

    #describe "2 norm", ->

      #it "can be calculated nicely", ->
        # validate
        #(expect norm).to.equal 13.686

    describe "infinity norm", ->

      it "can be calculated nicely", ->
        rowSum = []
        A.each (val, i, j) ->
          if j == 0
            rowSum[i] = 0
          rowSum[i] += Math.abs val
          return
        norm = Math.max.apply null, rowSum
        # validate
        (expect norm).to.equal 15

      it "can be calculated nicely with reduceRows()", ->
        addAbs = (x, y) ->
          x + Math.abs y
        norm = Math.max.apply null, A.reduceRows addAbs, 0
        # validate
        (expect norm).to.equal 15

    describe "frobenius norm", ->

      it "can be calculated in an iterative style", ->
        norm = 0
        for i in [0...A.rows] by 1
          for j in [0...A.columns] by 1
            a = A.get i, j
            norm += a * a
        norm = Math.sqrt norm
        # validate
        (expect norm).to.equal Math.sqrt 207 # ca 14.387

      it "can be calculated with each()", ->
        norm = 0
        A.each (a) ->
          norm += a * a
          return
        norm = Math.sqrt norm
        # validate
        (expect norm).to.equal Math.sqrt 207 # ca 14.387

      it "can be calculated nicely", ->
        # helpers
        square = (x) -> x * x
        add = (x, y) -> x + y
        # do it
        norm = Math.sqrt (A.map square).reduce add
        # validate
        (expect norm).to.equal Math.sqrt 207 # ca 14.387

      it "can be calculated nicely with single reduce", ->
        # helpers
        addSquared = (x, y) -> x + y * y
        # do it
        norm = Math.sqrt A.reduce addSquared, 0
        # validate
        (expect norm).to.equal Math.sqrt 207 # ca 14.387


  describe "special matrices", ->

    describe "hilbert matrix", ->

      it "can be calculated nicely", ->
        n = 4 # any order
        H = (M n).map (val, i, j) ->
          1 / (i + j + 1) # indices start at 0
        # validate
        (expect H).to.deep.equal M [
          1/1, 1/2, 1/3, 1/4
          1/2, 1/3, 1/4, 1/5
          1/3, 1/4, 1/5, 1/6
          1/4, 1/5, 1/6, 1/7
        ]


    describe "wilkinson matrix", ->

      it "can be calculated nicely", ->
        n = 5 # any order
        W = (M n).map (val, i, j) ->
          if i == j
            Math.abs i + (1 - @rows) / 2
          else if (Math.abs i-j) == 1 # put ones below diagonal
            1
          else
            0
        # validate
        (expect W).to.deep.equal M [
          2, 1, 0, 0, 0
          1, 1, 1, 0, 0
          0, 1, 0, 1, 0
          0, 0, 1, 1, 1
          0, 0, 0, 1, 2
        ]

    describe "random matrix", ->

      it "can be calculated nicely", ->
        n = 5 # any order
        R = (M n).map (val, i, j) ->
          Math.random()
        # validate
        entries = 0
        R.each (r, i, j) ->
          (expect r).to.be.within 0, 1
          entries += 1
        (expect entries).to.equal 25


  describe "special operations", ->

    describe "cross product", ->

      it "can be calculated nicely", ->
        x = M 3, [ 1, 2, 3 ]
        y = M 3, [ -1, 0, 1 ]
        # calculate cross product
        z = x.map (_x, i) ->
          i0 = (i + 1) % 3
          i1 = (i + 2) % 3
          (x.get i0) * (y.get i1) - (x.get i1) * (y.get i0)

        # validate
        (expect z).to.deep.equal M 3, [ 2, -4, 2]



    describe "kronecker product", ->

      it "can be calculated nicely", ->
        A = M 3,[
          1, 2
          3, 4
          5, 6
        ]
        B = M [
          7, 8
          9, 0
        ]
        # calculate kronecker product
        C = (M A.rows * B.rows, A.columns * B.columns).map (val, i, j) ->
          (A.get (Math.floor i / B.rows), (Math.floor j / B.columns)) * (B.get (i % B.rows), (j % B.columns))

        # validate
        (expect C).to.deep.equal M 6,[
           7,  8, 14, 16
           9,  0, 18,  0
          21, 24, 28, 32
          27,  0, 36,  0
          35, 40, 42, 48
          45,  0, 54,  0
        ]



