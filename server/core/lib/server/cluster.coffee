
cluster = require 'cluster'
events = require 'events'

_ = require 'underscore'

SingleServer = getLibrary 'server/single'

error = getUtility 'error'

class ClusterServer extends events.EventEmitter
	constructor: (options) ->
		@options = options
		@workers = []
		@workersCount = options.workers

		if cluster.isMaster
			@initWorkers()
		else
			@setServer()
			@setListeners()
			@setServerListeners()

		return @
	setServerListeners: ()->
		self = @

		@single.on 'listening', (socket) ->
			self.emit 'listening', socket
	setListeners: () ->
		@on 'listen', @listen

		process.on 'message', @parseMessage
	setServer: () ->
		@single = new SingleServer @options
	parseMessage: (message) ->
		if not message.type
			return false

		if message.type is not 'server'
			return false

		clusterEvent = message.method

		@emit clusterEvent
	send: (method) ->
		_.each @workers, (worker, key, list) ->
			worker.send
				type: 'server'
				method: method
	listen: ()->
		if cluster.isMaster
			return @send 'listen'

		@single.listen()
	initWorkers: () ->
		self = @

		for i in [0...@workersCount]
			f = () ->
				worker = cluster.fork()

				self.workers.push worker

				worker.on 'exit', () ->
					cluster.fork worker

			f()

module.exports = ClusterServer
