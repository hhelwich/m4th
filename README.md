m4th [![Build Status](https://travis-ci.org/hhelwich/m4th.png?branch=master)](https://travis-ci.org/hhelwich/m4th) [![Coverage Status](https://coveralls.io/repos/hhelwich/m4th/badge.png)](https://coveralls.io/r/hhelwich/m4th)
====

A library to use in the browser or node.js. It currently contains:

* Basic Matrix operations
* LU decomposition
* UD decomposition (optimized cholesky decomposition)

Browser
-------

To use the library in the browser, you need to include [this](https://raw.github.com/hhelwich/m4th/master/m4th.min.js) JavaScript file:

```html
<script src="m4th.min.js"></script>
```

It exports the global `m4th` object. Now you can access e.g. the matrix constructor with:

```javascript
var M = m4th.matrix;
```

node.js
-------

You can install this package with:

```
npm install m4th
```

Now you can load e.g. the matrix constructor with:

```javascript
var M = require('m4th/matrix');
```

Examples
========

Matrix Operations
-----------------

```javascript
// create some matrices:
var A = M([ 3,  2,
            1,  0 ]);
var B = M([ 1,  2,  3,
            4,  5,  7 ], 3);
var C = M([ 0,  6,  8,
            3, -3,  5 ], 3);

// output matrix content:
console.log("A = " + A);
console.log("B = " + B);
console.log("C = " + C);

// output matrix size:
console.log("height of A = " + A.height);
console.log("width of A = " + A.width);

// get / set matrix elements
console.log("get element in row 2 and column 3 of B = " + B.get(1, 2));
B.set(1, 2, 9); // set element in row 2 and column 3 of B to 9

// calculate some results without changing the matrices A, B and C:
console.log("A*B = " + A.mult(B));
console.log("B+C = " + B.add(C));
console.log("C-B = " + C.minus(B));
console.log("B*3 = " + B.times(3));
console.log("B^t = " + B.transp());
console.log("fill B with constant value = " + B.fill(2));
console.log("square each element of B = " + B.map(function(x){return x*x;}));
console.log("double elements of B and add C = " + 
                                    B.zip(function(b, c){return 2*b+c;}, C));
console.log("copy of A = " + A.clone());
console.log("A is square? = " + A.isSquare());
console.log("A has same size as B? = " + A.isSameSize(B));
```



LU decomposition
----------------

```javascript
// create some matrices:
var A = M([  2,  1, -1,
            -3, -1,  2,
            -2,  1,  2 ]);
           
var y = M([  8, 
           -11, 
            -3 ], 1);

// LU decompose matrix A          
var LU = m4th.lu(A); // node.js: require('m4th/lu')(A);
// calculate solution for: y = A*x
var x = LU.solve(y);
// invert matrix A
var Ainv = LU.getInverse();
```


UD decomposition
----------------

```javascript
// create some matrices:
var A = M([ 2, 1, 1, 3, 2, 
            1, 2, 2, 1, 1, 
            1, 2, 9, 1, 5,
            3, 1, 1, 7, 1,
            2, 1, 5, 1, 8 ]);
           
var y = M([ -2, 4, 3, -5, 1 ], 1);

// UD decompose matrix A          
var UD = m4th.ud(A); // node.js: require('m4th/ud')(A);
// calculate solution for: y = A*x
var x = UD.solve(y);
```
