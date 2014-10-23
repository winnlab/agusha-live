
fromOk = (req, res, next) ->
	if not req.user
		return next()

	user = req.user

	if user.social.reg_from is 'ok'
		if not user.email
			return res.redirect '/registartion/ok/email' 

	next()
