ObjectBase = require './shapes/base'

###*** 
*Base class for defining "parts"
###
class Part extends ObjectBase
  constructor:(options)->
    super options
    parent = @__proto__.__proto__.constructor.name
    #register(@__proto__.constructor.name, @, options)
    
    #defaults should always be stored, as the "baseline" for a part
    @defaults = {version: 0.0.1, manufactured:true}
    options = merge @defaults, options
    
    #should this be even here ?
    @manufactured = options.manufactured
    
module.exports = Part