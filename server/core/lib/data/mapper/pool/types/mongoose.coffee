
util = require 'util'
path = require 'path'

_ = require 'underscore'
mongoose = require 'mongoose'

fs = getLibrary 'core/fs'
error = getUtility 'core/error'

modelPath = path.join pathes.app, 'model'

loadModels = () ->
	self = @
	models = fs.loadDirJsSync modelPath

	for model in models
		self.set model

load = () ->
	loadModels.call @
	@isLoaded = true

	return @

class MongoosePool
	isLoaded: false

	constructor: (options) ->
		ctx = options.ctx || null

		if not ctx
			error.throw "Ctx for MongoosePool not exist"

		if ctx and ctx not instanceof mongoose.Mongoose
			error.throw "Ctx for MongoosePool is not instance of mongoose"

		@ctx = ctx
		load.call @

		return @

	reload: () ->
		load.call @

		return @

	get: (name) ->
		if @ctx.models[name]
			return @ctx.models[name]

		return null

	set: (model) ->
		if not schema = model.schema
			error.throw "In model #{name} not exist schema field", "SCHMNEXST"

		if not options = model.options
			error.throw "In model #{name} not exist option field", "OPTSNEXST"

		schema = new @ctx.Schema schema, options

		if methods = model.methods
			_.extend schema.methods, methods

		if statics = model.static
			_.extend schema.static, statics

		if @ctx.models[model.name]
			@ctx.models[model.name] = null

		@ctx.model model.name, schema

exports.Mongoose = MongoosePool

module.exports = exports
