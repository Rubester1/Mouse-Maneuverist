extends Label


# Called when the node enters the scene tree for the first time.
func _process(_delta: float) -> void:
	top_level = true
	if text == "1":
		queue_free()
