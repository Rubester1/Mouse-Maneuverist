extends ColorRect

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	modulate.a = 0
	top_level = true

func pulse(duration, strength = 0.75, coloring = Color(255,255,255)):
	top_level = true
	print("pulsed")
	color = coloring
	modulate.a = strength
	var tween = create_tween()
	tween.tween_property(
		self,
		"modulate:a",
		0.0,
		duration
	)
