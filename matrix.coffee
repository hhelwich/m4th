log = require '../util/log'

fail = log.fail

map = (f, A, Buf = A) ->
  for col, j in A
    for el, i in col
      Buf[j][i] = f(el)
  Buf

times = (s, A, Buf) ->
  map(((x) -> s*x), A, Buf)

isEmpty = (A) ->
  if A.length == 0
    true
  else if A[0].length == 0
    fail 'invalid matrix'
  else
    false

height = (A) ->  # assume A is rectangular
  if (isEmpty A)
    0
  else
    A[0].length

width = (A) -> # assume A is rectangular
  if (isEmpty A)
    0
  else
    A.length

id = (x) -> x

class Matrix
  constructor: (@array, @width = Math.sqrt array.length) ->
    @height = if array.length == 0 then 0 else array.length / @width
    if @height != Math.floor(@height) or @width != Math.floor(@width)
      fail 'invalid array size'


  map: (f, T) ->
    if not T?
      T = new Matrix new Array(@array.length), @width
    for el, n in @array
      T.array[n] = f(el);
    T

  clone: (T) -> @map id, T

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



module.exports.times = times
module.exports.width = width
module.exports.height = height