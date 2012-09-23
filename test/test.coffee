bin = require '../index'
should = require 'should'

imageDir = __dirname + '/images';
width = 280 
height = 230

describe 'BinPack', ->
  
  describe '#packData()', ->
    map = null
    
    beforeEach ->
      map = bin.packData imageDir, width, height
      
    it 'should return a map file with a data property', ->
      should.exist map.data
      
    it 'map.data property should start with "data:image/png;base64,"', ->
      map.data.should.match(/^data:image\/png;base64,/)

