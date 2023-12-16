extends GridContainer

var move_button = preload("res://battle/move_button.tscn")

func createMoveButtons(moves):
	for move in moves:
		var button = move_button.instantiate()
		button.setMove(move)
		# move this to inside button
		button.text = move.getName()
		var stylebox = StyleBoxFlat.new()
		stylebox.bg_color = Color(move.getTypeColor())
		button.set("theme_override_styles/normal", stylebox)
		var icon = load(move.getTypeIcon())
		button.set("icon", icon)
		button.add_to_group("move_button")
		add_child(button)
		
func clearMoveButtons():
	for n in get_children():
		remove_child(n)
		n.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func pressed(move):
	get_parent().pressed(move)
