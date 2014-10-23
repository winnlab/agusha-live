
passport = require 'passport'
OkStrategy = require('passport-odnoklassniki').Strategy

Config = getLibrary('config').get 'oauth.ok'
User = getController('database') 'User'

passport.use 'odnoklassniki', new OkStrategy
	clientID: Config.Id,
	clientPublic: Config.public
	clientSecret: Config.secret,
	callbackURL: Config.callback
, (accessToken, refreshToken, profile, done) ->
	User.findOne 'socail.fb.id': profile.id, (err, user) ->
		if err
			return done err

		if user
			return done null, user

		User.create
			social:
				reg_from: 'ok'
				fb:
					id: profile.id
					access_token: accessToken
					refresh_token: refresh_token
		, (err, user) ->
			if err
				done err

			done null, user

module.exports = exports = {};
