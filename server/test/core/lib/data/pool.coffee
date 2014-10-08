
mongoose = require 'mongoose'
should = require 'should'

index = require '../../../../core/index'

Pool = getLibrary 'data/pool'

settedModel =
	schema:
		name:
			type: String
			required: true
	name: "User"
	options:
		collection: "test"

describe '#Data', () ->
	describe '#Pool', () ->
		it '#Pool should be a Object', () ->
			Pool.should.be.instanceof.Object

		describe '#Pool instance', () ->
			it 'Pool should have constructor', () ->
				Pool(mongoose).should.have.property('constructor').be.Function

			it 'Pool should have reload function', ()->
				Pool(mongoose).should.have.property('reload').be.Function

			it 'Pool should have get function', () ->
				Pool(mongoose).should.have.property('get').be.Function

			it 'Pool should have set function', () ->
				Pool(mongoose).should.have.property('set').be.Function

			it '#Pool.set should set model to models ctx', () ->
				model = Pool(mongoose).set settedModel

				model.modelName.should.be.eql settedModel.name
				model.collection.name.should.be.eql settedModel.options.collection

			it '#Pool.get should return eql setted model', () ->
				model = Pool(mongoose).set settedModel

				gettedModel = Pool(mongoose).get settedModel.name
				gettedModel.should.eql model
				gettedModel.should.eql Pool(mongoose).ctx.models[settedModel.name]
