log = require '../util/log'

fail = log.fail

id = (x) -> x

floor = Math.floor

class Matrix
  constructor: (@array, @width = Math.sqrt array.length) ->
    @height = if array.length == 0 then 0 else array.length / @width
    if @height != floor(@height) or @width != floor(@width)
      fail 'invalid array size'


  map: (f, T) ->
    if not T?
      T = new Matrix new Array(@array.length), @width
    for el, n in @array
      T.array[n] = f(el);
    T

  clone: (T) ->
    @map id, T

  times: (s, T) ->
    @map ((x) -> s*x), T

  toString: ->
    str = ''
    for el, n in @array
      if n % @width == 0
        if n > 0
          str += '\n'
      else
        str += ' '
      str += el
    str

# public api
module.exports = (array, width) ->
  new Matrix array, width
