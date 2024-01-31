extends StaticBody2D

@warning_ignore("untyped_declaration")
@export_file("*.tscn") var connectedScene:
	set(value):
		connectedScene = load(value)

@onready var interactable := $Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interacted.connect(changeScene)

func changeScene() -> void:
	if connectedScene == null:
		print("No scene connected")
	else:
		@warning_ignore("untyped_declaration")
		var new_scene = connectedScene.instantiate()
		SceneManager.startScene(new_scene)

func getConnectedScene() -> PackedScene:
	return connectedScene
