@tool
extends LogStream

##A default instance of the LogStream. Instanced as the main log singelton.


func _init():
	super("Main", LogLevel.DEFAULT)

#func _input(event):
	#if event.is_action_pressed("toggle_log_level"):
		#var index: int = 0
		#for i in range(LogLevel.size()):
			#if i == current_log_level:
				#index = i + 1
		#if index >= LogLevel.size():
			#index = 1
		#current_log_level = index
