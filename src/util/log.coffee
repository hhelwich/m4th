# A basic logging module.

# Log info messages for debugging. **TODO**: empty later

log =
  info: (message) ->
    console.log "INFO: #{message}"

  warn: (message) ->
    console.log "WARN: #{message}"

# Throw an application specific error.

  fail: (message) ->
    throw
      name: "2cpyError"
      message: message

# ### Public API

module.exports = log