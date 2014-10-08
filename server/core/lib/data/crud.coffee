
_ = require 'underscore'

ODM = getLibrary 'data/odm'

error = getUtility 'error'

class Crud
	constructor: (options) ->
		opts =
			modelName: ''

		@options = {}

		if 'string' == typeof options
			opts.modelName = options

		if 'object' == typeof options
			opts = _.extend opts, options

		@options = _.extend @options, opts

		if not @options.modelName
			error.throw "Model name in Crud instance not exist", "MDLNMNEXST"

		if @options.isNewODM
			@odm = ODM options
		else
			@odm = ODM.singleton

		@odm.pool.reload()

		if not @odm.models[@options.modelName]
			error.throw "Model not exist in pool", "MDLNMNEXSTPOOL"

		@model = @odm.models[@options.modelName]

		return @

	create: (data, callback) ->
		model = new @model data

		model.save callback
	find: () ->
		@model.find.apply @model, arguments
	findOne: () ->
		@model.findOne.apply @model, arguments
	updateOne: (query, updated, fields, options, callback) ->
		if not query or not updated
			if not query
				error.throw "Not passed \"query\" parameter", "QURYNPSSD"
			if not updated
				error.throw "Not passed \"updated\" parameter", "UPDTDNPSSD"

		if 'function' == typeof fields
			callback = fields
			fields = null
			options = {}

		if 'function' == typeof options
			callback = options
			options = {}

		@model.findOne query, fields, options, (err, model)->
			if err
				return callback err

			model = _.extend model, updated

			model.save callback
	removeOne: (query, callback) ->
		@model.findOne query, (err, model) ->
			if err
				return callback err

			model.remove callback
	remove: () ->
		@model.remove.apply @model, arguments

exports = (options) ->
	return new Crud options

exports.Crud = Crud

module.exports = exports
