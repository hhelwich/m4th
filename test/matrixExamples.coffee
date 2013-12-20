chai = require "chai"
expect = chai.expect

chai.use require "./approxAssertion"


M = require "../src/matrix"

describe "Matrix examples", ->

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


    describe "frobenius norm", ->

      it "can be calculated nicely", ->
        norm = 0
        A.each (val) -> #### iterate all matrix entries ###
          norm += val * val
          return
        norm = Math.sqrt norm
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



