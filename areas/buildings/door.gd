extends StaticBody2D

@export var connectedScene: PackedScene;

@onready var interactable := $Interactable

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable.interacted.connect(changeScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func changeScene():
	print("change scene")
