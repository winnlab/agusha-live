
path = require 'path'

_ = require 'underscore'
mongoose = require 'mongoose'

should = require 'should'
request = require 'supertest'

index = require '../../../core/index'

Server = getLibrary 'server'
ODM = getLibrary 'odm'
FS = new (getLibrary('fs'))

describe '#ODM', ()->
	it '#ODM.mongoose instanceof', () ->
		odm = ODM.create()

		should(odm.mongoose).be.instanceof mongoose.Mongoose

	it '#ODM.connect', (done) ->
		odm = ODM.create()

		odm.on 'connected', (connection) ->
			done()

	it '#ODM.connect instanceof', (done) ->
		odm = ODM.create()

		odm.on 'connected', (connection) ->
			should(connection).be.instanceof mongoose.Connection
			done()

	before (done) ->
		odm = ODM.create()

		odm.preloadModels 'test'

		options =
			model: 'tested'
			method: 'create'
			query:
				name: "Roman"
			callback: done

		odm.query options

	it '#ODM.query', (done) ->

		odm = ODM.create()

		odm.preloadModels 'test'

		options =
			model: 'tested'
			method: 'find'
			query: {}
			fields: 'name'
			callback: done

		odm.query options

	after (done) ->
		odm = ODM.create()

		odm.preloadModels 'test'

		options =
			model: 'tested'
			method: 'remove'
			callback: done

		odm.query options

	it '#ODM.create', (done) ->
		odm = ODM.create model: 'tested'

		odm.preloadModels 'test'

		userObject = 
			name: "Senin Roman"

		callback = (err, user, callback) ->
			should(userObject.name).eql user.name
			done()

		odm.create userObject, callback
