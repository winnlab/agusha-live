
path = require 'path'
join = path.join

serveStatic = require 'serve-static'
passport = require 'passport'

Server = getLibrary 'server'
Logger = getLibrary 'logger'
View = getLibrary 'view'

MainController = getController 'main'
ProfileController = getController 'profile'


logger = new Logger.Logger
	transports: [
		new Logger.transports.Console
	]

server = new Server

server.set 'view engine', 'jade'
server.set 'views', join pathes.base, 'static/views'
server.use '/views', View.compiler()
server.use '/js', serveStatic join pathes.base, 'static/js'
server.use '/css', serveStatic join pathes.base, 'static/css'
server.use '/img', serveStatic join pathes.base, 'static/img'
server.use '/', passport.initialize()
server.use '/', passport.session()
server.use '/', ProfileController
server.use '/', MainController

module.exports = exports =
	start: (options) ->
		server.listen options.port, ->
			logger.info "Serving at http://localhost:#{options.port}/"

