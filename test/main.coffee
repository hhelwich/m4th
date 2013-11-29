assert = require "assert"
_ = require "../src/main"

describe "main", ->

  it "knows the answer to the ultimate question of life and everything", ->

    assert.equal 42. _
