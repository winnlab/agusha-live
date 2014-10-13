
path = require 'path'
fs = require 'fs'

_ = require 'underscore'
mongoose = require 'mongoose'
should = require 'should'

index = require '../../../../core/index'

Pool = getLibrary 'data/pool'
ODM = getLibrary 'data/odm'
Crud = getLibrary('data/crud')

settedModel =
	schema:
		name:
			type: String
			required: true
	name: "User" 
	options:
		collection: "test"

ODM.singleton.pool.set settedModel

describe '#Data', () ->
	describe '#Crud', ()->
		it 'should be a Function', () ->
			Crud.should.be.instanceof.Function

		describe 'instance', () ->
			it 'should be instance of ODM', () ->
				userCrud = Crud 'User'

				userCrud.odm.should.be.instanceof ODM.ODM

			it 'should be instance of Crud', () ->
				userCrud = Crud 'User'

				userCrud.should.be.instanceof Crud.Crud

			it 'should be have property pool', () ->
				userCrud = Crud 'User'

				userCrud.odm.should.be.have.property 'pool'

			it 'should be exist options.modelName', ()->
				userCrud = Crud 'User'

				userCrud.options.modelName.should.eql 'User'

		describe 'CRUD', () ->
			it 'should be have "create" function', ()->
				userCrud = Crud 'User'

				userCrud.should.be.have.property('create').be.a.Function

			it 'should be have "findOne" function', ()->
				userCrud = Crud 'User'

				userCrud.should.be.have.property('findOne').be.a.Function

			it 'should be have "updateOne" function', ()->
				userCrud = Crud 'User'

				userCrud.should.be.have.property('updateOne').be.a.Function

			it 'should be have "removeOne" function', ()->
				userCrud = Crud 'User'

				userCrud.should.be.have.property('removeOne').be.a.Function

			it 'should be have "find" function', ()->
				userCrud = Crud 'User'

				userCrud.should.be.have.property('find').be.a.Function

			it 'should be have "remove" function', ()->
				userCrud = Crud 'User'

				userCrud.should.be.have.property('remove').be.a.Function
