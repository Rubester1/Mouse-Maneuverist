extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top_level = true
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2, 2), 0.25)
	tween.tween_property(self, "modulate:a", 0.0, 0.25)
	await tween.finished
	queue_free()
