extends Resource
class_name Type

@export var name: String
@export var color: String
@export_file("*.png") var image: String

func getColor() -> String:
	return color
	
func getIcon() -> String:
	return image

func getName() -> String:
	return name
