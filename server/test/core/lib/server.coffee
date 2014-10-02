
fs = require 'fs'
http = require 'http'
cluster = require 'cluster'

_ = require 'underscore'
express = require 'express'
should = require 'should'
request = require 'supertest'

index = require '../../../core/index'

Server = getLibrary 'server'

describe '#Server.single', () ->
	it '#Server; should be a function', () ->
		should(Server).be.a.Function

	it '#Server.single; single web server should must implemented', (done) ->
		options =
			app: express
			port: 3001

		server = new Server options
		server.listen()

		request(server.app)
			.get('/')
			.expect(404)
			.end done

	it '#Server.routing; should routes function muste implemented', (done)->
		options =
			app: express
			port: 3000
			routes: ()->
				@get '/', (req, res) ->
					res.send 'Hello world'

		server = new Server options
		server.listen()

		request(server.app)
			.get('/')
			.expect(200)
			.expect('Hello world')
			.end done


	it '#Server; should be bind server', (done)->
		options =
			app: express
			port: 3002
			routes: () ->
				@get '/', (req, res) ->
					res.send 'Hello world'

		server = new Server options
		server.listen()

		request(server.app)
			.get('/')
			.expect(200)
			.expect('Hello world')
			.end done

	it '#Server.configure; should be configure exist', (done) ->
		options =
			app: express
			port: 3003
			configure: () ->
				@use '/', (req, res, next)->
					req.hello = 'Hello world'
					next()
			routes: () ->
				@get '/', (req, res) ->
					res.send req.hello

		server = new Server options
		server.listen()

		request(server.app)
			.get('/')
			.expect(200)
			.expect('Hello world')
			.end done

# describe '#Server.cluster', () ->

# 	it '#Server should be create a worker', () ->
# 		options =
# 			app: express
# 			port: 3004
# 			workers: 2
# 			# routes: () ->
# 			# 	@get '/', (req, res) ->
# 			# 		res.send 'Hello world'

# 		server = new Server options
# 		server.listen()

		# workerSize = _.size cluster.workers

		# should(workerSize).eql options.workers

	# it '#Server should be equals of cluster.workers', () ->
	# 	options =
	# 		app: express
	# 		workers: 2

	# 	server = new Server options
	# 	server.listen()

		# workers = cluster.workers

		# _.some workers, (worker, key) ->
		# 	isContain = _.contains workers, worker
		# 	console.log isContain
		# 	return isContain

