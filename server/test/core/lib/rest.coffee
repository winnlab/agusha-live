
express = require 'express'

should = require 'should'
request = require 'supertest'
bodyParser = require 'body-parser'

index = require '../../../core/index'

Server = getLibrary 'server'
Rest = getLibrary 'rest'
ODM = getLibrary 'odm'

describe '#Rest', () ->
	it '#Rest.constructor', () ->
		should(Rest).be.a.Function

	before (done) ->
		odm = ODM.create model: 'tested'

		odm.preloadModels 'test'

		userObject = 
			name: "Senin Roman"

		callback = (err, user, callback) ->
			should(userObject.name).eql user.name
			done()

		odm.create userObject, callback

	it '#Rest.find', (done) ->
		rest = new Rest
			model: 'tested'

		serverOption =
			app: express
			port: 3008
			configure: () ->
				@use '/test', rest.http()

		server = new Server serverOption
		server.listen()

		request(server.app)
			.get('/test')
			.expect('Content-type', /json/)
			.expect(200)
			.end (err, res)->
				should(err).eql null
				data = JSON.parse res.text

				should(data.success).eql true
				should(data.data[0].name).eql 'Senin Roman'

				done()

	after (done) ->
		odm = ODM.create()

		odm.preloadModels 'test'

		options =
			model: 'tested'
			method: 'remove'
			callback: done

		odm.query options

	it '#Rest.create', (done) ->
		rest = new Rest
			model: 'tested'

		serverOption =
			app: express
			port: 3010
			configure: () ->
				@use bodyParser.json()
				@use bodyParser.urlencoded extended: true
				@use '/test', rest.http()

		server = new Server serverOption
		server.listen()

		request(server.app)
			.post('/test')
			.send({'name': "romakSenin"})
			.expect('Content-type', /json/)
			.end (err, res)->
				should(err).eql null
				data = JSON.parse res.text

				should(data.success).eql true
				should(data.data.name).eql "romakSenin"

				done()

	it '#Rest.findOne', (done) ->
		rest = new Rest
			model: 'tested'

		serverOption =
			app: express
			port: 3011
			configure: () ->
				@use bodyParser.json()
				@use bodyParser.urlencoded extended: true
				@use '/test', rest.http()

		server = new Server serverOption
		server.listen()

		request(server.app)
			.post('/test')
			.send({'name': "romakSenin"})
			.expect('Content-type', /json/)
			.end (err, res)->
				should(err).eql null
				data = JSON.parse res.text
				should(data.success).eql true
				user = data.data

				request(server.app)
					.get('/test/'+user._id)
					.expect('Content-type', /json/)
					.end (err, res)->
						should(err).eql null
						data = JSON.parse res.text

						should(data.success).eql true
						should(data.data.name).eql user.name

						done()

	it '#Rest.update', (done) ->
		rest = new Rest
			model: 'tested'

		serverOption =
			app: express
			port: 3012
			configure: () ->
				@use bodyParser.json()
				@use bodyParser.urlencoded extended: true
				@use '/test', rest.http()

		server = new Server serverOption
		server.listen()

		request(server.app)
			.post('/test')
			.send({'name': "romakSenin"})
			.expect('Content-type', /json/)
			.end (err, res)->
				should(err).eql null
				data = JSON.parse res.text
				should(data.success).eql true
				user = data.data

				request(server.app)
					.put('/test/'+user._id)
					.send({name: "romaromaroma"})
					.expect('Content-type', /json/)
					.end (err, res)->
						should(err).eql null
						data = JSON.parse res.text

						should(data.success).eql true
						should(data.data.name).eql "romaromaroma"

						done()

	it '#Rest.remove', (done) ->
		rest = new Rest
			model: 'tested'

		serverOption =
			app: express
			port: 3013
			configure: () ->
				@use bodyParser.json()
				@use bodyParser.urlencoded extended: true
				@use '/test', rest.http()

		server = new Server serverOption
		server.listen()

		request(server.app)
			.post('/test')
			.send({'name': "romakSenin"})
			.expect('Content-type', /json/)
			.end (err, res)->
				should(err).eql null
				data = JSON.parse res.text
				should(data.success).eql true
				user = data.data

				request(server.app)
					.del('/test/'+user._id)
					.expect('Content-type', /json/)
					.end (err, res) ->
						should(err).eql null
						data = JSON.parse res.text
						should(data.success).eql true

						request(server.app)
							.get('/test/'+user._id)
							.expect('Content-type', /json/)
							.end (err, res)->
								should(err).eql null
								data = JSON.parse res.text

								should(data.success).eql true
								should(data.data).eql null

								done()



