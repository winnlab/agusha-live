
events = require 'events'
path = require 'path'
fs = require 'fs'

_ = require 'underscore'
mongoose = require 'mongoose'

error = getUtility 'error'

models =
	isLoaded: false
	pool: {}

loadModels = (modelsDir, mongoose) ->
	modelsFiles = fs.readdirSync modelsDir

	_.each modelsFiles, (model, key) ->
		if model.match ///^\.///
			return false

		modelName = path.basename model, path.extname model
		modelObj = require path.join modelsDir, modelName

		if not modelObj.schema
			error.throw "Not exist schema in models #{modelName}", "SCHEMANAVLBL"

		if not modelObj.name
			modelObj.name = modelName

		if not modelObj.schemaOptions
			modelObj.schemaOptions = {}

		schema = new mongoose.Schema modelObj.schema, modelObj.schemaOptions

		models.pool[modelObj.name] = mongoose.model modelObj.name, schema

class ODM extends events.EventEmitter
	constructor: (options) ->
		options = options || {}

		@options = _.extend @options, options
		@connect()

		if not models.isLoaded
			@preloadModels()

		return @
	options:
		host: "localhost"
		port: "27017"
		base: "test"
	connect: (callback) ->
		self = @
		@mongoose = new mongoose.Mongoose

		host = @options.host
		port = @options.port
		database = @options.base
		userUri = ''

		if @options.user && @options.pwd
			user = @options.user
			pwd = @options.pwd

			userUri = "#{user}:#{pwd}@"

		uri = "mongodb://#{userUri}#{host}:#{port}/#{database}"

		connection = @mongoose.connect uri

		@mongoose.connection.on 'connected', () ->
			self.connection = self.mongoose.connection

			self.emit 'connected', self.connection

		if not callback
			return @connection

		@mongoose.connection.on 'connected', () ->
			callback null, self.connection

	preloadModels: (dir) ->
		dir = dir || 'application'
		modelsDir = path.join baseServerPath, dir, 'model'

		loadModels modelsDir, @mongoose

	query: (options) ->
		name = options.model || @options.model
		
		if not model = models.pool[name]
			error.throw "Not exist model \"#{name}\"", 'MTHDNEXST'

		if not method = options.method or not model[options.method]
			error.throw 'For execute, not method specified', 'MTHDNEXST'

		if method.match 'find'
			options.fields = options.fields || ''

		props = ['query', 'fields', 'options', 'callback']

		args = []

		_.each props, (item, key, list) ->
			if options[item] or options[item] is ''
				args.push options[item]

			return false

		model[method].apply model, args
	create: (data, callback) ->
		name = @options.model

		if not model = models.pool[name]
			error.throw 'Not model exist', 'MTHDNEXST'

		newModel = new model data

		newModel.save callback



ODM.create = (options) ->
	return new ODM options

module.exports = ODM
