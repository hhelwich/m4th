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

concatEntries = (x, y) ->
  x + " " + y

concatRows = (x, y) ->
  x + "\n" + y

# Matrix constructor
# ------------------

# Construct a new empty matrix of the given size. Creates a square matrix if only first parameter is given.
# Matrix elements will have an `undefined` value.
matrixConstructorEmpty = (@rows, @columns = rows) ->
  @array = []
  return

# Construct a new matrix with the given one dimensional content array (not copied) of the size = width * height.
# Second optional parameter must be the width of the matrix. The height of the matrix is derived from the array size.
# If this param is omitted, the matrix is initialized as square matrix.
matrixConstructorContent = (@rows, @array) ->
  @columns = if array.length == 0 then 0 else array.length / @rows
  if @rows != (floor @rows) or @columns != (floor @columns)
    fail "invalid array size"
  return

# Forward to above constructors.
matrixConstructor = (arrayOrRows, arrayOrColumns) ->
  if typeof arrayOrRows == "number"
    if not arrayOrColumns? or typeof arrayOrColumns == "number"
      matrixConstructorEmpty.call @, arrayOrRows, arrayOrColumns
    else
      matrixConstructorContent.call @, arrayOrRows, arrayOrColumns
  else
    matrixConstructorContent.call @, (floor Math.sqrt arrayOrRows.length), arrayOrRows


# Matrix statics
# --------------

matrixStatic =

  # Create an identity matrix of the given size.
  I: (rows, columns = rows) ->
    T = createMatrix rows, columns
    T.fill 0, T
    for i in [0...Math.min rows, columns] by 1
      T.set i, i, 1
    T

  # Returns a diagonal matrix with the elements of the given column vector `x` on the diagonal.
  # An optional matrix `T` can be specified to store the result into instead of creating a new matrix.
  # Throws an error if `x` is not a column vector or if `T` is given and it is not a square matrix with the expected size
  diag: (x, T) ->
    if not T?
      T = createMatrix x.length, x.length
    else if not T.isSize x.length
      failUnmatchingDimensions()
    T.each (val, r, c) ->
      T.set r, c, if r == c then x[r] else 0
    T

eachInRow = (row, handler) ->
  for j in [0...@columns] by 1
    handler.call @, (@get row, j), row, j
  @

each = (handler) ->
  for i in [0...@rows] by 1
    eachInRow.call @, i, handler
  @

eachDiagonal = (handler) ->
  for ij in [0...Math.min @rows, @columns] by 1
    handler.call @, (@get ij, ij), ij, ij
  @

makeReduce = (eachFunc) ->
  (callback, initialValue) ->
    value = initialValue
    eachFunc.call @, (val, i, j) ->
      if value?
        value = callback.call @, value, val, i, j
      else
        value = val
      return
    value


# Matrix prototype
# ----------------

# The *Matrix* prototype.
matrixProto =

  # Returns the matrix element with the given *row* and *column*.
  get: (row, col = 0) ->
    @array[row * @columns + col]

  # Sets the matrix element with the given *row* and *column* to the given *value*.
  # Returns the matrix to enable chaining.
  set: (row, col, val) ->
    @array[row * @columns + col] = val
    @

  # Returns `true` if the matrix has the same *width* and *height* as the given matrix `B`.
  # Returns `false` otherwise.
  isSize: (rowsOrM, columns) ->
    if typeof rowsOrM == "number"
      if not columns? # height given?
        columns = rowsOrM
      @rows == rowsOrM and @columns == columns
    else # assume first argument is a matrix; ignore second
      @isSize rowsOrM.rows, rowsOrM.columns

  # Returns `true` if *width* and *height* of the matrix are equal. Returns `false` otherwise.
  isSquare: ->
    @rows == @columns

  each: each

  eachDiagonal: eachDiagonal

  reduce: makeReduce each

  reduceDiagonal: makeReduce eachDiagonal

  reduceRows: (callback, initialValue) ->
    rdcRows = []
    for i in [0...@rows] by 1
      value = initialValue
      for j in [0...@columns] by 1
        val = @get i, j
        if value?
          value = callback.call @, value, val, i, j
        else
          value = val
      rdcRows.push value
    rdcRows

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
      if not @isSize T
        failUnmatchingDimensions()
    else # no buffer matrix argument
      T = createMatrix @rows, @columns
    func = args[n] # mapping function
    l = T.rows * T.columns
    elements = [] # mapping function input parameters
    T.each (val, i, j) =>                   # iterate matrix entries
      elements[0] = @get i, j               # set first input param
      for k in [0...n] by 1                  # set more input params if available
        elements[k+1] = args[k].get i, j
      elements[++k] = i
      elements[++k] = j
      T.set i, j, func.apply @, elements # calculate matrix element from input params
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
  transp: (T = createMatrix @columns, @rows) ->
    if T == @ # transpose in place
      B = @clone() # TODO: manage in place transpose without creating new buffer array
      [@rows, @columns] = [@columns, @rows] # switch dimension
      B.transp @
    else # transpose to new buffer
      if @rows != T.columns or @columns != T.rows
        failUnmatchingDimensions()
      for i in [0...@columns] by 1
        for j in [0...@rows] by 1
          T.set i, j, @get j, i
      T

  # Returns the matrix multiplication of the matrix with matrix `B`.
  # An optional matrix `T` can be specified to store the result into instead of creating a new matrix.
  # Throws an error if the matrix width is different to the height of `B` or if `T` is given and its height is different
  # to the matrix height or its width is different to the with of `B`.
  mult: (B, T = createMatrix @rows,  B.columns) ->
    if @columns != B.rows or T.rows != @rows or T.columns != B.columns
      failUnmatchingDimensions()
    T.fill 0, T # initialize with zeros
    for i in [0...@rows] by 1 # iterate rows of T
      for j in [0...B.columns] by 1 # iterate colums of T
        for k in [0...@columns] by 1 # iterate columns of A / rows of B
          T.array[i * T.columns + j] += (@get i, k) * (B.get k, j)
    T

  # Returns a human readable string serialization of the matrix.
  toString: ->
    (@reduceRows concatEntries).reduce concatRows # TODO: shim; reduce() only in EcmaScript 5


# Public API
# ----------

# Export Matrix constructor.
module.exports = createMatrix = creator matrixProto, matrixConstructor, matrixStatic


