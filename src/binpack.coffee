fs = require 'fs'
Canvas = require 'canvas'
Image = Canvas.Image

exports.version = require('../package').version;

class Rect 
  constructor: (@x, @y, @w, @h) ->
  
  contains: (other) ->
    return @w >= other.w and @h >= other.h
    
  equals: (other) ->
    return @w == other.w and @h == other.h
    
  toSimple: ->
    return x: @x, y: @y, w: @w, h: @h
    
class Node
  constructor: () ->
    @left = null
    @right = null
    @rect = null
    @filled = false
    
  insertRect: (rect) ->
    if @left
      return @left.insertRect(rect) || @right.insertRect(rect)
      
    if @filled
      return null
      
    if not @rect.contains rect
      return null
      
    if rect.equals @rect
      @filled = true
      return this
      
    @left = new Node
    @right = new Node
    
    widthDiff = @rect.w - rect.w
    heightDiff = @rect.h - rect.h
    
    me = @rect
    
    if widthDiff > heightDiff
      @left.rect = new Rect me.x, me.y, rect.w, me.h
      @right.rect = new Rect me.x + rect.w, me.y, me.w - rect.w, me.h
    else
      @left.rect = new Rect me.x, me.y, me.w, rect.h
      @right.rect = new Rect me.x, me.y + rect.h, me.w, me.h - rect.h
      
    return @left.insertRect rect
    
Bin = {}
    
pack = (imageDir, w, h) ->
  canvas = Bin.canvas = new Canvas w, h
  ctx = Bin.ctx = canvas.getContext '2d'

  images = fs.readdirSync imageDir
  # console.log images
  
  startNode = new Node
  startNode.rect = new Rect 0, 0, canvas.width, canvas.height
  
  map = 
    images: []
  
  for image in images
    # console.log "loading: " + image + "..."
    data = fs.readFileSync imageDir + '/' + image
    img = new Image
    img.src = data
    
    rect = new Rect 0, 0, img.width, img.height
    
    # console.log "inserting: " + image + "..."
    node = startNode.insertRect rect
    if node
      r = node.rect
      
      map.images[image] = r.toSimple()
      
      ctx.drawImage img, r.x, r.y
    else
      throw "Not enough room for image: " + image
      
  return map
    
    
exports.packImage = packImage = (imageDir, output, w, h) ->
  map = pack imageDir, w, h
  
  out = fs.createWriteStream output
  stream = Bin.canvas.createPNGStream()

  stream.on 'data', (chunk) ->
    out.write chunk
    
  return map
  
exports.packData = packData = (imageDir, w, h) ->
  map = pack imageDir, w, h
  map.data = Bin.canvas.toDataURL()
  
  return map
    
  
  