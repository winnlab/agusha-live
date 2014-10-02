
path = require 'path'

resolveJoin = () ->
	args = Array.prototype.slice.call arguments, 0

	path.resolve path.join.apply path, args

module.exports =
	resolveJoin: resolveJoin
