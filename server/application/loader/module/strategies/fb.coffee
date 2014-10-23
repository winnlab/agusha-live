
passport = require 'passport'
FaseBookStrategy = require 'passport-facebook'

Config = getLibrary('config').get 'oauth.fb'
User = getController('database') 'User'

passport.use 'facebook', new FaseBookStrategy
	clientID: Config.Id,
	clientSecret: Config.secret,
	callbackURL: Config.callback
, (accessToken, refreshToken, profile, done) ->
	User.findOne 'socail.fb.id': profile.id, (err, user) ->
		if err
			return done err

		if user
			user.auth_from = 'fb'
			if not user.fb
				user.fb =
					id: profile.id
					access_token: accessToken
					refresh_token: refreshToken
				return user.save done
			return done null, user

		User.create
			email: profile['_json'].email
			profile:
				first_name: profile.name.givenName
				last_name: profile.name.familyName
			active: true
			social:
				reg_from: 'fb'
				fb:
					id: profile.id
					access_token: accessToken
					refresh_token: refreshToken
		, (err, user) ->
			if err
				done err

			done null, user

module.exports = exports = {};

