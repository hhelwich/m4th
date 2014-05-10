_ = if m4th? then m4th else require.call null, "../../src/index"

M = _.matrix

snippets = require "./README.md"

describe "README.md", ->

  beforeEach ->
    jasmine.addMatchers require './matcher'

  describe "snippet 12", ->

    it "creates hilbert matrix of dimension 5", ->

      {H} = snippets[12]
        M: M
      (expect H).toApprox M [
            1, 1/2, 1/3, 1/4, 1/5
          1/2, 1/3, 1/4, 1/5, 1/6
          1/3, 1/4, 1/5, 1/6, 1/7
          1/4, 1/5, 1/6, 1/7, 1/8
          1/5, 1/6, 1/7, 1/8, 1/9
      ]
