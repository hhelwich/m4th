
createAssertion = (upper) ->
  (expectedMatrix, delta = 0) ->

    @assert (@_obj.isSize expectedMatrix),
      "expected matrix #{@_obj} to have height #{expectedMatrix.height} and width #{expectedMatrix.width}",
      "expected matrix #{@_obj} to have not height #{expectedMatrix.height} or width #{expectedMatrix.width}"

    for c in [0...expectedMatrix.width] by 1
      for r in [0...(if upper then c+1 else expectedMatrix.height)] by 1
        @assert (Math.abs (@_obj.get r, c) - (expectedMatrix.get r, c)) <= delta,
          "expected matrix element #{@_obj.get r, c} in row #{r} and column #{c} to be close to #{expectedMatrix.get r, c}",
          "expected matrix element #{@_obj.get r, c} in row #{r} and column #{c} to be not close to #{expectedMatrix.get r, c}"

    return


module.exports = (chai, utils) ->

  Assertion = chai.Assertion

  Assertion.addMethod "approx", createAssertion false


  Assertion.addMethod "approxUpper", createAssertion true