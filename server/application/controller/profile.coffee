
passport = require 'passport'

Router = getLibrary 'server/protos/router'

router = Router()

router.get '/login', (req, res, next) ->
	res.render 'user/login/index'

router.get '/registration', (req, res, next) ->
	res.render 'user/registration/index'

router.get '/profile', (req, res, next) ->
	res.render 'user/profile/index'

router.get '/registration/fb',  passport.authenticate 'facebook',
	scope: ['email', 'publish_actions']

router.get '/registration/vk', passport.authenticate 'vkontakte',
	scope: ['email', 'groups']

router.get '/registration/ok', passport.authenticate 'odnoklassniki',
	scope: ['email']

router.get '/registration/fb/callback', passport.authenticate 'facebook',
	successRedirect: '/profile'
	failureRedirect: '/login'

router.get '/registration/vk/callback', passport.authenticate 'vkontakte',
	successRedirect: '/profile'
	failureRedirect: '/login'

router.get '/registration/ok/callback', passport.authenticate 'ok',
	successRedirect: '/profile'
	failureRedirect: '/login'

module.exports = exports = router
