define ->

  map: (f, A, B = A) ->
    for col, j in A
      for el, i in col
        B[j][i] = f(el)
    B
