extends Resource
class_name Move

@export var name: String = ""
@export var type: String = "";
@export var power: int = 0
@export var accuracy: int = 0
@export var description: String = ""
#@export var effects: Effects = Effects.EFFECT1
#@export var placeholder: Effects = Effects.EFFECT1

func _init(name_val = "", type_val = 0):
	var type_info = Type.new()
	type = type_info.getTypeByValue(type_val)
	name = name_val
	
func getName():
	return name
	
