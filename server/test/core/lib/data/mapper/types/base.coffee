
should = require 'should'

index = require '../../../../../../core/index'

BaseMapper = getLibrary('data/mapper/types/base').Base

describe '#Data', ->
	describe '#Mapper', ->
		describe '#Base', ->
			it 'should be a function', ->
				BaseMapper.should.be.a.Function

			it 'should be have connect function', ->
				base = new BaseMapper

				base.should.have.property 'connect'
				base.connect.should.be.a.Function

			it 'should be have a connectString function', ->
				base = new BaseMapper

				base.should.have.property 'connectString'
				base.connectString.should.be.a.Function

			it 'connectString should return correct connect string', ->
				base = new BaseMapper

				options =
					protocol: 'mongodb'
					hostname: 'localhost'
					port: 27017
					pathname: 'test'

				base.connectString(options).should.be.eql 'mongodb://localhost:27017/test'
