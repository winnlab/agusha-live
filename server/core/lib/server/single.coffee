
Middleware = getLibrary 'server/protos/middleware'
Request = getLibrary 'server/protos/request'
Response = getLibrary 'server/protos/response'

_ = require 'underscore'

SingleServer = () ->
	app = (req, res, next) ->
		req.res = res
		res.res = req

		req.__proto__ = Request
		res.__proto__ = Response

		app.handle req, res, next

	app.stack = []
	app.route = '/'

	_.extend app, Middleware.proto

	return app

module.exports = SingleServer
