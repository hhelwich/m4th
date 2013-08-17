define

  info: (message) ->
    console.log message

  fail: (message) ->
    throw
      name: '2cpyError'
      message: message