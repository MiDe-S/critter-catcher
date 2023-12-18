extends Button

var move: Move

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setMove(moveInput):
	move = moveInput
	self.text = move.getName()
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(move.getTypeColor())
	set("theme_override_styles/normal", stylebox)
	var imgIcon = load(move.getTypeIcon())
	set("icon", imgIcon)
	self.disabled = false
	
func setEmpty():
	self.text = ' '
	self.disabled = true
	var imgIcon = load("res://types/type-images/basic.png")
	set("icon", imgIcon)

func _on_pressed():
	get_parent().pressed(move)
	release_focus()
