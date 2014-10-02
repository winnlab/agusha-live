
url = require 'url'

_ = require 'underscore'

ODM = getLibrary 'odm'
error = getUtility 'error'

class RestResponse
	constructor: (res) ->
		@res = res

		return @
	success: (data) ->
		@send 502,
			success: true
			data: data
	error: (err) ->
		@send 200,
			success: false
			error: err

	send: (code, data) ->
		@res.setHeader 'Content-Type', 'application/json'

		
		data = JSON.stringify data

		@res.end data

class Rest
	constructor: (options) ->
		options = options || {}

		if not @model = options.model
			error.throw "Not model exist", "RESTMDLNAVLBL"

		@base = options.database ||  'test'

		@odm = ODM.create 
			model: @model
			database: @database
	find: (selector, params) ->
		self = @

		options =
			method: 'find'
			query: selector
			options: params
			callback: (err, entities) ->
				if err
					return self.response.error err

				self.response.success entities

		@odm.query options
	post: (data) ->
		self = @

		callback = (err, entity, na) ->
			if err
				return self.response.error err

			self.response.success entity

		@odm.create data, callback
	get: (id, params) ->
		self = @

		options =
			method: 'findById'
			query: id
			options: params
			callback: (err, entities) ->
				if err
					return self.response.error err

				self.response.success entities

		@odm.query options
	update: (id, data, params) ->
		self = @

		options =
			method: 'findById'
			query: id
			options: params
			callback: (err, entity) ->
				if err
					return self.response.error err

				entity = _.extend entity, data

				entity.save (err, entity, na) ->
					if err
						return self.response.error err

					self.response.success entity

		@odm.query options
	patch: (id, data, params) ->
		props = Object.keys data
		self = @

		options =
			method: findById
			query: id
			fields: props
			options: parama
			callback: (err, entity) ->
				if err
					return self.response.error err

				entity = _.extend entity, data

				entity.save (err, entity, na) ->
					if err
						return self.response.error err

					self.response.success entity

		@odm.query options
	remove: (id) ->
		self = @

		options =
			method: 'remove'
			query:
				_id: id
			callback: (err) ->
				if err
					return self.response.error err

				self.response.success null

		@odm.query options
	http: () ->
		self = @

		(req, res) ->
			self.response = new RestResponse res
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

			# console.log method

			switch method
				when 'get' then self.find query, params
				when 'post' then self.post body, params
				when 'getOne' then self.get id, params
				when 'putOne' then self.update id, body, params
				when 'patchOne' then self.patch id, body, params
				when 'deleteOne' then self.remove id


module.exports = Rest
