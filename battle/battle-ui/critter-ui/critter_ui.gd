extends Node2D
class_name CritterUI

# Need to be added to use the HealthBar2D
signal health_changed

var maxHealth := 100.0
var health := 100.0
var _offset: Vector2 = Vector2(0, -100)


func _ready() -> void:
	pass

func initialize(nameInput: String, levelInput: int, maxHealthInput: float, sigName: String) -> void:
	maxHealth = maxHealthInput
	health = maxHealth
	
	$Name.text = nameInput
	$Level.text = "Lvl: " + str(levelInput)
	$HealthBar2D.initialize("health_changed", health)
	$HealthBar2D.set_max(maxHealth)
	set_global_position(get_parent().position + _offset)
	
	get_parent().connect(sigName, updateHealth)
	
func updateHealth(healthInput: float) -> void:
	health -= healthInput
	health_changed.emit(health)
	

