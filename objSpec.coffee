_ = require 'util/obj'

describe 'Object utils', ->

  describe 'createConstructor()', ->

    it 'creates a new object as expected', ->
      proto = a: 123
      construct = (@b) ->
      obj = (_.createConstructor proto, construct) 456
      (expect obj.a).toBe 123
      (expect obj.b).toBe 456

