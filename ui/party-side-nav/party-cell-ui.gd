extends ColorRect
class_name SideNavCell

signal health
signal exp

signal orderChanged()
signal showCritInfo(input: Critter)

@export var critter: Critter

var isInit := false
var dragging := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if critter != null and !isInit:
		initialize(critter)

func _process(_delta: float) -> void:
	if dragging:
		global_position = get_viewport().get_mouse_position() - get_size() / 2

func initialize(critterInput: Critter) -> void:
	critter = critterInput
	isInit = true
	$Sprite.texture = critter.getCritterIcon()
	# resize image based on container, assume image is square
	var scaled_x: float = get_size().x / $Sprite.texture.get_size().x
	$Sprite.scale = Vector2(scaled_x, scaled_x)
	$Level.text = str(critter.getLevel())
	$HealthBar.initialize("health", critter.getHealth())
	$HealthBar.set_max(critter.getMaxHealth())
	$ExpBar.initialize("exp", critter.getExperience())
	$ExpBar.set_max(critter.getExpNeeded())

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if !dragging:
				orderChanged.emit()
		

func getCritter() -> Critter:
	return critter

func _on_mouse_entered() -> void:
	showCritInfo.emit(critter)

func _on_mouse_exited() -> void:
	showCritInfo.emit(null)
