
ClusterServer = getLibrary 'server/cluster'
SingleServer = getLibrary 'server/single'

Server = (options) ->
	options = options || {}

	if options.workers
		throw new Error 'Clustering is not working in this version'
		return ClusterServer options

	return SingleServer()

module.exports = Server
