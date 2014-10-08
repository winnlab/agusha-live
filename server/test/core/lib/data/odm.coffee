
path = require 'path'
fs = require 'fs'

_ = require 'underscore'
mongoose = require 'mongoose'
should = require 'should'

index = require '../../../../core/index'

ODM = getLibrary 'data/odm'
Pool = getLibrary 'data/pool'

describe '#Data', () ->
	describe '#ODM', () ->
		it 'should be a Function', () ->
			ODM.should.be.instanceof.Function

		describe 'singleton', () ->
			it 'singleton should be exist', () ->
				ODM.singleton.should.be.Object

			it 'singleton should be eql #Pool()', () ->
				ODM.singleton.should.be.eql ODM()

			it 'singleton should be instance of #ODM.ODM', () ->
				ODM.singleton.should.be.instanceof ODM.ODM

		describe 'instance', () ->
			it 'should be instance of mongoose.Mongoose', () ->
				ODM.singleton.should.be.instanceof mongoose.Mongoose

			it 'should have constructor function', () ->
				ODM.singleton.should.have.property('constructor').be.Function

			it 'should have pool object', () ->
				ODM.singleton.should.have.property('pool').be.Object
				ODM.singleton.should.have.property('pool').be
					.instanceof Pool.Pool

			it 'should have instance pool object', () ->
				newODM = ODM
					isNewODM: true

				newODM.should.have.property('pool').be.Object
				pool = newODM.pool
				(pool == ODM.singleton.pool).should.not.ok

			it 'should have createConnURI', () ->
				ODM.singleton.should.have.property('createConnURI').be.Function

			it 'createConnURI should return def string', () ->
				defConnUri = "mongodb://localhost:27017/test"

				uri = ODM.singleton.createConnURI()

				uri.should.eql defConnUri

			it 'createConnURI should return auth string', () ->
				defConnUri = "mongodb://admin:123@localhost:27017/test"
				newODM = ODM
					user: "admin"
					pwd: "123"
					isNewPool: true
					isNewODM: true

				uri = newODM.createConnURI()

				uri.should.eql defConnUri

			it 'connection should be exist', () ->
				ODM.singleton.connection.should.be.exist
				ODM.singleton.connection.should.be.instanceof mongoose.Connection

