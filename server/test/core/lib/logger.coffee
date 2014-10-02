
fs = require 'fs'
path = require 'path'

should = require 'should'
moment = require 'moment'
winston = require 'winston'

index = require '../../../core/index'

FS = new (getLibrary 'core/fs')
pathUtility = getUtility 'path'

describe '#Logger constructor', () ->
	it 'should be throw exception without \"name\" options', () ->
		try
			logger = new (getLibrary 'core/logger')

		if logger
			throw new Error "Validate name options work is wrong"

	it 'should be throw exception without wrong \"transport\" options', () ->
		try
			logger = new (getLibrary 'core/logger')
				name: 'wrongTransport'
				transports: [
					'mongodb'
				]

		if logger
			throw new Error "Transport validate options work is wrong"

	it '#Logger.name should be exist', () ->
		logger = new (getLibrary 'core/logger')
			name: 'wrongTransport'

		if not logger.name
			throw new Error "#Logger.name not exist"

describe '#Logger properties and functions', () ->
	it '#Logger.setName should be a function', () ->
		logger = new (getLibrary 'core/logger')
			name: 'logger.setName'

		(logger).should.have.property 'setName'
		(logger.setName).should.be.a.Function

	it 'Callee #Logger.setName should be set a new name', () ->
		newName = 'logger.setName2'

		logger = new (getLibrary 'core/logger')
			name: 'logger.setName'

		logger.setName newName

		logger.name.should.equal newName

	it '#Logger.setDate should be a function', () ->
		logger = new (getLibrary 'core/logger')
			name: 'logger.setDate'

		(logger).should.have.property 'setDate'
		(logger.setDate).should.be.a.Function

	it 'Callee #Logger.setDate should be set a new date', () ->
		# Date("2014-09-17T00:00:00.000Z")
		newDate = moment('2014-09-17').format "MM-DD-YYYY"

		logger = new (getLibrary 'core/logger')
			name: 'logger.setDate'

		logger.setDate newDate

		logger.date.should.equal newDate

describe '#Logger.transports', () ->
	it 'set file transport', ()->
		localLogger = new (getLibrary 'core/logger')
			name: 'unitTest'

		pathToLogDir = pathUtility.resolveJoin baseServerPath, 'logs', localLogger.name

		transports = ['file']

		try
			localLogger.setTransport transports
		catch err
			throw err

		stat = fs.statSync path.join pathToLogDir, "#{localLogger.logName}.log"

		if not stat
			throw new Error "Log not exists in #{pathToLogDir}"

		FS.removeDirSync pathUtility.resolveJoin baseServerPath, 'logs', localLogger.name

describe '#Logger.log', () ->
	it '#Logger.log should existsing', () ->
		localLogger = new (getLibrary 'core/logger')
			name: 'unitTest'

		should(localLogger.log).be.a.function

	it 'After #Logger.log callee, log file should not exist', () ->
		localLogger = new (getLibrary 'core/logger')
			name: 'unitTestThrow'

		localLogger.log 'debug', 'test data'

		logDir = path.resolve path.join baseServerPath, "logs/#{localLogger.name}"

		try
			fs.statSync logDir
		catch err
			FS.removeDirSync path.resolve path.join baseServerPath, "logs/#{localLogger.name}"
			return true

		FS.removeDirSync path.resolve path.join baseServerPath, "logs/#{localLogger.name}"
		throw new Error "logFile exist without File transport"

	# it 'After callee log method, should exist log file', () ->
	# 	localLogger = new (getLibrary 'core/logger')
	# 		name: 'unitTest1232'

	# 	localLogger.setTransport ['file']

	# 	localLogger.log 'debug', 'test data filetest'

	# 	logDir = path.join baseServerPath, "logs/#{localLogger.name}"
	# 	logName = "#{localLogger.logName}.log"
	# 	logFile = path.join logDir, "#{logName}"

	# 	try
	# 		stat = fs.statSync logFile
	# 	catch err
	# 		code = err.code

	# 		throw err

	# 	localLogger.instance.remove winston.transports.File

	# 	fs.rmdirSync logDir


describe '#Logger functions', () ->
	it 'should be exists info functions', () ->
		localLogger = new (getLibrary 'core/logger')
			name: 'unitTest'

		should(localLogger).have.property 'info'
		should(localLogger.info).be.a.function

# 	it 'should be exists debug functions', () ->
# 		localLogger = new (getLibrary 'core/logger')
# 			name: 'unitTest'

# 		should(localLogger.debug).be.a.function

# 	it 'should be exists warn functions', () ->
# 		localLogger = new (getLibrary 'core/logger')
# 			name: 'unitTest'

# 		should(localLogger.warn).be.a.function

# 	it 'should be exists silly functions', () ->
# 		localLogger = new (getLibrary 'core/logger')
# 			name: 'unitTest'
# 		should(localLogger).have.property 'silly'
# 		should(localLogger.silly).be.a.function

# 	it 'should be exists verbose functions', () ->
# 		localLogger = new (getLibrary 'core/logger')
# 			name: 'unitTest'

# 		should(localLogger.verbose).be.a.function

# 	it 'should be exists error functions', () ->
# 		localLogger = new (getLibrary 'core/logger')
# 			name: 'unitTest'

# 		should(localLogger.error).be.a.function
