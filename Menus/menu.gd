extends Control

var infinitelives: bool = false
var currentsong: String = ""

var octane = preload("res://Backgrounds/0OctaneBackground.png")
var sunrise = preload("res://Backgrounds/RollecoasterSunrise.png")
var sunset = preload("res://Backgrounds/RollecoasterSunset.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_play_game_pressed() -> void:
	$"Main Menu".visible = false
	$"Song Select".visible = true

func _on_settings_pressed() -> void:
	$"Main Menu".visible = false
	$"Settings".visible = true

func _on_back_menu_pressed() -> void:
	$"Main Menu".visible = true
	$"Song Select".visible = false
	$"Settings".visible = false
	$"Game Over".visible = false
	$MainBG.visible = true
	$GameBG.visible = false

func _on_octane_pressed() -> void:
	$"Song Select".visible = false
	$"Song Config".visible = true
	currentsong = "Octane"
	$"Song Config/Song Name".text = currentsong
	$"Song Config/Song Info/Info".text = "Amount of notes: 361\nLevel length: 1:45\nLevel Difficulty: Increases\nfrom 1.0 to 7.0"
	$GameBG.texture = octane

func _on_rollercoaster_pressed() -> void:
	$"Song Select".visible = false
	$"Song Config".visible = true
	currentsong = "Rollercoaster"
	$"Song Config/Song Name".text = currentsong
	$"Song Config/Song Info/Info".text = "Amount of notes: 444\nLevel length: 4:44\nLevel Difficulty: 4.0"
	$GameBG.texture = sunset

func _on_back_song_pressed() -> void:
	$"Song Config".visible = false
	$"Song Select".visible = true

func _on_play_song_pressed() -> void:
	$"Song Config".visible = false
	$MainBG.visible = false
	$GameBG.visible = true
	get_parent().visible = true
	get_parent().start_song(currentsong, infinitelives)


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)


func _on_infinite_lives_toggled(toggled_on: bool) -> void:
	infinitelives = toggled_on


func _on_resume_pressed() -> void:
	get_parent().visible = false
	get_tree().paused = false
