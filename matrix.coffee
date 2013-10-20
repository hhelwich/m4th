# Imports / Shortcuts
# ---------------------------

# Import logger.
log = require "../util/log"

createConstructor = (require "../util/obj").createConstructor

# Create some shortcuts.
fail = log.fail
failUnmatchingDimensions = -> fail "invalid dimension"
floor = Math.floor


# Helper functions
# -----------------

# Identity function.
id = (x) -> x

# Function which adds two numbers.
add = (a, b) -> a + b

# Function which subtracts a number from another.
minus = (a, b) -> a - b

# Function to create a new empty matrix object of the given size.
newEmpty = (width, height) ->
  createMatrix (new Array width * height), width


# Matrix prototype
# ----------------

# A *Matrix* prototype
protoMatrix =

  get: (row, col) ->
    @array[row * @width + col]

  set: (row, col, val) ->
    @array[row * @width + col] = val
    @

  isSameSize: (B) ->
    @height == B.height and @width == B.width

  isSquare: ->
    @height == @width

  map: (f, T) ->
    @zip ((a) -> f(a)), @, T # function wrapped to hide following arguments

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

  mult: (B, T = newEmpty(B.width, @height)) ->
    if @width != B.height or T.height != @height or T.width != B.width
      failUnmatchingDimensions()
    T.fill(0, T) # initialize with zeros
    for i in [0...@height] by 1 # iterate rows of T
      for j in [0...B.width] by 1 # iterate colums of T
        for k in [0...@width] by 1 # iterate columns of A / rows of B
          T.array[i * T.width + j] += @get(i, k) * B.get(k, j)
    T

  toString: ->
    str = ""
    for el, n in @array
      if n % @width == 0
        if n > 0
          str += "\n"
      else
        str += " "
      str += el
    str



# Matrix constructor
# ------------------

# Construct a new matrix object.
#*  First Argument must be a one dimensional array of the size = width * height.
#*  Second Argument must be the width of the matrix. The height of the matrix is derived from the array size.
#    The param can be omitted if the matrix should be square.
createMatrix = createConstructor protoMatrix, (@array, @width = Math.sqrt array.length) ->
  @height = if array.length == 0 then 0 else array.length / @width
  if @height != floor(@height) or @width != floor(@width)
    fail "invalid array size"


createMatrix.I = (width, height = width) ->
  T = newEmpty width, height
  T.fill 0, T
  for i in [0...Math.min(width, height)] by 1
    T.set i, i, 1
  T

createMatrix.diag = (x, T = newEmpty(x.height, x.height)) ->
  if x.width != 1 or T.height != x.height or T.width != x.height
    failUnmatchingDimensions()
  T.fill 0, T
  for i in [0...x.height] by 1
    T.set i, i, x.get(i, 0)
  T



# Public API
# ----------

# Export Matrix constructor.
module.exports = createMatrix

