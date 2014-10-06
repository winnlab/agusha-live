
_ = require 'underscore'
connect_proto = require 'connect/lib/proto'

###
	Forked from https://github.com/senchalabs/connect/blob/master/lib/connect.js
###

Middleware = () ->
	app = (req, res, next) ->
		app.handle req, res, next

	app.stack = []
	app.route = '/'

	_.extend app, connect_proto

	return app

Middleware.proto = connect_proto

module.exports = exports = Middleware
