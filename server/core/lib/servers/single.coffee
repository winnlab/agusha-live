
cluster = require 'cluster'
events = require 'events'
http = require 'http'

_ = require 'underscore'

getArgumentsForServer = (data) ->
	userOptions = Object.keys data
	options = ['port', 'hostname', 'backlog', 'callback']
	args = []

	_.each options, (item, key) ->
		isOption = _.some userOptions, (option) ->
			return item is option

		if not isOption
			return false

		args.push data[item]

	args

createStubServer = ()->
	http.createServer (req, res)-> 
		res.end "Not server application exist"

class SingleServer extends events.EventEmitter
	constructor: (options) ->
		@options = options

		app = if options.app then options.app() else createStubServer()
		@app = app

		@setupServer()

		return @
	setupServer: () ->

		@routeFunc = @options.routes || ->
		@configureFunc = @options.configure || ->

		@configureFunc.call @app
		@routeFunc.call @app
	listen: () ->
		self = @
		args = getArgumentsForServer @options
		@server = @app.listen.apply @app, args

		@server.on 'listening', ()->
			self.emit 'listening'


module.exports = SingleServer
