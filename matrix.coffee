define ['util/log'], (log) ->

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

  # public api
  map: map
  times: times
  width: width
  height: height