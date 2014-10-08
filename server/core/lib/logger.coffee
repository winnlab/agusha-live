
fs = require 'fs'
path = require 'path'

moment = require 'moment'
winston = require 'winston'
_ = require 'underscore'

pathUtility = getUtility 'path'

class Logger
	transports =
		file:
			name: 'File'
			options:
				level: 'debug'
				silent: false
				colorize: false
				timestamp: true
				json: true
			afterInit: (options) ->
				initDir options.filename
		console:
			name: 'Console'
			options:
				level: 'debug'
				silent: false
				colorize: true
				timestamp: true

	FS = new (getLibrary 'core/fs')

	avalibaleTransports = Object.keys transports

	getTransportName = (transport) ->
		if transport instanceof Object
			Object.keys(transport).pop()
		else if typeof transport is 'string'
			transport
		else
			throw new Error "Logger is not initialized"

	setTransport = (transport) ->
		name = getTransportName transport

		if not t = transports[name]
			throw new Error "#{name} not exist in transports"

		if transport.options
			t.options = _.extend transport.options, t.options

		@instance.add winston.transports[t.name], t.options

		if t.afterInit
			t.afterInit t.options

	setTransports = (transports) ->
		self = @
		if not transports
			transports = []

		if not transports.length
			transports.push 'console'

		transports.forEach (item, key)->
			setTransport.call self, item

	initDir = (filename) ->
		FS.expandDirSync path.dirname filename

		exist = fs.existsSync filename
		
		if not exist
			fs.writeFileSync filename, ''

	validateTransport = (transport) ->
		item = getTransportName transport

		if item not in avalibaleTransports
			throw new Error "#{name} not exist in transports"

	validateTransports = (transports) ->
		if not transports instanceof Array
			transport = transports
			return validateTransport transport

		_.each transports, (item, key, list) ->
			validateTransport item

	validateName = (name) ->
		if name
			return true

		throw new Error "\"name\" option is not exist"

	validateOptions = (options) ->
		validateName options.name
		validateTransports options.transports

	setName = (name) ->
		@name = name

	setLogName = () ->
		@logName = moment().format 'MM-DD-YYYY'
		logPath = pathUtility.resolve pathes.server, 'logs', @name, "#{@logName}.log"
		transports.file.options.filename = logPath

	setInitDate = () ->
		@initDate = moment().format 'MM-DD-YYYY'

	setDate = (date) ->
		date = (moment(date)||moment()).format 'MM-DD-YYYY'
		@date = date

	setProperties = (name) ->
		setName.call @, name
		setLogName.call @
		setInitDate.call @
		setDate.call @

	setFileProperties = () ->
		self = @

		@file =
			baseDir: pathUtility.resolve pathes.server, "logs/#{self.name}"
			path: pathUtility.resolve pathes.server, "logs/#{self.name}/#{self.logName}"

	createWinstonInstance = () ->
		@instance = new (winston.Logger)

	init = (options) ->
		createWinstonInstance.call @
		validateOptions options
		setProperties.call @, options.name
		setFileProperties.call @

	constructor: (options) ->
		init.call @, _.clone options || {}

	setName: (name) ->
		setName.call @, name

	setDate: (date) ->
		setDate.call @, date

	setTransport: (transport) ->
		if transport instanceof Array
			return setTransports.call @, transport

		setTransport.call @, transport

	log: (level, data...) ->
		date = moment().format 'MM-DD-YYYY'

		if date is not @date
			setLogName.call @

		@instance.log.apply @instance, [level, data...]

	info: ()->
		@log.apply @, Array.prototype.slice.call arguments, 0

module.exports = exports = Logger
