extends Resource
class_name Move

@export var name: String = ""
@export var type: Type;
@export var power: int = 0
@export var accuracy: int = 0
@export var description: String = ""
#@export var effects: Effects = Effects.EFFECT1
#@export var placeholder: Effects = Effects.EFFECT1

func _init(name_val = "", type_val = 0):
	name = name_val
	
func getName():
	return name
	
func getTypeColor():
	if type != null:
		return type.getColor();
	else:
		return "#000000"
		
func getTypeIcon():
	return type.getIcon();
	
