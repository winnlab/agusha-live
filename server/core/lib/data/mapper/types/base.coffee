
url = require 'url'

_ = require 'underscore'

class BaseMapper
	constructor: (options) ->
		options = options || {}

		@connection = @connect.apply @, @connectString(options)
	connect: () ->
	connectString: (options) ->
		opts = 
			slashes: true

		options = _.extend opts, options

		url.format options

exports.Base = BaseMapper

module.exports = exports
