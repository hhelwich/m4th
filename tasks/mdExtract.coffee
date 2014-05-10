esprima = require "esprima"

separator = "\n// ---------------------------------------------------------------------------------------------------------------------\n"

header = (text) ->
  pos = Math.floor (separator.length - text.length) / 2
  (separator.substring 0, pos) + text + (separator.substring pos + text.length)

extractVars = (node, vars, declaration) ->
  if node.type == "Program"
    for child in node.body
      extractVars child, vars
  else if node.type == "VariableDeclaration"
    for dec in node.declarations
      extractVars dec, vars
  else if node.type == "VariableDeclarator"
    extractVars node.id, vars, true
    if node.init?
      extractVars node.init, vars
  else if node.type == "MemberExpression"
    extractVars node.object, vars
  else if node.type == "Identifier"
    vars[node.name] = vars[node.name] == true || declaration == true
  else if node.type == "CallExpression"
    extractVars node.callee, vars
    for arg in node.arguments
      extractVars arg, vars
  else if node.type == "ExpressionStatement"
    extractVars node.expression, vars
  else if node.type == "AssignmentExpression"
    extractVars node.left, vars
    extractVars node.right, vars
  else if node.type == "BinaryExpression"
    extractVars node.left, vars
    extractVars node.right, vars
  else if node.type == "ForStatement"
    extractVars node.init, vars
    extractVars node.test, vars
    extractVars node.update, vars
    extractVars node.body, vars


getVars = (ast) ->
  vars = {}
  extractVars ast, vars
  vars

module.exports = (grunt) ->

  grunt.registerMultiTask "mdExtract", ->

    files = @files.slice()


    for file in files

      destDir = file.dest

      sfiles = file.src.filter (filepath) ->
        # Warn on and remove invalid source files (if nonull was set).
        fileExists = grunt.file.exists filepath
        if not fileExists
          grunt.log.warn "Source file '#{filepath}' not found."
        fileExists

      rexp = /```javascript([^`]*)/g

      for sfile in sfiles # iterate source files

        outJs = "module.exports = [\n"

        str = grunt.file.read sfile

        # extract snippets array
        snippets = while (myArray = (rexp.exec str)) != null
          myArray[1]


        snippets = snippets.map (snippet, i) ->
          vars = getVars esprima.parse snippet
          allVars = Object.keys vars

          undeclared = []
          for v of vars
            if not vars[v]
              undeclared.push v

          out = "function(#{if allVars.length > 0 then "_" else ""}){"

          # declare undeclared variables
          if undeclared.length > 0
            out += "var #{undeclared.join ","};"
          # initialize variables
          if allVars.length > 0
            out += "if(_!=null){"
            out += (allVars.map (v) ->
              "#{v}=_.#{v};").join ""
            out += "}"

          out += header " Snippet #{i} "

          out += snippet

          out += separator
          out += "return{#{allVars.map (v) -> "#{v}:#{v}"}};}"

        outJs += snippets.join ","


        outJs += "];\n"

        grunt.file.write "#{destDir}/#{sfile}.js", outJs
