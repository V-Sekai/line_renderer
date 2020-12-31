tool
extends EditorPlugin


func _init() -> void:
	print("Initialising LineRenderer plugin")


func _notification(p_notification: int):
	match p_notification:
		NOTIFICATION_PREDELETE:
			print("Destroying LineRenderer plugin")


func get_name() -> String:
	return "LineRenderer"