
path = require 'path'

_ = require 'underscore'
mongoose = require 'mongoose'

Config = getLibrary 'config'

dbOpts = (Config.get 'database') || {}

Pool = getLibrary 'data/pool'
error = getUtility 'error'

class ODM extends mongoose.Mongoose
	constructor: (options) ->
		super

		def_opts =
			host: dbOpts.host || "localhost"
			port: dbOpts.port || "27017"
			base: dbOpts.base || "test"
			newConn: false
			server:
				poolSize: dbOpts.base || 50

		@options = _.extend def_opts, options

		@pool = Pool @

		@pool.reload()

		@connect @createConnURI(), @options

		return @
	createConnURI: () ->
		userString = ""
		if @options.user and @options.pwd
			userString = "#{@options.user}:#{@options.pwd}@"

		"mongodb://#{userString}#{@options.host}:#{@options.port}"+
			"/#{@options.base}"

class Singleton
	instance = null

	@get = (options) ->
		options = options || {}

		if options.isNewODM
			return new ODM options

		instance ?= new ODM options

exports = Singleton.get
exports.ODM = ODM
exports.singleton = Singleton.get()

module.exports = exports
