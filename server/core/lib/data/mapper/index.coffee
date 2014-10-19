
path = require 'path'
join = path.join

_ = require 'underscore'

fs = getLibrary 'core/fs'
string = getUtility 'core/string'

class Mapper
	constructor: (options) ->
		type = 'Base'
		options = options || {}

		@preload()

		return new @types[type] options
	preload: () ->
		self = @
		self.types = {}

		pathToMappers = join pathes.core, 'lib/data/mapper', 'types'

		files = fs.readDirJsSync pathToMappers

		_.each files, (file, key, list) ->
			name = path.basename file, path.extname file
			mapperKey = string.capitalize name

			self.types[mapperKey] = require(join(pathToMappers, name))[mapperKey]

		return @

exports = Mapper

module.exports = exports
