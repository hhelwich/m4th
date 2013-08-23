log = require '../util/log'

fail = log.fail
failUnmatchingDimensions = -> fail('unmatching dimensions')

id = (x) -> x

add = (a, b) -> a + b

minus = (a, b) -> a - b

floor = Math.floor

newEmpty = (width, height) -> new Matrix new Array(width * height), width

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

  fill: (s, T) ->
    @map (-> s), T

  zip: (f, B, T = newEmpty(@width, @height)) ->
    if not @isSameSize(B) or not @isSameSize(T)
      failUnmatchingDimensions()
    for el, n in @array
      T.array[n] = f(el, B.array[n]);
    T

  add: (B, T) ->
    @zip add, B, T

  minus: (B, T) ->
    @zip minus, B, T

  #TODO: transpose in place
  transp: (T = newEmpty(@height, @width)) ->
    if @height != T.width or @width != T.height
      failUnmatchingDimensions()
    for i in [0...@width] by 1
      for j in [0...@height] by 1
        T.array[j + i * @height] = @array[i + j * @width]
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
