
Router = getLibrary 'server/protos/router'

router = Router()

router.get '/', (req, res, next) ->
	res.render 'user/main/index'

module.exports = exports = router
