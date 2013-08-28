Q = require("q")
fs = require('fs')

class DummyStore
  loadFile:( uri )=>
    deferred = Q.defer()
    
    if not fs.existsSync( uri )
      deferred.reject( "#{uri} not found" )
    
    else
      #stats = fs.lstatSync(uri)
      #console.log("stats", stats)
      data = fs.readFileSync( uri, 'utf8' )
      #console.log("data",data)
      deferred.resolve(data)
    
    return deferred.promise


module.exports = DummyStore