'use strict';

var _express = require('express');

var _express2 = _interopRequireDefault(_express);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var app = (0, _express2.default)();

console.log('starting app in');
console.log(process.env.NODE_ENV);
if (process.env.NODE_ENV === 'production') {
  console.log('use static markup');
  console.log(__dirname + '/client/build');
  app.use('/', _express2.default.static(__dirname + '/../client/build'));
}

app.get('/hello', function (req, res) {
  res.send('Hello world!');
});

app.listen(5000, function () {
  console.log('App listening on port 5000');
});