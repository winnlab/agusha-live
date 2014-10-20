
find = (query, options, callback) ->
	if 'function' is typeof query
		callback = query
		query = {}
		options = {}

	if 'function' is typeof options
		callback = options
		options = {}

	fields = {}

	if options.fields
		keys = options.fields.split ' '
		_.each keys, (key, item, list) ->
			fields[key] = 1

	query = @CRUD.find query, fields

	if options.populate
		query.populate options.populate

	query.exec callback

post = (body, params, callback) ->
	if 'function' is typeof params
		callback = params
		params = {}

	@CRUD.create body, callback

getOne = (id, options, callback) ->
	if 'function' is typeof query
		callback = query
		query = {}
		options = {}

	if 'function' is typeof options
		callback = options
		options = {}

	fields = {}

	if options.fields
		keys = options.fields.split ' '
		_.each keys, (key, item, list) ->
			fields[key] = 1

	query = {}
	query[@idProp || '_id'] = id

	query = @CRUD.findOne query, fields

	if options.population
		query.populate options.population

	if not options.isModel
		query.lean()

	query.exec callback

patch = (id, body, params, callback)->
	if 'function' is typeof params
		callback = params
		params = {}

	fields = Object.keys(body).join ' '

	query = {}
	query[@idProp || '_id'] = id

	@CRUD.updateOne query, body, fields, params, callback

put = patch

deleteOne = (id, callback)->
	query = {}
	query[@idProp || '_id'] = id
 
	@CRUD.removeOne query, callback

filter = {
	find
	post
	getOne
	patch
	put
	deleteOne
}

exports.Mongoose = filter

module.exports = exports
