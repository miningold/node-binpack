var dir;

if (process.env['BP_DEV']) {
    dir = 'src';
    console.log('running in development, using src/ directly');
    require('coffee-script');
} else {
    dir = 'lib';
}

module.exports = require('./' + dir + '/binpack');

