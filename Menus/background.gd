extends TextureRect

var currenttexture = ""
@onready var menu = preload("res://Backgrounds/BackgroundFaded.png")
@onready var octane = preload("res://Backgrounds/0OctaneBackground.png")
@onready var sunrise = preload("res://Backgrounds/RollecoasterSunrise.png")
@onready var sunset = preload("res://Backgrounds/RollecoasterSunset.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bgtween = create_tween()
	bgtween.set_loops()
	bgtween.tween_property(self, "global_position:x", -776.0, 5.0)
	bgtween.tween_property(self, "global_position:x", -576.0, 0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#func check():
	#if currenttexture.begins_with("0"):
