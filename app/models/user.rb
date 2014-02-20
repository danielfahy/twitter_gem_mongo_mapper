class User
	include MongoMapper::Document
	# keys
	key :name, String, :required => true

end