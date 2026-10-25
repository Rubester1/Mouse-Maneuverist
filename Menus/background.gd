extends TextureRect

var currenttexture = ""
var menu = preload("res://Backgrounds/BackgroundFaded.png")
var octane = preload("res://Backgrounds/0OctaneBackground.png")
var bgtween = create_tween()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	bgtween.set_loops()
	if not currenttexture.begins_with("0"):
		bgtween.tween_property(self, "global_position:x", -776.0, 5.0)
	bgtween.tween_property(self, "global_position:x", -576.0, 0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#func check():
	#if currenttexture.begins_with("0"):

func start_song(song):
	bgtween.kill()
	
	if song == "Octane":
		texture = octane
		currenttexture = "0OctaneBackground"
	else:
		texture = menu
		currenttexture = "BackgroundFaded"
	
	bgtween.set_loops()
	if not currenttexture.begins_with("0"):
		bgtween.tween_property(self, "global_position:x", -776.0, 5.0)
	bgtween.tween_property(self, "global_position:x", -576.0, 0.0)
