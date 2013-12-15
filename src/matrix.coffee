# Matrix implementation.

# Imports / Shortcuts
# -------------------

# Import logger.
{fail} = require "ut1l/log"

{creator} = require "ut1l/obj"

# Create some shortcuts.
failUnmatchingDimensions = -> fail "invalid dimension"
floor = Math.floor


# Helpers
# -------

# Identity function.
id = (x) -> x

# Function which adds two numbers.
add = (a, b) -> a + b

# Function which subtracts a number from another.
minus = (a, b) -> a - b

# Matrix constructor
# ------------------

# Construct a new empty matrix of the given size. Creates a square matrix if only first parameter is given.
# Matrix elements will have an `undefined` value.
matrixConstructorEmpty = (@width, @height = width) ->
  @array = new Array width * @height
  return

# Construct a new matrix with the given one dimensional content array (not copied) of the size = width * height.
# Second optional parameter must be the width of the matrix. The height of the matrix is derived from the array size.
# If this param is omitted, the matrix is initialized as square matrix.
matrixConstructorContent = (@array, @width = Math.sqrt array.length) ->
  @height = if array.length == 0 then 0 else array.length / @width
  if @height != (floor @height) or @width != (floor @width)
    fail "invalid array size"
  return

# Forward to above constructors.
matrixConstructor = (arrayOrWidth) ->
  (if typeof arrayOrWidth == "number" then matrixConstructorEmpty else matrixConstructorContent).apply @, arguments


# Matrix statics
# --------------

matrixStatic =

  # Create an identity matrix of the given size.
  I: (width, height = width) ->
    T = createMatrix width, height
    T.fill 0, T
    for i in [0...Math.min width, height] by 1
      T.set i, i, 1
    T

  # Returns a diagonal matrix with the elements of the given column vector `x` on the diagonal.
  # An optional matrix `T` can be specified to store the result into instead of creating a new matrix.
  # Throws an error if `x` is not a column vector or if `T` is given and it is not a square matrix with the expected size
  diag: (x, T = createMatrix x.height, x.height) ->
    if x.width != 1 or T.height != x.height or T.width != x.height
      failUnmatchingDimensions()
    T.fill 0, T
    for i in [0...x.height] by 1
      T.set i, i, x.get i, 0
    T


# Matrix prototype
# ----------------

# The *Matrix* prototype.
matrixProto =

  # Returns the matrix element with the given *row* and *column*.
  get: (row, col) ->
    @array[row * @width + col]

  # Sets the matrix element with the given *row* and *column* to the given *value*.
  # Returns the matrix to enable chaining.
  set: (row, col, val) ->
    @array[row * @width + col] = val
    @

  # Returns `true` if the matrix has the same *width* and *height* as the given matrix `B`.
  # Returns `false` otherwise.
  isSameSize: (B) ->
    @height == B.height and @width == B.width

  # Returns `true` if *width* and *height* of the matrix are equal. Returns `false` otherwise.
  isSquare: ->
    @height == @width

  # Apply function `f(a,b,c...)` to all elements of a list of matrices with the same size and return the resulting
  # matrix.
  # An optional matrix `T` can be specified to store the result into instead of creating a new matrix.
  # Throws an error if not all given matrices are of the same size.
  map: ->
    args = arguments
    n = args.length - 1
    if args[n] == undefined # ignore last argument if undefined
      n -= 1
    if typeof args[n] != "function" # => last argument must be a buffer
      T = args[n--]
      if not @isSameSize T
        failUnmatchingDimensions()
    else # no buffer matrix argument
      T = createMatrix @width, @height
    func = args[n] # mapping function
    l = T.height * T.width
    elements = [] # mapping function input parameters
    for i in [0...l] by 1                    # iterate matrix elements
      elements[0] = @array[i]                # set first input param
      for k in [0...n] by 1                  # set more input params if available
        elements[k+1] = args[k].array[i]
      T.array[i] = func.apply null, elements # calculate matrix element from input params
    T

  # Return a copy of the matrix.
  # An optional matrix `T` can be specified to store the result into instead of creating a new matrix.
  # Throws an error if `T` is given and it does not has the same size as the matrix.
  clone: (T) ->
    @map id, T

  # Return a matrix of the same size with alle elements set to `s`.
  # An optional matrix `T` can be specified to store the result into instead of creating a new matrix.
  # Throws an error if `T` is given and it does not has the same size as the matrix.
  fill: (s, T) ->
    @map (-> s), T

  # Multiply all elements of the matrix with a scalar.
  # An optional matrix `T` can be specified to store the result into.
  # Throws an error if `T` is given and has not the same size as the matrix.
  times: (s, T) ->
    @map ((x) -> s*x), T

  # Add the matrix and matrix `B` and return the result.
  # An optional matrix `T` can be specified to store the result into instead of creating a new matrix.
  # Throws an error if the matrix is not the same size as `B` (and `T`).
  add: (B, T) ->
    @map B, add, T

  # Subtract matrix `B` from the matrix and return the result.
  # An optional matrix `T` can be specified to store the result into instead of creating a new matrix.
  # Throws an error if the matrix is not the same size as `B` (and `T`).
  minus: (B, T) ->
    @map B, minus, T

  # Returns the transposed matrix.
  # An optional matrix `T` can be specified to store the result into instead of creating a new matrix.
  # Throws an error if `T` is given and different to the matrix and the *height* of `T` is not equal to the *width*
  # of the matrix or the *width* of `T` is not equal to the *height* of the matrix.
  transp: (T = createMatrix @height, @width) ->
    if T == @ # transpose in place
      B = @clone() # TODO: manage in place transpose without creating new buffer array
      [@height, @width] = [@width, @height] # switch dimension
      B.transp @
    else # transpose to new buffer
      if @height != T.width or @width != T.height
        failUnmatchingDimensions()
      for i in [0...@width] by 1
        for j in [0...@height] by 1
          T.set i, j, @get j, i
      T

  # Returns the matrix multiplication of the matrix with matrix `B`.
  # An optional matrix `T` can be specified to store the result into instead of creating a new matrix.
  # Throws an error if the matrix width is different to the height of `B` or if `T` is given and its height is different
  # to the matrix height or its width is different to the with of `B`.
  mult: (B, T = createMatrix B.width, @height) ->
    if @width != B.height or T.height != @height or T.width != B.width
      failUnmatchingDimensions()
    T.fill 0, T # initialize with zeros
    for i in [0...@height] by 1 # iterate rows of T
      for j in [0...B.width] by 1 # iterate colums of T
        for k in [0...@width] by 1 # iterate columns of A / rows of B
          T.array[i * T.width + j] += (@get i, k) * (B.get k, j)
    T

  # Returns a human readable string serialization of the matrix.
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


# Public API
# ----------

# Export Matrix constructor.
module.exports = createMatrix = creator matrixProto, matrixConstructor, matrixStatic


