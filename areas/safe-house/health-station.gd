extends StaticBody2D

@onready var interactable := $Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interacted.connect(healParty)

func healParty() -> void:
	PlayerManager.healParty()

