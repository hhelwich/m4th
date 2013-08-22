# A basic logging module.

# Log info messages for debugging. **TODO**: empty later

info = (message) ->
  console.log message

# Throw an application specific error.

fail = (message) ->
  throw
    name: '2cpyError'
    message: message

# ### Public API

module.exports =
  info: info
  fail: fail