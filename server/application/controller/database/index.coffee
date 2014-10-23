
Mapper = getLibrary 'core/data/mapper'
Pool = getLibrary 'core/data/mapper/pool'
Crud = getLibrary 'core/data/crud'

MongooseMapper = new Mapper
	db: 'test'
	type: 'Mongoose'
	autoConnect: true

MongoosePool = new Pool
	type: 'Mongoose'
	ctx: MongooseMapper

module.exports = exports = (modelName) ->
	crudOpts =
		modelName: modelName
		ctx: MongooseMapper
		pool: MongoosePool

	userCrud = new Crud 'Mongoose', crudOpts