extends Button

var move: Move

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setMove(moveInput):
	move = moveInput

func _on_pressed():
	get_parent().pressed(move)
	release_focus()
