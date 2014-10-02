
_ = require 'underscore'

ClusterServer = getLibrary 'servers/cluster'
SingleServer = getLibrary 'servers/single'

class Server
	constructor: (options) ->
		options = options || {}
		options.port = options.port || 3000

		@options = options
		isCluster = if options.workers then true else false

		if not isCluster
			@type = SingleServer
		else
			@type = ClusterServer

		@instance = new @type @options

		return @instance

module.exports = Server
