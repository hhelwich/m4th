module.exports =

  # Return a function which creates a new object with the given prototype and initializes this object with the given
  # constructor function.
  # Also copy optional `extend` object content to returned function.
  createConstructor: (prototype, constructor, extend) ->
    # Create function which forwards to given constructor function.
    F = (args) ->
      constructor.apply @, args
      @ # overwrite constructor return value
    # Set functions prototype field.
    F.prototype = prototype
    # Create function which creates a new object with the given prototype and initializes with the given constructor.
    f = ->
      new F arguments
    # Add static fields to function.
    for key, value of extend
      f[key] = value
    f
