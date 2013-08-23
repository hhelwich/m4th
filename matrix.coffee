log = require '../util/log'

fail = log.fail

id = (x) -> x

floor = Math.floor

class Matrix
  constructor: (@array, @width = Math.sqrt array.length) ->
    @height = if array.length == 0 then 0 else array.length / @width
    if @height != floor(@height) or @width != floor(@width)
      fail 'invalid array size'


  isSameSize: (B) ->
    @height == B.height and @width == B.width

  isSquare: ->
    @height == @width

  map: (f, T) ->
    @zip ((a, b) -> f(a)), @, T

  clone: (T) ->
    @map id, T

  times: (s, T) ->
    @map ((x) -> s*x), T

  zip: (f, B, T = new Matrix new Array(@array.length), @width) ->
    if not @isSameSize(B) or not @isSameSize(T)
      fail('unmatching dimensions')
    for el, n in @array
      T.array[n] = f(el, B.array[n]);
    T

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
