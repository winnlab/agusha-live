
capitalize = (string) ->
	if spaceMatches = string.match /(\s|\S)/g
		string = string.replace /(\s|_)/g, '-'

	string.replace /(?:^|\s)\S/g, (a) ->
		a.toUpperCase()

strip_tags = (str) ->
	str.replace /<\/?[^>]+>/g, ' '

title_case = (str) ->
	first = str.charAt(0).toUpperCase()
	rest = (str.substr 1, str.length - 1).toLowerCase()
	
	first + rest

escape = (text) ->
	text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&')

exports.capitalize = capitalize
exports.strip_tags = strip_tags
exports.title_case = title_case
exports.escape = escape

module.exports = exports
