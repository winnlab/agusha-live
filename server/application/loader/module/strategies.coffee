
passport = require 'passport'

User = getController('database') 'User'

ok = require './strategies/ok'
vk = require './strategies/vk'
fb = require './strategies/fb'

passport.serializeUser (user, done)->
	done null, user.id

passport.deserializeUser (id, none) ->
	User.findOne _id: id, (err, user) ->
		console.log user

module.exports = exports =
	start: () ->
