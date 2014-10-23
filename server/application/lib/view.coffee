
fs = require 'fs'

jade = require 'jade'

string = getUtility 'string'

viewDirectory = "#{pathes.base}/static/views"

compiledFiles = []
compiledClients = []

loadClient = (name) ->
	filename = "#{viewDirectory}/#{name}.jade"
	
	# if not compiledClients[name]?
	templateCode = fs.readFileSync filename, "utf-8"
	
	options =
		compileDebug: false
		filename: filename
		pretty: false
	
	compiled = jade.compileClient(templateCode, options).toString()
	
	compiledClients[name] =
		source: compiled,
		lastModified: (new Date).toUTCString(),
	
	compiledClients[name]

exports.compiler = (options) ->
	options = options or {}
	options.root = options.root || ""
	options.root = "/" + options.root.replace(/^\//, "")
	options.root = options.root.replace(/\/$/, "") + "/"
	rootExp = new RegExp("^" + string.escape(options.root))
	
	(req, res, next) ->
		if req.method isnt "GET" and req.method isnt "HEAD"
			return next()

		console.log options.root
		
		template = req.url.replace(rootExp, "")
		
		try
			# context = new TemplateContext
			# container = context.load(template)
			
			container = loadClient template
			
			res.setHeader "Content-Type", "application/x-javascript; charset=utf-8"
			res.setHeader "Last-Modified", container.lastModified
			res.setHeader "Content-Length", (if typeof Buffer isnt "undefined" then Buffer.byteLength(container.source, "utf8") else container.source.length)
			res.end container.source
		catch e
			next e

		if not options.root
			next()
