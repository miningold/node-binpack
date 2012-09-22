var bin = require('../lib/binpack');

var map = bin.pack('images/', 'output.png');
console.log(map);