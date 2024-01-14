extends CanvasLayer

func _on_pause_manager_toggle(paused: bool) -> void:
	$Panel.set_visible(paused)

func _on_resume_pressed() -> void:
	$PauseManager._toggle_pause()

func _on_save_pressed() -> void:
	PlayerManager.saveGame()

func _on_load_pressed() -> void:
	PlayerManager.loadGame()

func _on_settings_pressed() -> void:
	print("Settings")

func _on_exit_pressed() -> void:
	get_tree().quit() # Replace with function body.
