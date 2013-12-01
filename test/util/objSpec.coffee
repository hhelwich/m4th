expect = (require "chai").expect

_ = require "../../src/util/obj"

describe "Object utils", ->

  describe "createConstructor()", ->

    it "creates a new empty object with given prototype", ->
      proto = a: 123
      obj = do (_.createConstructor proto)
      (expect obj).not.to.equal proto
      (expect obj.a).to.equal 123
      proto.a = 456
      (expect obj.a).to.equal 456

    it "creates a new object with given prototype and constructor", ->
      proto = a: 123
      construct = (@b) ->
      obj = (_.createConstructor proto, construct) 456
      (expect obj.a).to.equal 123
      (expect obj.b).to.equal 456

    it "adds optional stuff to constructor", ->
      stuff =
        a: ->
        b: 3
      constr = _.createConstructor {}, (->), stuff
      for foo of stuff
        (expect constr[foo]).to.equal stuff[foo]

    it "uses constructor return value if truthy", ->
      foo = { bla: 42 }
      constr = _.createConstructor {}, -> foo
      obj = constr()
      (expect obj).to.equal foo

    it "can be called with no protoype", ->
      f = (a, b) -> a + b
      foo = { bla: 42 }
      constr = _.createConstructor null, f, foo
      # constr should be a clone of f
      (expect constr).not.to.equal f
      (expect constr).not.to.equal foo
      (expect constr 2, 3).to.equal 5
      # should been extended with foo
      (expect constr.bla).to.equal 42
      (expect f.bla).to.be.undefined
