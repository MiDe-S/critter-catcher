extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pause_manager_toggle(paused):
	$Panel.set_visible(paused)

func _on_resume_pressed():
	$PauseManager._toggle_pause()

func _on_save_pressed():
	print("Saved")

func _on_load_pressed():
	print("Loaded")

func _on_settings_pressed():
	print("Settings")

func _on_exit_pressed():
	get_tree().quit() # Replace with function body.
