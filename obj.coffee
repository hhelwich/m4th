module.exports =

  # Return a function which creates a new object with the given prototype and initializes this object with the given
  # constructor function.
  createConstructor: (prototype, constructor) ->
    F = (args) ->
      constructor.apply @, args
    F.prototype = prototype
    ->
      new F arguments

