extends Resource
class_name Type

enum Type {
	Fire,
	Water,
	Earth,
	Wind
}

func _init():
	#load enum from file
	pass

func getTypeByValue(enum_value):
#	for name in Type.names():
#		if Type[name] == enum_value:
#			return name
	return "???"
	
func getTypeByName(enum_name):
	return Type[enum_name]

func getTypeEnum():
	return Type
