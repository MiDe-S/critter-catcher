extends GridContainer

var move_button = preload("res://battle/move_button.tscn")

func createMoveButtons(names):
	for n in names:
		var button = move_button.instantiate()
		button.text = n
		add_child(button)
		
func clearMoveButtons():
	for n in get_children():
		remove_child(n)
		n.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	createMoveButtons(["test1", "test2", "test3", "test4"])
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
