m4th [![.](https://badge.fury.io/js/m4th.png)](http://badge.fury.io/js/m4th) [![.](https://travis-ci.org/hhelwich/m4th.png?branch=master)](https://travis-ci.org/hhelwich/m4th) [![.](https://coveralls.io/repos/hhelwich/m4th/badge.png)](https://coveralls.io/r/hhelwich/m4th)
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


[![Browser Test Status](https://saucelabs.com/browser-matrix/m4th.svg)](https://saucelabs.com/u/m4th)



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

Matrix Creation
---------------

Create a 2x3 matrix (2 rows, 3 columns) and a 4x4 matrix with ```undefined``` entries:

```javascript
var A, B;
A = M(2, 3);
B = M(4);
```
Create a 2x2 matrix and a 2x3 matrix with the given content:

```javascript
var A, B;
A = M([
    3,  2,
    1,  0
]);
B = M(2, [
    1,  2,  3,
    4,  5,  7
]);
```

Matrix Entries
--------------

Each matrix has readable ```rows``` and ```columns``` properties:

```javascript
console.log('Matrix A has ' + A.rows + ' rows and ' + A.columns + ' columns.');
```

Matrix entries can be accessed with ```get()``` and ```set()``` (indices start at ```0```):

```javascript
var a = A.get(0, 3); // get entry in row 0 and column 3
A.set(1, 2, 3); // set entry in row 1 and column 2 to value 3
```

You can chain ```set()```:

```javascript
A.set(1, 0, 3).set(1, 1, 4).set(1, 2, 5);
```

Imperative / Functional
-----------------------

Calculations on matrices can be done in imperative or functional style.
For example the [frobenius norm](http://en.wikipedia.org/wiki/Matrix_norm#Frobenius_norm) of a matrix ```A```
can be calculated imperatively:

```javascript
var i, j, a, norm;
norm = 0;
for (i = 0; i < A.rows; i += 1) { // iterate matrix rows
  for (j = 0; j < A.columns; j += 1) { // iterate matrix columns
    a = A.get(i, j);
    norm += a * a;
  }
}
norm = Math.sqrt(norm);
```

But we can do better using ```each()``` which takes a callback as an argument:

```javascript
var norm = 0;
A.each(function (a) { // iterate matrix entries
  norm += a * a;
});
norm = Math.sqrt(norm);
```

In a more functional style the same can be expressed with ```map()``` and ```reduce()```:

```javascript
var square, add, norm;
// helper functions
square = function (x) {
  return x * x;
};
add = function (x, y) {
  return x + y;
};
// calculate norm
norm = Math.sqrt(A.map(square).reduce(add));
```

This now reads nicer than the imperative approach.

If performance is important, you can remove the ```map()``` call (which creates a temporary matrix) and use a single
```reduce()``` instead:

```javascript
var addSquared, norm;
// helper function
addSquared = function (x, y) {
  return x + y * y;
};
// calculate norm
norm = Math.sqrt(A.reduce(addSquared, 0));
```

Matrix Operations
-----------------

```javascript
// calculate some results without changing the matrices A, B and C:
console.log('A*B = ' + A.mult(B));
console.log('B+C = ' + B.add(C));
console.log('C-B = ' + C.minus(B));
console.log('B*3 = ' + B.times(3));
console.log('B^t = ' + B.transp());
console.log('fill B with constant value = ' + B.fill(2));
console.log('copy of A = ' + A.clone());
console.log('A is square? = ' + A.isSquare());
console.log('A has same size as B? = ' + A.isSize(B));
```

map()
-----

Create a 5x5 hilbert matrix:

```javascript
var H = M(5).map(function (h, i, j) {
    return 1 / (i + j + 1);
});
```

LU decomposition
----------------

```javascript
var A, y, LU, x, Ainv;
// create some matrices:
A = M([
    2,  1, -1,
   -3, -1,  2,
   -2,  1,  2
]);
           
y = M(3, [
    8,
  -11,
   -3
]);

// LU decompose matrix A          
LU = m4th.lu(A); // node.js: require('m4th/lu')(A);
// calculate solution for: y = A*x
x = LU.solve(y);
// invert matrix A
Ainv = LU.getInverse();
```

UD decomposition
----------------

```javascript
var A, y, UD, x;
// create some matrices:
A = M([
    2, 1, 1, 3, 2,
    1, 2, 2, 1, 1,
    1, 2, 9, 1, 5,
    3, 1, 1, 7, 1,
    2, 1, 5, 1, 8
]);
           
y = M(5, [ -2, 4, 3, -5, 1 ]);

// UD decompose matrix A          
UD = m4th.ud(A); // node.js: require('m4th/ud')(A);
// calculate solution for: y = A*x
x = UD.solve(y);
```





## Changelog

### 0.1.0 / 2014-02-10

* Initial release
