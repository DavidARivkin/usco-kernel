esprima = require "esprima"


class ASTAnalyser
  constructor:->

  ###*
  * Determine if current node is an "include" call node
  * @param {Object} node the AST node to test
  * @return {boolean} true if node is an include node, false otherwise
  ### 
  isInclude: ( node )->
    c = node.callee
    return (c and node.type == 'CallExpression' and c.type == 'Identifier' and c.name == 'include')

  ###*
  * Determine if current node is an "isImportGeom" call node
  * @param {Object} node the AST node to test
  * @return {boolean} true if node is an isImportGeom node, false otherwise
  ###  
  isImportGeom: ( node )->
    c = node.callee
    return (c and node.type == 'CallExpression' and c.type == 'Identifier' and c.name == 'importGeom')
  
  ###*
  * Determine if current node is a parameter definition node
  * @param {Object} node the AST node to test
  * @return {boolean} true if node is a parameter node, false otherwise
  ###  
  isParams: ( node )->
    #TODO: fix this 
    c = node.callee
    if c?
      name = c.name
    #console.log "NODE", node, "callee",c, "Cname", name, "type",node.type, "name", node.name
    return (c and node.type == 'VariableDeclaration' and c.type == 'Identifier' and c.name == 'params')
   
  ###*
  * Traverse the AST , analyse and spit out the needed information
  * @param {Object} ast the esprima generated AST
  * @return {Object} 
  ### 
  _walkAst:( ast )=>
    
    traverse = (object,limit,level, visitor, path) =>
      #console.log "level",level, "limit", limit, "path",path
      #limit = limit or 2
      #level = level or 0
      #console.log "visitore", visitor
      if level < limit or limit == 0
        key = undefined
        child = undefined
        path = []  if typeof path is "undefined"
        visitor.call null, object, path, level
        subLevel = level+1
        for key of object
          if object.hasOwnProperty(key)
            child = object[key]
            traverse child, limit, subLevel, visitor, [object].concat(path)  if typeof child is "object" and child isnt null
    
    #get all the things we need from ast
    rootElements = []
    includes = []
    importGeoms = []
    params = [] #TODO: only one set of params is allowed, this needs to be changed
    
    
    #ALL of the level 0 (root level) items need to be added to the exports, if so inclined
    traverse ast,0,0, (node, path, level) =>
      name = undefined
      parent = undefined
      
      #console.log("level",level)
      
      if node.type is esprima.Syntax.VariableDeclaration and level is 2
        console.log("VariableDeclaration")
        for dec in node.declarations
          decName = dec.id.name
          #console.log "ElementName", decName
          rootElements.push( decName )
    
      if @isInclude( node )
        console.log("IsInclude",node.arguments[0].value)
        includes.push( node.arguments[0].value )
      
      if @isImportGeom( node )
        console.log("IsImportGeom",node.arguments[0].value)
        importGeoms.push( node.arguments[0].value )
      
      if @isParams( node )
        console.log("isParams",node.arguments[0].value)
        params.push( node.arguments[0].value )
    
    console.log("rootElements", rootElements)
    console.log("includes",includes)
    console.log("importGeoms",importGeoms)   
    console.log("params",params)    
    
    return {rootElements:rootElements, includes:includes, importGeoms:importGeoms}
    

module.exports = ASTAnalyser