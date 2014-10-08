
path = require 'path'
fs = require 'fs'

_ = require 'underscore'

error = require './error'

jsExtensions = [
	'.js'
	'.coffee'
	'.json'
]

filterJsFiles = (files) ->
	_.filter files, (item, key, list) ->
		fileExt = path.extname item

		fileExt in jsExtensions

requireJsFile = (dir, file) ->
	fileExt = path.extname file

	if not fileExt in jsExtensions
		return false

	require path.join dir, file

requireJsFiles = (dir, files) ->
	requiredFiles = []

	_.each files, (item, key, list) ->
		if item = requireJsFile dir, item
			requiredFiles.push item

	return requiredFiles
	
readDirJs = (dir, callback) ->
	fs.readdir dir, (err, files) ->
		if err
			return callback err

		callback null, filterJsFiles files

readDirJsSync = (dir) ->
	files = fs.readdirSync dir

	filterJsFiles files

loadDirJs = (dir, callback) ->
	readDirJs dir, (err, files) ->
		if err
			return callback err

		returnedFiles = requireJsFiles dir, files

		callback null, returnedFiles

loadDirJsSync = (dir) ->
	files = readDirJsSync dir
	
	requireJsFiles dir, files


exports = {
	readDirJs
	readDirJsSync
	loadDirJs
	loadDirJsSync
}

module.exports = exports
