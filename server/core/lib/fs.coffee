
fs = require 'fs'
path = require 'path'

class FileSystem
	constructor: (options) ->
		options = options || {}
		@mode = options.mode || 777

	expandDir = (expandPath, mode, callback) ->
		expandPath = path.resolve expandPath
		dirCreatedErr = null

		create = (callbackCreate) ->
			fs.mkdir expandPath, mode, callbackCreate

		parentsCreated = (err) ->
			if err
				return callback err

			create callback

		ensureMode = (err, stat) ->
			if err
				return callback err

			if stat.isFile()
				callback dirCreatedErr

			callback null

		dirCreated = (err) ->
			if not err
				return callback null

			dirCreatedErr = err

			code = err.code

			if code is 'ENOENT'
				return expandDir path.dirname(expandPath), mode, parentsCreated

			if code is 'EEXIST'
				return fs.stat expandPath, ensureMode

			callback err


		create dirCreated

	expandDirSync = (expandPath, mode, callback) ->
		expandPath = path.resolve expandPath
		
		create = () ->
			fs.mkdirSync expandPath, mode

		try
			create()
		catch err
			code = err.code

			if code is 'ENOENT'
				expandDirSync path.dirname expandPath
				return create()

			if code is 'EEXIST'
				stat = fs.statSync expandPath

				if stat.isFile()
					throw err

				return;

			throw err

	emptyDir = (dir, callback) ->
		that = @
		files = null
		filePath = null

		next = () ->
			if not files.length
				return callback null

			file = files.pop()
			filePath = path.join dir, file
			fs.stat filePath, processFile

		itemDeleted = (err) ->
			if err
				return callback err

			next()

		processFile = (err, stat) ->
			if err
				return callback err

			if stat.isFile()
				return fs.unlink filePath, itemDeleted

			return that.removeDir filePath, itemDeleted

		startWalking = (err, fs) ->
			if err
				code = err.code

				if code is 'ENOENT'
					return that.expandDir dir, callback

				return callback err

			files = fs
			next()

		fs.readdir dir, startWalking

	emptyDirSync = (dir, callback) ->
		files = null
		file = null
		filePath = null

		try
			files = fs.readdirSync dir
		catch err
			code = err.code

			if code is 'ENOENT'
				return fs.createDirSync dir

			throw err

		for file in files
			filePath = path.join dir, file
			stat = fs.statSync filePath

			if stat.isFile()
				fs.unlinkSync filePath
			else
				@removeDirSync filePath

	removeDir = (dir, callback) ->
		that = @
		dir = path.resolve dir

		dirEmptied = (err) ->
			if err
				return callback err

			fs.rmdir dir, callback

		dirDeleted = (err) ->
			if not err
				return callback null

			code = err.code

			if code is 'ENOENT'
				return callback null

			if code is 'ENOTEMPTY'
				return that.emptyDir dir, dirEmptied

			callback err

		fs.rmdir dir, dirDeleted

	removeDirSync = (dir, callback) ->
		dir = path.resolve dir

		try
			fs.rmdirSync dir
		catch err
			code = err.code

			if code is 'ENOENT'
				return true

			if code is 'ENOTEMPTY'
				@emptyDirSync dir
				return fs.rmdirSync dir

			throw err

	createFile = (filePath, data, options, callback) ->
		if typeof options is 'function'
			callback = options
			options = {}

		self = @

		filePath = path.resolve filePath

		newFile = (cb) ->
			fs.writeFile filePath, data, options, cb

		fileCreated = (err) ->
			if not err
				return callback null

			if err.code is 'ENOENT'
				return callback err

			self.expandDir path.dirname(filePath), (err) ->
				newFile callback

		newFile fileCreated

	createFileSync = (filePath, data, options) ->
		filePath = path.resolve filePath

		newFile = (callback) ->
			fs.writeFileSync filePath, data, options

		try
			newFile()
		catch err
			code = err.code

			if err.code is not 'ENOENT'
				throw err

			@expandDirSync
			newFile()



	createFile: (filePath, data, options, callback) ->
		if typeof options is 'function'
			callback = options
			options = {}

		createFile.call @, filePath, data, options, callback

	createFileSync: (filePath, data, options) ->
		createFileSync.call @, filePath, data, options

	expandDir: (expandedPath, mode, callback) ->
		if typeof mode is 'function'
			callback = mode
			mode = @mode

		expandDir.call @, expandedPath, mode, callback

	expandDirSync: (expandedPath, mode, callback) ->
		if typeof mode is 'function'
			callback = mode
			mode = @mode

		expandDirSync.call @, expandedPath, mode, callback

	emptyDir: (emptiedPath, callback) ->
		emptyDir.call @, emptiedPath, callback

	emptyDirSync: (emptiedPath, callback) ->
		emptyDirSync.call @, emptiedPath, callback

	removeDir: (removedPath, callback) ->
		removeDir.call @, removedPath, callback

	removeDirSync: (removedPath) ->
		removeDirSync.call @, removedPath


module.exports = exports = FileSystem
