
fs = require 'fs'
path = require 'path'

index = require '../../../core/index'
should = require 'should'

FS = new (getLibrary 'core/fs')

getSegment = (p, n) ->
	if not n
		n = 0

	Array.prototype.slice
		.call(p.split(path.sep), n, n+1)
		.pop()

describe '#FS instance creating', () ->
	it 'mode should be as  default mode', () ->
		testedMode = 777
		localFS = new (getLibrary 'core/fs')

		(localFS.mode).should.be.exactly testedMode

	it 'mode should be as options.mode', () ->
		testedMode = 555
		localFS = new (getLibrary 'core/fs')
			mode: testedMode

		(localFS.mode).should.be.exactly testedMode

describe '#FS creating file', () ->
	baseDir = basePath
	fileName = "nameFile"
	dataFile = "Roman"
	creatingFile = path.resolve path.join baseDir, fileName

	it '#FS.createFile; file should be exist', (done) ->
		FS.createFile creatingFile, dataFile, (err) ->
			should(err).eql null

			fs.stat creatingFile, (err, stat) ->
				should(err).eql null
				should(stat.isFile()).ok

				fs.unlink creatingFile, (err) ->
					should(err).eql null
					done()

	it '#FS.createFileSync; file should be exist', () ->
		FS.createFileSync creatingFile, dataFile

		stat = fs.statSync creatingFile
		should(stat.isFile()).ok

		fs.unlinkSync creatingFile


describe '#FS expand directory', () ->
	baseDir = basePath
	relDir = path.normalize "/level1/level2/level3"
	expandDir = path.resolve path.join baseDir, relDir
	removedPath = path.resolve path.join baseDir, getSegment(relDir, 1)

	it '#expandDir; directory should be exist', (done) ->
		FS.expandDir expandDir, (err) ->
			if err
				throw err

			fs.stat expandDir, (err, stat) ->
				if err
					throw err

				if not stat.isDirectory()
					throw new Error "#{expandDir} is not directory"

				FS.removeDir removedPath, done

	it '#expandDirSync; directory should be exist', () ->

		FS.expandDirSync expandDir

		stat = fs.statSync expandDir

		if not stat.isDirectory()
			throw new Error "#{relDir} is not directory"

		FS.removeDirSync removedPath

describe '#FS empty directory', () ->
	baseDir = basePath
	relDir = path.normalize "/level1/level2/level3"
	expandDir = path.resolve path.join baseDir, relDir
	emptiedPath = path.resolve path.join baseDir, getSegment(relDir, 1)

	it '#emptyDir; directory should be empty', (done) ->
		FS.expandDir expandDir, (err) ->
			if err
				throw err

			FS.emptyDir emptiedPath, (err) ->
				if err
					throw err

				fs.readdir emptiedPath, (err, files) ->
					if err
						throw err

					if files.length
						throw new Error "#emptyDir is failed work"

					FS.removeDir emptiedPath, done

	it '#emptyDirSync; directory should be empty', () ->
		FS.expandDirSync expandDir

		FS.emptyDirSync emptiedPath

		files = fs.readdirSync emptiedPath

		if files.length
			throw new Error "#emptyDir is failed work"

		FS.removeDirSync emptiedPath

describe '#FS remove directory', () ->
	baseDir = basePath
	relDir = path.normalize "/level1"
	expandDir = path.resolve path.join baseDir, relDir
	removedPath = path.resolve path.join baseDir, getSegment(relDir, 1)

	it '#removeDir; directory should be not exist', (done) ->
		FS.expandDir expandDir, (err) ->
			if err
				throw err

			FS.removeDir removedPath, (err) ->
				fs.stat expandDir, (err, stat) ->
					if err
						code = err.code

						if code is 'ENOENT'
							return done()
					throw new Error "#{expandDir} is exist after removeing()"

	it '#removeDirSync; directory should be not exist', () ->
		FS.expandDirSync expandDir
		FS.removeDirSync removedPath

		try
			fs.statSync expandDir
		catch err
			code = err.code

			if code is 'ENOENT'
				return true

		throw new Error "#{expandDir} exist after removed"
