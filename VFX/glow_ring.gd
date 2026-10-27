extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#top_level = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.125).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween2.tween_property(self, "scale", Vector2(1.25, 1.25), 0.25).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await tween.finished
	#await tween2.finished
	queue_free()
