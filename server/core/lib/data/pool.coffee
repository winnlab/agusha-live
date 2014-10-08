
path = require 'path'

mongoose = require 'mongoose'
_ = require 'underscore'

error = getUtility 'error'
fileHelper = getUtility 'file'

modelPath = path.join pathes.app, 'model'

loadModels = () ->
	self = @
	models = fileHelper.loadDirJsSync modelPath

	_.each models, self.set

load = () ->
	loadModels.call @
	@isLoaded = true

	return @

# Class for loading mongoose models
# 
# @example How to create Pool instance
# 	Pool = getLibrary('data/pool') <new mongoose.Mongoose>
# @example How to get singleton instance
# 	Pool = getLibrary('data/pool').singleton
# @example How to get class of Pool
# 	Pool = getLibrary('data/pool').Pool

class Pool
	# @property [Boolean] Flag, indicating whether the passing is loading of models
	isLoaded: false

	# Constructor a Pool. Loading all models form model directory
	# 
	# @param mongoose [Mongoose] Optional parameter. If not passing, using "mongoose" module
	# @return [Pool] Return new Pool instance
	constructor: (ctx) ->
		if ctx and ctx not instanceof mongoose.Mongoose
			error.throw "Ctx is not instance of mongoose"

		@ctx = ctx || mongoose
		load.call @

		return @

	# Reload models in model directory
	# 
	# @return [Pool] Pool instance
	reload: () ->
		load.call @

		return @

	# Return models from ctx
	# 
	# @param name [String] Name of model
	# @return model [Model] mongoose.Model object
	get: (name)->
		if @ctx.models[name]
			return @ctx.models[name]

		return

	# Setting model to ctx instance
	# 
	# @param name [String] Model name
	# @param value [Object] Model object
	# @return model [Model] mongoose.Model object
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

class Singleton
	instance = null

	@get = (ctx) ->
		instance ?= new Pool ctx

exports = (ctx) ->
	return new Pool ctx

exports.Pool = Pool

module.exports = exports;
