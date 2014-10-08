
fs = require 'fs'
http = require 'http'

_ = require 'underscore'
should = require 'should'
request = require 'supertest'

index = require '../../../core/index'

Middleware = getLibrary 'server/protos/middleware'
ServerSingle = getLibrary 'server/single'
Router = getLibrary 'server/protos/router'

describe '#Server', () ->
	describe '#Middleware', () ->
		it 'should be a function', () ->
			should(Middleware).be.a.Function

		it 'should be bind to port', (done) ->
			layers = Middleware()

			layers.listen(3000)

			request(layers)
				.get('/')
				.expect(404)
				.end done

		it 'midlleware layer must be implemented', (done) ->
			layers = Middleware()

			layers.use (req, res, next) ->
				req.midlleware = 'exist'
				next()

			layers.use (req, res, next) ->
				res.end req.midlleware

			layers.listen(3001)

			request(layers)
				.get('/')
				.expect(200)
				.expect('exist')
				.end done

		it 'middleware routing', (done) ->
			layers = Middleware()

			layers.use '/', (req, res, next) ->
				req.page = 'index'
				next()

			layers.use '/post', (req, res, next) ->
				req.page = 'post'
				next()

			layers.use (req, res, next) ->
				if req.page
					return res.end req.page

				res.end 'page not exist'

			layers.listen(3002)

			request(layers)
				.get('/')
				.expect(200)
				.expect('index')
				.end (err, res) ->
					if err
						return done err

					request(layers)
						.get('/post')
						.expect(200)
						.expect('post')
						.end done

	describe '#Single', () ->
		it 'should be bind to port', (done)->
			app = ServerSingle()

			app.listen(3003)

			request(app)
				.get('/')
				.expect(404)
				.end done

		it 'should be exist #use', () ->
			app = ServerSingle()

			app.use.should.be.a.Function

		it 'should be exist #listen', () ->
			app = ServerSingle()

			app.listen.should.be.a.Function

		

# describe '#Server.single', () ->
# 	it '#Server; should be a function', () ->
# 		should(Server).be.a.Function

# 	it '#Server.single; single web server should must implemented', (done) ->
# 		options =
# 			app: express
# 			port: 3001

# 		server = new Server options
# 		server.listen()

# 		request(server.app)
# 			.get('/')
# 			.expect(404)
# 			.end done


# 	it '#Server; should be bind server', (done)->
# 		options =
# 			app: express
# 			port: 3002
# 			routes: () ->
# 				@get '/', (req, res) ->
# 					res.send 'Hello world'

# 		server = new Server options
# 		server.listen()

# 		request(server.app)
# 			.get('/')
# 			.expect(200)
# 			.expect('Hello world')
# 			.end done
