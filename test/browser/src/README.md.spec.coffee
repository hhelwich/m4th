_ = if m4th? then m4th else require.call null, "../../src/index"

M = _.matrix

snippets = require "./README.md"

describe "README.md", ->

  beforeEach ->
    jasmine.addMatchers require './matcher'


  describe "snippet 4", ->

    it "logs the correct matrix dimension", ->
      log = null
      # run snippet
      snippets[4]
        A: M 4, 7
        console:
          log: (str) -> log = str
      # verify
      (expect log).toBe "Matrix A has 4 rows and 7 columns."


  describe "snippet 12", ->

    it "creates hilbert matrix of dimension 5", ->
      # run snippet
      {H} = snippets[12] M: M
      # verify
      (expect H).toApprox M [
        1, 1/2, 1/3, 1/4, 1/5
        1/2, 1/3, 1/4, 1/5, 1/6
        1/3, 1/4, 1/5, 1/6, 1/7
        1/4, 1/5, 1/6, 1/7, 1/8
        1/5, 1/6, 1/7, 1/8, 1/9
      ]


  describe "snippet 14", ->

    it "calculates the correct solution", ->
      # run snippet
      {A, y, x} = snippets[14]
        M: M
        m4th: _
      # verify
      (expect A.mult x).toApprox y, 0.00000000000001
