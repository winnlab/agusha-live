
mongoose = require 'mongoose'
should = require 'should'
_ = require 'underscore'

index = require '../../../../../../core/index'

Crud = getLibrary 'data/crud'
Rest = getLibrary 'core/server/rest'

Mapper = getLibrary 'core/data/mapper'
Pool = getLibrary 'core/data/mapper/pool'

settedModel =
	schema:
		name:
			type: String
			required: true
	name: "User"
	options:
		collection: "test"

MongooseMapper = new Mapper
	db: 'test'
	type: 'Mongoose'
	autoConnect: true

MongoosePool = new Pool
	type: 'Mongoose'
	ctx: MongooseMapper

MongoosePool.set settedModel

crudOpts =
	modelName: 'User'
	ctx: MongooseMapper
	pool: MongoosePool

MongooseCrud = new Crud 'Mongoose', crudOpts

restOpts =
	CRUD: MongooseCrud

describe '#Server', ->
	describe '#Rest', () ->
		describe '#Mongoose', ->
			it '.post should be return setted model', (done) ->
				userRest = new Rest 'Mongoose', restOpts

				userRest.post
					name: 'Senin Roman'
				, (err, user) ->
					should(err).be.eql null
					user.name.should.be.eql 'Senin Roman'

					userRest.deleteOne user._id, done

			it '.find should be return array of model', (done) ->
				userRest = new Rest 'Mongoose', restOpts

				userRest.post
					name: 'Senin Roman'
				, (err, user) ->
					should(err).be.eql null
					user.name.should.be.eql 'Senin Roman'

					userRest.find (err, users) ->
						users.should.be.Array

						u = _.findWhere users, name: user.name

						u._id.should.eql user._id
						
						userRest.deleteOne user._id, done

			it '.getOne should be return model', (done) ->
				userRest = new Rest 'Mongoose', restOpts

				userRest.post
					name: 'Senin Roman'
				, (err, user) ->
					should(err).be.eql null
					user.name.should.be.eql 'Senin Roman'

					userRest.getOne user._id, (err, u) ->
						u._id.should.eql user._id
						
						userRest.deleteOne user._id, done

			it '.patch should update prop in model', (done) ->
				userRest = new Rest 'Mongoose', restOpts

				userRest.post
					name: 'Senin Roman'
				, (err, user) ->
					should(err).be.eql null
					user.name.should.be.eql 'Senin Roman'

					userRest.patch user._id, name: 'Roman Senin', (err, u) ->
						u._id.should.eql user._id
						u.name.should.eql 'Roman Senin'

						userRest.deleteOne user._id, done

			it '.put should update prop in model', (done) ->
				userRest = new Rest 'Mongoose', restOpts

				userRest.post
					name: 'Senin Roman'
				, (err, user) ->
					should(err).be.eql null
					user.name.should.be.eql 'Senin Roman'

					userRest.put user._id, name: 'Roman Senin', (err, u) ->
						u._id.should.eql user._id
						u.name.should.eql 'Roman Senin'

						userRest.deleteOne user._id, done

			it '.deleteOne should delete model', (done) ->
				userRest = new Rest 'Mongoose', restOpts

				userRest.post
					name: 'Senin Roman'
				, (err, user) ->
					should(err).be.eql null
					user.name.should.be.eql 'Senin Roman'

					userRest.deleteOne user._id, (err) ->
						should(err).eql null

						userRest.getOne user._id, (err, user) ->
							should(err).eql null
							should(user).eql null

							done()
