extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#z_index = 10
	top_level = true
	for i in range(-15, 30, 1):
		global_position.y += i
		await get_tree().create_timer(0.02).timeout
	queue_free()
