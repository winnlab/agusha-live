
fs = require 'fs'
path = require 'path'

index = require '../../../core/index'
should = require 'should'
_ = require 'underscore'

fileHelper = getUtility 'file'

pathToDir = path.join pathes.server, 'test', 'files'
extensions = ['.js', '.coffee', '.json']

describe '#Utility', () ->
	describe '#file', () ->
		it 'should be preload file list', (done) ->
			fileHelper.readDirJs pathToDir, (err, files) ->
				_.each files, (item, key, list) ->
					fileExt = path.extname item

					isJs = _.contains extensions, fileExt

					isJs.should.be.ok

				done()

		it 'should be sync preload file list', () ->
			files = fileHelper.readDirJsSync pathToDir

			_.each files, (item, key, list) ->
				fileExt = path.extname item
				isContain = _.contains extensions, fileExt

				isContain.should.be.ok

		it 'should be load files', (done) ->
			fileHelper.loadDirJs pathToDir, (err, files) ->
				fileHelper.readDirJs pathToDir, (err, readedFiles) ->
					_.every readedFiles, (item, key, list) ->
						filePath = path.join pathToDir, item
						requiredFile = require filePath

						isContain = _.contains files, requiredFile

						isContain.should.be.ok


					done()

		it 'shoud be sync load files', () ->
			files = fileHelper.loadDirJsSync pathToDir
			readedFiles = fileHelper.readDirJsSync pathToDir

			_.every readedFiles, (item, key, list) ->
				filePath = path.join pathToDir, item
				requiredFile = require filePath

				isContain = _.contains files, requiredFile

				isContain.should.be.ok
