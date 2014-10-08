
path = require 'path'
fs = require 'fs'

_ = require 'underscore'
should = require 'should'
request = require 'request'

index = require '../../../core/index'

FS = new (getLibrary 'fs')

testedArgs =
	_: []
	bundle: 'test'
	module_express: true
	module_rest: true
	option_express_port: 3003
	options_rest_port: 3008

Loader = {}

bundlePath = path.join pathes.server, 'test', 'loader', 'bundle', 'test.coffee'
modulePath = path.join pathes.server, 'test', 'loader', 'module', 'express.coffee'

writedBundlePath = path.join pathes.app, 'loader', 'bundle', 'test.coffee'
writedModulePath = path.join pathes.app, 'loader', 'module', 'express.coffee'

before (done) ->
	bundleRd = fs.createReadStream(bundlePath)
		.pipe(fs.createWriteStream(writedBundlePath))

	bundleRd.on 'close', () ->
		moduleRD = fs.createReadStream(modulePath)
			.pipe(fs.createWriteStream(writedModulePath))

		moduleRD.on 'close', () ->
			Loader = getLibrary 'loader'
			done()

describe '#Loader.parse', () ->
	it '#Loader should exists', () ->
		should(Loader).exist

	it 'should be parse test bundle', () ->
		should(Loader.bundles.test).exist

	it 'should parse modules modules afte set argv', () ->
		Loader.parseArgs testedArgs
		should(Loader.bundleName).exist
		should(Loader.bundleName).eql 'test'

	it '#Loader.moduleOptions', () ->
		Loader.parseArgs testedArgs
		should(Loader.moduleOptions.express).not.eql undefined
		should(Loader.moduleOptions.express.port).eql testedArgs.option_express_port

	it '#Loader.modules.start should be a function', () ->
		modules = Loader.modules

		_.each modules, (module, key, list) ->
			should(module.start).be.a.Function



after ()->
	fs.unlinkSync writedBundlePath
	fs.unlinkSync writedModulePath
