var bin = require('../lib/binpack');

var imageDir = __dirname + '/images';
var width = 280, height = 230;

var map = bin.packImage(imageDir, __dirname + '/output.png', width, height);
console.log(map);

map = bin.packData(imageDir, width, height);
console.log(map.data);