
path = require 'path'

basePath = path.resolve path.join __dirname, '../../'
baseServerPath = path.resolve path.join __dirname, '../'
coreBasePath = path.resolve __dirname
appBasePath = path.resolve path.join __dirname, '../application'

pathes = 
	lib:
		core: path.resolve path.join coreBasePath, 'lib'
		application: path.resolve path.join appBasePath, 'lib'
	model:
		core: path.resolve path.join coreBasePath, 'model'
		application: path.resolve path.join appBasePath, 'model'
	utility:
		core: path.resolve path.join coreBasePath, 'utility'
		application: path.resolve path.join appBasePath, 'utility'
	controller:
		core: path.resolve path.join coreBasePath, 'controller'
		application: path.resolve path.join appBasePath, 'controller'
	base:
		core: coreBasePath
		application: appBasePath

validType = (type) ->
	if not type
		type = 'base'

	types = Object.keys pathes

	if type not in types
		type = 'base'

	return type

isGetFromApp = (parentPath) ->
	relateiveParentPath = parentPath.replace "#{basePath}#{path.sep}", ''

	folderExec = (relateiveParentPath.split path.sep)[1]

	if folderExec is 'core'
		false
	else true

getSafeModule = (path) ->
	try
		return require path
	catch err
		return false

getEntityPathes = (type, name) ->
	eName = path.normalize name

	if eName.match 'application|core'
		regexp = new RegExp "application|core(\\#{path.sep})?"
		eName = eName.replace regexp, ''

	ePathes = 
		app: path.resolve path.join pathes[type].application, eName
		core: path.resolve path.join pathes[type].core, eName

getEntity = (type, name) ->
	type = validType type
	ePathes = getEntityPathes type, name
	fromApp = isGetFromApp name

	if fromApp
		if module = getSafeModule ePathes.app
			return module

	return require ePathes.core

getLibrary = (name) ->
	getEntity 'lib', name

getModel = (name) ->
	getEntity 'model', name

getUtility = (name) ->
	getEntity 'utility', name

getController = (name) ->
	name = "application/#{name}"
	getEntity 'controller', name

getApplication = (name) ->
	name = "#{name}"
	getEntity 'base', name

global.basePath = basePath
global.coreBasePath = coreBasePath
global.appBasePath = appBasePath
global.baseServerPath = baseServerPath

global.getLibrary = getLibrary
global.getModel = getModel
global.getUtility = getUtility
global.getController = getController
global.getApplication = getApplication

