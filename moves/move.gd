extends Resource
class_name Move

@export var name: String = ""
@export var type: Type;
@export var power: int = 0
@export var accuracy: int = 0
@export var description: String = ""
@export var target := targetType.SINGLE
@export var attribute := attributeType.DIRECT
@export var effects: Array[Effect] = []
@export var advantage: int
#@export var placeholder: Effects = Effects.EFFECT1

enum targetType {
	SELF, # 1 self
	SINGLE, # Any single
	ENEMIES, # All 2 enemy
	OTHERS, # All 3
	ALL # All 4
}

enum attributeType {
	DIRECT,
	RANGE,
	STATUS,
}

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
	
func getTarget():
	return target
	
func getPower():
	return power
	
func getType():
	return type
	
func getAccuracy():
	return accuracy
	
func getAttribute():
	return attribute
	
func getEffects():
	return effects
