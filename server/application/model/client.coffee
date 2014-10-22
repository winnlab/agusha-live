
Validate = getUtility 'validate'

schema = 
	email:
		type: String
		trim: true
		unique: true
		sparse: true
		validate: Validate.email
	created_at:
		type: Date
		default: Date.now
	activated_at:
		type: Date
	active:
		type: Boolean
		default: false
	password:
		type: String
	profile:
		filling:
			type: Number
		first_name:
			type: String
			trim: true
		last_name:
			type: String
			trim: true
	image:
		type: String
	social:
		vk:
			id:
				type: String
				unique: true
				sparse: true
			access_token:
				type: String
			refresh_token:
				type: String
		fb:
			id:
				type: String
				unique: true
				sparse: true
			access_token:
				type: String
			refresh_token:
				type: String
		ok:
			id:
				type: String
				unique: true
				sparse: true
			access_token:
				type: String
			refresh_token:
				type: String

module.exports = exports =
	schema: schema
	name: "User"
	options:
		collection: 'users'