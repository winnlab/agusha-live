
mongoose = require 'mongoose'
should = require 'should'
_ = require 'underscore'

index = require '../../../../core/index'

Rest = getLibrary 'data/rest'

settedModel =
	schema:
		name:
			type: String
			required: true
	name: "User"
	options:
		collection: "test"

describe '#Data', () ->
	describe '#Rest', () ->
		it '#Rest should be a Object', () ->
			Rest.should.be.instanceof.Object

		describe 'instance', () ->
			it 'Rest should have constructor', () ->
				Rest.should.have.property('constructor').be.Function

			it 'Rest instance should be instanceof Rest', ()->
				userRest = Rest 'User'

				userRest.should.be.instanceof Rest.Rest

			it 'Rest instance should have "http" function', () ->
				userRest = Rest 'User'

				userRest.should.have.property('http').be.Function

			it 'Rest.http should have return function', () ->
				userRest = Rest 'User'

				userRest.http().should.be.a.Function

			it 'Rest should have property "get" function', () ->
				userRest = Rest 'User'

				userRest.should.have.property('get').be.Function

			it 'Rest should have property "post" function', () ->
				userRest = Rest 'User'

				userRest.should.have.property('post').be.Function

			it 'Rest should have property "getOne" function', () ->
				userRest = Rest 'User'

				userRest.should.have.property('getOne').be.Function

			it 'Rest should have property "putOne" function', () ->
				userRest = Rest 'User'

				userRest.should.have.property('putOne').be.Function

			it 'Rest should have property "patchOne" function', () ->
				userRest = Rest 'User'

				userRest.should.have.property('patchOne').be.Function

			it 'Rest should have property "deleteOne" function', () ->
				userRest = Rest 'User'

				userRest.should.have.property('deleteOne').be.Function

			it 'Rest.post should be return setted model', (done) ->
				userRest = Rest 'User'

				userRest.post
					name: 'Senin Roman'
				, (err, user) ->
					should(err).be.eql null
					user.name.should.be.eql 'Senin Roman'

					userRest.deleteOne  name: 'Senin Roman', done

			it 'Rest.deleteOne should be return null object', (done) ->
				userRest = Rest 'User'

				userRest.post
					name: 'Senin Roman'
				, (err, user) ->
					should(err).be.eql null
					user.name.should.be.eql 'Senin Roman'

					userRest.deleteOne  name: 'Senin Roman', done

			it 'Rest.getOne should be return correct document', (done) ->
				userRest = Rest 'User'
				num = Math.random()

				userRest.post
					name: num
				, (err, user) ->
					should(err).be.eql null
					user.name.should.be.eql num

					userRest.getOne name: num, {}, (err, user) ->
						should(err).be.eql null
						user.name.should.be.eql num

						userRest.deleteOne  name: num, done

			it 'Rest.get should be return array of correct document', (done) ->
				userRest = Rest 'User'
				num = Math.random()

				userRest.post
					name: num
				, (err, user) ->
					should(err).be.eql null
					user.name.should.be.eql num

					userRest.get name: num, {}, (err, users) ->
						should(err).be.eql null
						users.should.be.a.Array

						_.each users, (iUser, kUser, list) ->
							iUser.should.have.property '_id'

						userRest.deleteOne  name: num, done
