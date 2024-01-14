extends Sprite2D
class_name Interactable

signal interacted

func interact() -> void:
	interacted.emit()

func seen() -> void:
	show()
	
func unseen() -> void:
	hide()
