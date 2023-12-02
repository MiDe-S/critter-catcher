extends Resource
class_name Type

@export var name: String
@export var color: String
@export_file("*.png") var image: String

func getColor():
	return color
	
func getIcon():
	return image
