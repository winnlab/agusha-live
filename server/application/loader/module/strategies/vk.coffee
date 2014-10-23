
request = require 'request'

passport = require 'passport'
VkontakteStrategy = require('passport-vkontakte').Strategy

Config = getLibrary('config').get 'oauth.vk'
User = getController('database') 'User'

passport.use 'vkontakte', new VkontakteStrategy
	clientID: Config.Id,
	clientSecret: Config.secret,
	callbackURL: Config.callback
, (accessToken, refreshToken, params, profile, done) ->
	User.findOne 'socail.vk.id': profile.id, (err, user) ->
		if err
			return done err

		if user
			user.auth_from = 'vk'
			if not user.vk
				user.vk =
					id: profile.id
					access_token: accessToken
					refresh_token: refreshToken
				return user.save done

			return done null, user

		User.create
			email: params.email.toLowercase()
			active: true
			social:
				reg_from: 'vk'
				vk:
					id: profile.id
					access_token: accessToken
					refresh_token: refreshToken
		, (err, user) ->
			if err
				return done err

			return done null, user

module.exports = exports = {};

