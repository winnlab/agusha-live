
fs = require 'fs'
path = require 'path'

index = require '../../core/index'
should = require 'should'

FS = new (getLibrary 'core/fs')

dateTime = new Date().getTime()

describe 'Entity path static variables', () ->
	it '#entityPath shoud be exists', () ->
		entityPath

	it '#Entity shoud be required', () ->
		try
			require entityPath
		catch err
			throw err

describe '#getLibrary', () ->
	it '#getLibrary should be exist', ()->
		getLibrary

	it 'should be throw exepcion', () ->
		libName ="#{dateTime}"

		try
			if getLibrary libName
				throw new Error "Exist library #{libName} or failed work in #getLibrary"

	it 'should be required from core', () ->
		requiredLib = require path.join coreBasePath, "lib/fs"
		libName = "core/fs"

		try
			lib = getLibrary libName
		catch err
			throw err

		if lib is not requiredLib
			throw new Error "#getLibrary required not right library"

	it 'should be required from application', () ->
		testedAppLib = path.resolve path.join appBasePath, '/lib/tested.coffee'

		fs.writeFileSync testedAppLib, ''
		requiredLib = require testedAppLib

		libName = 'application/tested'

		try
			lib = getLibrary libName
		catch err
			fs.unlinkSync testedAppLib
			throw err

		if lib is not requiredLib
			fs.unlinkSync testedAppLib
			throw new Error "#getLibrary required not right library"

		fs.unlinkSync testedAppLib

describe '#getModel', () ->
	testedCoreModel = path.resolve path.join coreBasePath, '/model/tested.coffee'
	testedAppModel = path.resolve path.join appBasePath, '/model/tested.coffee'

	it '#getModel should be exist', ()->
		getModel

	it 'should be throw exepcion', () ->
		modelName ="#{dateTime}"

		try
			if getModel modelName
				throw new Error "Exist model #{modelName} or failed work in #getModel"

	it 'should be required from core', () ->
		fs.writeFileSync testedCoreModel, ''

		modelName = "tested"
		requiredModel = require path.join coreBasePath, "model/tested"

		try
			model = getModel modelName
		catch err
			fs.unlinkSync testedCoreModel
			throw err

		if model is not requiredModel
			fs.unlinkSync testedCoreModel
			throw new Error "#getLibrary required not right library"

		fs.unlinkSync testedCoreModel

	it 'should be required from application', () ->
		fs.writeFileSync testedAppModel, ''
		requiredUtility = require testedAppModel

		modelName = 'application/tested'

		try
			model = getModel modelName
		catch err
			fs.unlinkSync testedAppModel
			throw err

		if model is not requiredUtility
			fs.unlinkSync testedAppModel
			throw new Error "#getLibrary required not right library"

		fs.unlinkSync testedAppModel

describe '#getUtility', () ->
	testedCoreUtility = path.resolve path.join coreBasePath, '/utility/tested.coffee'
	testedAppUtility = path.resolve path.join appBasePath, '/utility/tested.coffee'

	it '#getUtility should be exist', ()->
		getUtility

	it 'should be throw exepcion', () ->
		utilityName ="#{dateTime}"

		try
			utility = getUtility utilityName

		if utility
			throw new Error "Exist model #{modelName} or failed work in #getUtility"

	it 'should be required from core', () ->
		fs.writeFileSync testedCoreUtility, ''

		utilityName = "tested"
		requiredUtility = require path.join coreBasePath, "utility/tested"

		try
			utility = getUtility utilityName
		catch err
			fs.unlinkSync testedCoreUtility
			throw err

		if utility is not requiredUtility
			fs.unlinkSync testedCoreUtility
			throw new Error "#getLibrary required not right library"

		fs.unlinkSync testedCoreUtility

	it 'should be required from application', () ->
		fs.writeFileSync testedAppUtility, ''
		requiredUtility = require testedAppUtility

		utilityName = 'application/tested'

		try
			utility = getUtility utilityName
		catch err
			fs.unlinkSync testedAppUtility
			throw err

		if utility is not requiredUtility
			fs.unlinkSync testedAppUtility
			throw new Error "#getLibrary required not right library"

		fs.unlinkSync testedAppUtility

describe '#getController', () ->
	testedAppController = path.resolve path.join appBasePath, '/controller/tested.coffee'

	it '#getController should be exist', ()->
		getController

	it 'should be throw exepcion', () ->
		controllerName ="#{dateTime}"

		try
			controller = getController controllerName

		if controller
			throw new Error "Exist model #{modelName} or failed work in #getUtility"

	it 'should be required from application', () ->
		fs.writeFileSync testedAppController, ''
		requiredController = require testedAppController

		controllerName = 'tested'

		try
			controller = getController controllerName
		catch err
			fs.unlinkSync testedAppController
			throw err

		if controller is not requiredController
			fs.unlinkSync testedAppController
			throw new Error "#getLibrary required not right library"

		fs.unlinkSync testedAppController

describe '#getApplication', () ->
	testedAppEntity = path.resolve path.join appBasePath, '/tested.coffee'

	it '#getApplication should be exist', ()->
		getApplication

	it 'should be throw exepcion', () ->
		entityName ="#{dateTime}"

		try
			entity = getApplication controllerName

		if entity
			throw new Error "Exist model #{modelName} or failed work in #getUtility"

	it 'should be required from application', () ->
		fs.writeFileSync testedAppEntity, ''
		requiredEntity= require testedAppEntity

		entityName = 'tested'

		try
			entity = getApplication entityName
		catch err
			fs.unlinkSync testedAppEntity
			throw err

		if entity is not requiredEntity
			fs.unlinkSync testedAppEntity
			throw new Error "#getLibrary required not right library"

		fs.unlinkSync testedAppEntity
