extends Resource
class_name Move

@export var name: String = ""
@export var type: Type;
@export var power: int = 0
@export_range(0, 100) var accuracy: int = 0
@export var description: String = ""
@export var target := targetType.SINGLE
@export var attribute := attributeType.DIRECT
@export var effects: Array[Effect] = []
@export_range(-5, 5) var advantage: int = 0
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

func _init(name_val := "") -> void:
	name = name_val
	
func getName() -> String:
	return name
	
func getTypeColor() -> String:
	if type != null:
		return type.getColor();
	else:
		return "#000000"
		
func getTypeIcon() -> String:
	return type.getIcon();
	
func getTarget() -> targetType:
	return target
	
func getPower() -> int:
	return power
	
func getType() -> Type:
	return type
	
func getAccuracy() -> int:
	return accuracy
	
func getAttribute() -> attributeType:
	return attribute
	
func getEffects() -> Array[Effect]:
	return effects
