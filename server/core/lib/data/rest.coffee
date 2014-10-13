
url = require 'url'

_ = require 'underscore'

Crud = getLibrary 'data/crud'

class RestResponse
	constructor: (res) ->
		@res = res

		return @
	success: (data) ->
		@send 200,
			success: true
			data: data
	error: (err) ->
		@send 200,
			success: false
			err: err
	send: (code, data) ->
		@res.setHeader 'Content-Type', 'application/json'

		@res.send data

class Rest
	constructor: (options, isModified) ->
		@options = {}

		opts =
			modelName: ''
			isModified: true


		if 'string' == typeof options
			opts.modelName = options

		if isModified and 'boolean' == typeof isModified
			opts.isModified = isModified

		if 'object' == typeof options
			opts = _.extend opts, options

		options = _.extend @options, opts

		@crud = Crud options

		return @
	get: (selector, options, callback) ->
		fields = {}

		if options.fields
			keys = options.fields.split ' '
			_.each keys, (key, item, list) ->
				fields[key] = 1

		query = @crud.find selector, fields

		if options.population
			query.populate options.population

		if not options.isModel
			query.lean()

		query.exec callback
	post: (data, callback)->
		model = @crud.create data, callback
	getOne: (selector, options, callback) ->
		fields = {}

		if options.fields
			keys = options.fields.split ' '
			_.each keys, (key, item, list) ->
				fields[key] = 1

		query = @crud.findOne selector, fields

		if options.population
			query.populate options.population

		if not options.isModel
			query.lean()

		query.exec callback
	patchOne: (id, body, params, done)->
		fields = Object.keys(body).join ' '

		@crud.update
			_id: id
		, body, fields, params, done
	putOne: (id, body, params, done) ->
		fields = Object.keys(body).join ' '

		@crud.update
			_id: id
		, body, fields, params, done
	deleteOne: (id, callback)->
		@crud.removeOne id, callback
	http: () ->
		self = @

		(req, res, next) ->
			response = new RestResponse res
			reqUrl = url.parse req.url
			reqMethod = req.method.toLowerCase()
			isOne = reqUrl.path.split('/')

			query = {}
			body = {}

			params = req.query

			if params.selector
				query = params.selector

			if req.body
				body = req.body

			if isOne.length
				id = Array.prototype.slice.call(isOne, 1, 2).pop()

			method = "#{reqMethod}#{if id then 'One' else ''}"

			done = next || (err, data) ->
				if err
					return response.error err

				response.success entities

			switch method
				when 'get' then self.find query, params, done
				when 'getOne' then self.get id, params, done

			if @options.isModified == true
				switch method
					when 'post' then self.post body, params, done
					when 'putOne' then self.update id, body, params, done
					when 'patchOne' then self.patch id, body, params, done
					when 'deleteOne' then self.remove id, done

exports = (options) ->
	return new Rest options

exports.Rest = Rest

module.exports = exports
