extends Node2D

@onready var checkbox = preload("res://Objects/checkbox.tscn")
@onready var xbox = preload("res://Objects/xbox.tscn")
@onready var innerglowcheckbox = preload("res://Objects/innerglowcheckbox.tscn")
@onready var innerglowxbox = preload("res://Objects/innerglowxbox.tscn")
@onready var life = preload("res://Objects/life.tscn")
@onready var innerglowlife = preload("res://Objects/innerglowlife.tscn")
@onready var pointsnote = preload("res://Objects/points.tscn")
@onready var innerglowpoints = preload("res://Objects/innerglowpoints.tscn")

@onready var indicator = preload("res://Objects/indicator.tscn")
@onready var supplementarytext = preload("res://Objects/supplementary_text.tscn")

@onready var MusicPlayer = $AudioStreamPlayer2D
@onready var caption = $UI/CanvasLayer/Text
@onready var info = $UI/CanvasLayer/Info

@export var lives: int = 5
@export var points: int = 0
@export var combo: float = 1.0
@export var notes: int = 0

@export var currentsong = "None"
@export var songposition = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"UI/CanvasLayer".visible = false

@warning_ignore("unused_parameter")
func say(text: String):
	#caption.text = text
	#await get_tree().create_timer(0.5).timeout
	#caption.text = ""
	pass

func editcombo(value):
	combo += value
	print(combo)

func editpoints(value):
	points += value * combo
	print(points)

func editlives(value):
	if value < 0:
		combo = 1
	lives += value
	print(lives)

func summon(type, pos, time):
	notes -= 1
	var indicate = indicator.instantiate()
	indicate.position = pos
	add_child(indicate)
	await get_tree().create_timer(1.0).timeout
	if is_instance_valid(indicate):
		indicate.queue_free()
	
	var instance = type.instantiate()
	instance.position = pos
	add_child(instance)
	
	var tween = create_tween()
	tween.tween_property(
		instance,
		"modulate:a",
		0.0,
		time
	)
	await tween.finished
	
	if is_instance_valid(instance):
		if instance.is_in_group("check"):
			editlives(-1)
			var supple = supplementarytext.instantiate()
			supple.text = "No More Combo"
			get_parent().add_child(supple)
			supple.global_position = instance.global_position
			supple.global_position.x -= 125.0
			instance.queue_free()
			say("Oof! Too late!")
		elif instance.is_in_group("x"):
			editpoints(10)
			instance.queue_free()
			say("Nice.")
#hackatime isn't working oh my goodness me oh my...hackatime why would you do this to me... HACKATIME YOU ARENT TRACKING MY HOURS BRO WHYWHYWHYWHYHWHWYHWYWYHWYHWYHWYHWYHWYHWYHWYHWYHWYHYWHYWYWHYWYHHYWYWWHYWHYWHWYHWHYWHYWHYWHYWHYWHYWYHWYWHHWYHWYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
func gameover(win: bool):
	$"Menu/Game Over".visible = true
	if win:
		$"Menu/Game Over/Game Over".visible = false
		$"Menu/Game Over/You Win".visible = true
	else:
		$"Menu/Game Over/Game Over".visible = true
		$"Menu/Game Over/You Win".visible = false
	$"UI/CanvasLayer".visible = false
	$"Menu/Game Over/PointsGameOver".text = "%s Points" % [points]
	currentsong = "None"
	MusicPlayer.stop()

func findnote(string: String):
	if string == "cbx":
		return checkbox
	elif string == "xbx":
		return xbox
	elif string == "icb":
		return innerglowcheckbox
	elif string == "ixb":
		return innerglowxbox

#cbx5004001.0
#xbx6303202.3

#************jsut make the type indicator 3 characters and have the function just detect which note type that combo pertains too!!!!!!!! 
func summonwithstring(string: String):
	summon(
		findnote(string.substr(0,string.length()-11)), #type
		Vector2(string.substr(string.length()-11,4).to_float(),string.substr(string.length()-7,4).to_float()), #pos
		string.substr(string.length()-3,3).to_float(), #time 
		)

func start_song(song, infinitelives):
	
	if infinitelives:
		lives = 1000000000
	else:
		lives = 5
	$"UI/CanvasLayer".visible = true
	
	if song == "Octane":
		MusicPlayer.stream = load("res://Music/Creo Octane.mp3")
		MusicPlayer.play(0.0)
		currentsong = "Octane"
		notes = 361
		
		$Menu/Background.start_song("Octane")
		
		await get_tree().create_timer(3.0).timeout
		
		summon(checkbox,Vector2(0,0),4.0)
		caption.text = "Click the checkmark box before it leaves!"
		await get_tree().create_timer(4.0).timeout
		caption.text = ""
		
		await get_tree().create_timer(1.0).timeout
		
		summon(xbox,Vector2(0,0),4.0)
		caption.text = "Don't click the x box, let it disappear!"
		await get_tree().create_timer(4.0).timeout
		caption.text = ""
		
		await get_tree().create_timer(1.0).timeout
		
		summon(innerglowcheckbox,Vector2(-400,0),4.0)
		summon(innerglowxbox,Vector2(400,0),4.0)
		caption.text = "Notes with yellow outlines will trigger upon hovering with your mouse, no clicking required!"
		await get_tree().create_timer(4.0).timeout
		caption.text = ""
		
		await get_tree().create_timer(1.0).timeout
		
		summon(checkbox, Vector2(-200,100), 4.0)
		summon(checkbox, Vector2(0,100), 4.0)
		summon(checkbox, Vector2(200,100), 4.0)
		summon(innerglowxbox, Vector2(-100,100), 4.0)
		summon(innerglowxbox, Vector2(100,100), 4.0)
		caption.text = "Good luck!"
		await get_tree().create_timer(4.0).timeout
		caption.text = ""
		
		if lives < 1:
			gameover(false)
			return
		
		await get_tree().create_timer(1.0).timeout
		
		
		summon(checkbox, Vector2(-200, 200), 1.25)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowcheckbox, Vector2(-100, 200), 1.25)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox, Vector2(0, 200), 1.25)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowxbox, Vector2(100, 200), 1.25)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox, Vector2(200, 200), 1.25)
		await get_tree().create_timer(1.0).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(innerglowcheckbox, Vector2(-200, -200), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowcheckbox, Vector2(-100, -200), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowxbox, Vector2(0, -200), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox, Vector2(100, -200), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowxbox, Vector2(200, -200), 1.0)
		await get_tree().create_timer(0.5).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(checkbox, Vector2(-200, 200), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(xbox, Vector2(-200, 100), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowcheckbox, Vector2(-200, 0), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowxbox, Vector2(-200, -100), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox, Vector2(-200, -200), 1.0)
		await get_tree().create_timer(0.5).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(innerglowxbox, Vector2(200, -200), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox, Vector2(200, -100), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowxbox, Vector2(200, 0), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox, Vector2(200, 100), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowxbox, Vector2(200, 200), 1.0)
		await get_tree().create_timer(0.5).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		
		
		
		
		
		
		
		
		
		summon(innerglowcheckbox, Vector2(150, 150), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox,          Vector2(100, 100), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowxbox,     Vector2(0, 0), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowcheckbox, Vector2(-100, -100), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowxbox,     Vector2(-200, -200), 1.0)
		await get_tree().create_timer(0.5).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(checkbox, Vector2(200, -200), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(xbox,          Vector2(100, -100), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(xbox,     Vector2(0, 0), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox, Vector2(-100, 100), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox,     Vector2(-200, 200), 1.0)
		await get_tree().create_timer(0.5).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(checkbox, Vector2(-300, 200), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowcheckbox, Vector2(-350, 100), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox, Vector2(-380, 0), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(xbox, Vector2(-350, -100), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowcheckbox, Vector2(-300, -200), 1.0)
		await get_tree().create_timer(0.5).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(innerglowxbox, Vector2(300, 200), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowcheckbox, Vector2(350, 100), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowxbox, Vector2(380, 0), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowcheckbox, Vector2(350, -100), 1.0)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox, Vector2(300, -200), 1.0)
		await get_tree().create_timer(0.5).timeout
		
		
		if lives < 1:
			gameover(false)
			return
		
		
		
		
		
		caption.text = "ok this is where you lock in"
		await get_tree().create_timer(2.0).timeout
		caption.text = ""
		
		summon(checkbox, Vector2(300,-200), 2.0)
		summon(innerglowxbox, Vector2(400,-200), 2.0)
		summon(innerglowxbox, Vector2(300,-100), 2.0)
		summon(innerglowxbox, Vector2(400,-100), 2.0)
		await get_tree().create_timer(2.0).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(innerglowxbox, Vector2(-300,200), 2.0)
		summon(checkbox, Vector2(-400,200), 2.0)
		summon(innerglowxbox, Vector2(-300,100), 2.0)
		summon(innerglowxbox, Vector2(-400,100), 2.0)
		await get_tree().create_timer(2.0).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(innerglowxbox, Vector2(-100,-200), 2.0)
		summon(innerglowxbox, Vector2(-0,-200), 2.0)
		summon(checkbox, Vector2(100,-200), 2.0)
		summon(innerglowxbox, Vector2(-100,-100), 2.0)
		summon(innerglowxbox, Vector2(0,-100), 2.0)
		summon(innerglowxbox, Vector2(100,-100), 2.0)
		await get_tree().create_timer(2.0).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(innerglowxbox, Vector2(300,200), 2.0)
		summon(innerglowxbox, Vector2(400,200), 2.0)
		summon(innerglowxbox, Vector2(300,100), 2.0)
		summon(checkbox, Vector2(400,100), 2.0)
		await get_tree().create_timer(2.0).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(innerglowxbox, Vector2(-300,-200), 2.0)
		summon(innerglowxbox, Vector2(-400,-200), 2.0)
		summon(innerglowxbox, Vector2(-300,-100), 2.0)
		summon(checkbox, Vector2(-400,-100), 2.0)
		await get_tree().create_timer(2.0).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(innerglowxbox, Vector2(-100,200), 2.0)
		summon(checkbox, Vector2(0,200), 2.0)
		summon(innerglowxbox, Vector2(100,200), 2.0)
		summon(innerglowxbox, Vector2(-100,100), 2.0)
		summon(innerglowxbox, Vector2(0,100), 2.0)
		summon(innerglowxbox, Vector2(100,100), 2.0)
		await get_tree().create_timer(3.3).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		#darken background
		
		
		summon(innerglowcheckbox, Vector2(200,200), 2)
		await get_tree().create_timer(0.2).timeout
		summon(innerglowcheckbox, Vector2(200,-200), 2)
		await get_tree().create_timer(0.2).timeout
		summon(innerglowcheckbox, Vector2(-200,-200), 2)
		await get_tree().create_timer(0.2).timeout
		summon(innerglowcheckbox, Vector2(-200,200), 2)
		await get_tree().create_timer(0.2).timeout
		summon(innerglowcheckbox, Vector2(100,100), 2)
		await get_tree().create_timer(0.2).timeout
		summon(innerglowcheckbox, Vector2(100,-100), 2)
		await get_tree().create_timer(0.2).timeout
		summon(innerglowcheckbox, Vector2(-100,-100), 2)
		await get_tree().create_timer(0.2).timeout
		summon(innerglowcheckbox, Vector2(-100,100), 2)
		await get_tree().create_timer(0.2).timeout
		summon(innerglowcheckbox, Vector2(0,0), 2)
		await get_tree().create_timer(0.5).timeout
		
		
		if lives < 1:
			gameover(false)
			return
		
		
		
		
		summon(checkbox, Vector2(300,100), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowxbox, Vector2(200,-200), 1.5)
		summon(innerglowcheckbox, Vector2(200,-100), 1.5)
		summon(innerglowxbox, Vector2(200,0), 1.5)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox, Vector2(100,100), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowxbox, Vector2(0,-200), 1.5)
		summon(innerglowcheckbox, Vector2(0,-100), 1.5)
		summon(innerglowxbox, Vector2(0,0), 1.5)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox, Vector2(-100,100), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowxbox, Vector2(-200,-200), 1.5)
		summon(innerglowcheckbox, Vector2(-200,-100), 1.5)
		summon(innerglowxbox, Vector2(-200,0), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(checkbox, Vector2(-300,100), 1.5)
		await get_tree().create_timer(1.25).timeout
		
		
		if lives < 1:
			gameover(false)
			return
		
		
		
		
		summon(innerglowxbox, Vector2(-300,100), 1.5)
		summon(innerglowcheckbox, Vector2(-300,200), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowcheckbox, Vector2(-150,100), 1.5)
		summon(innerglowxbox, Vector2(-150,200), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowxbox, Vector2(0,100), 1.5)
		summon(innerglowcheckbox, Vector2(0,200), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowcheckbox, Vector2(150,100), 1.5)
		summon(innerglowxbox, Vector2(150,200), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowxbox, Vector2(300,100), 1.5)
		summon(innerglowcheckbox, Vector2(300,200), 1.5)
		await get_tree().create_timer(1.25).timeout
		
		
		if lives < 1:
			gameover(false)
			return
		
		
		
		
		summon(checkbox, Vector2(300,-200), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowxbox, Vector2(200,100), 1.5)
		summon(innerglowcheckbox, Vector2(200,0), 1.5)
		summon(innerglowxbox, Vector2(200,-100), 1.5)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox, Vector2(100,-200), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowxbox, Vector2(0,100), 1.5)
		summon(innerglowcheckbox, Vector2(0,0), 1.5)
		summon(innerglowxbox, Vector2(0,-100), 1.5)
		await get_tree().create_timer(0.5).timeout
		summon(checkbox, Vector2(-100,-200), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowxbox, Vector2(-200,100), 1.5)
		summon(innerglowcheckbox, Vector2(-200,0), 1.5)
		summon(innerglowxbox, Vector2(-200,-100), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(checkbox, Vector2(-300,-200), 1.5)
		await get_tree().create_timer(1.25).timeout
		
		
		if lives < 1:
			gameover(false)
			return
		
		
		
		
		summon(innerglowxbox, Vector2(-300,100), 1.5)
		summon(innerglowcheckbox, Vector2(-300,200), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowcheckbox, Vector2(-150,100), 1.5)
		summon(innerglowxbox, Vector2(-150,200), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowxbox, Vector2(0,100), 1.5)
		summon(innerglowcheckbox, Vector2(0,200), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowcheckbox, Vector2(150,100), 1.5)
		summon(innerglowxbox, Vector2(150,200), 1.5)
		await get_tree().create_timer(0.1).timeout
		summon(innerglowxbox, Vector2(300,100), 1.5)
		summon(innerglowcheckbox, Vector2(300,200), 1.5)
		await get_tree().create_timer(1.25).timeout
		await get_tree().create_timer(1.0).timeout
		
		
		if lives < 1:
			gameover(false)
			return
		
		
		summon(innerglowxbox, Vector2(-600,300), 20)
		summon(innerglowxbox, Vector2(-600,200), 20)
		summon(innerglowxbox, Vector2(-600,100), 20)
		summon(innerglowxbox, Vector2(-600,0), 20)
		summon(innerglowxbox, Vector2(-600,-100), 20)
		summon(innerglowxbox, Vector2(-600,-200), 20)
		summon(innerglowxbox, Vector2(-600,-300), 20)
		
		summon(innerglowxbox, Vector2(600,300), 20)
		summon(innerglowxbox, Vector2(600,200), 20)
		summon(innerglowxbox, Vector2(600,100), 20)
		summon(innerglowxbox, Vector2(600,0), 20)
		summon(innerglowxbox, Vector2(600,-100), 20)
		summon(innerglowxbox, Vector2(600,-200), 20)
		summon(innerglowxbox, Vector2(600,-300), 20)
		await get_tree().create_timer(0.02).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		
		summon(innerglowxbox, Vector2(-500,300), 20)
		summon(innerglowxbox, Vector2(-500,200), 20)
		summon(innerglowxbox, Vector2(-500,100), 20)
		summon(innerglowxbox, Vector2(-500,0), 20)
		summon(innerglowxbox, Vector2(-500,-100), 20)
		summon(innerglowxbox, Vector2(-500,-200), 20)
		summon(innerglowxbox, Vector2(-500,-300), 20)
		
		summon(innerglowxbox, Vector2(500,300), 20)
		summon(innerglowxbox, Vector2(500,200), 20)
		summon(innerglowxbox, Vector2(500,100), 20)
		summon(innerglowxbox, Vector2(500,0), 20)
		summon(innerglowxbox, Vector2(500,-100), 20)
		summon(innerglowxbox, Vector2(500,-200), 20)
		summon(innerglowxbox, Vector2(500,-300), 20)
		await get_tree().create_timer(0.02).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		
		summon(innerglowxbox, Vector2(-400,300), 20)
		summon(innerglowxbox, Vector2(-400,200), 20)
		summon(innerglowxbox, Vector2(-400,100), 20)
		summon(innerglowxbox, Vector2(-400,0), 20)
		summon(innerglowxbox, Vector2(-400,-100), 20)
		summon(innerglowxbox, Vector2(-400,-200), 20)
		summon(innerglowxbox, Vector2(-400,-300), 20)
		
		summon(innerglowxbox, Vector2(400,300), 20)
		summon(innerglowxbox, Vector2(400,200), 20)
		summon(innerglowxbox, Vector2(400,100), 20)
		summon(innerglowxbox, Vector2(400,0), 20)
		summon(innerglowxbox, Vector2(400,-100), 20)
		summon(innerglowxbox, Vector2(400,-200), 20)
		summon(innerglowxbox, Vector2(400,-300), 20)
		await get_tree().create_timer(0.02).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		
		summon(innerglowxbox, Vector2(-300,300), 20)
		summon(innerglowxbox, Vector2(-300,200), 20)
		summon(innerglowxbox, Vector2(-300,100), 20)
		summon(innerglowxbox, Vector2(-300,0), 20)
		summon(innerglowxbox, Vector2(-300,-100), 20)
		summon(innerglowxbox, Vector2(-300,-200), 20)
		summon(innerglowxbox, Vector2(-300,-300), 20)
		
		summon(innerglowxbox, Vector2(300,300), 20)
		summon(innerglowxbox, Vector2(300,200), 20)
		summon(innerglowxbox, Vector2(300,100), 20)
		summon(innerglowxbox, Vector2(300,0), 20)
		summon(innerglowxbox, Vector2(300,-100), 20)
		summon(innerglowxbox, Vector2(300,-200), 20)
		summon(innerglowxbox, Vector2(300,-300), 20)
		await get_tree().create_timer(0.02).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		
		summon(innerglowxbox, Vector2(-200,300), 20)
		summon(innerglowxbox, Vector2(-200,-300), 20)
		
		summon(innerglowxbox, Vector2(200,300), 20)
		summon(innerglowxbox, Vector2(200,-300), 20)
		await get_tree().create_timer(0.02).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		
		summon(innerglowxbox, Vector2(-100,300), 20)
		summon(innerglowxbox, Vector2(-100,-300), 20)
		
		summon(innerglowxbox, Vector2(100,300), 20)
		summon(innerglowxbox, Vector2(100,-300), 20)
		await get_tree().create_timer(0.02).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		
		summon(innerglowxbox, Vector2(0,300), 20)
		
		summon(innerglowxbox, Vector2(0,-300), 20)
		await get_tree().create_timer(0.02).timeout
		await get_tree().create_timer(1.35).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		
		summon(innerglowxbox, Vector2(0,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(-100,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowxbox, Vector2(-200,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(-200,-100), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowxbox, Vector2(-200,0), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(-200,100), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowxbox, Vector2(-200,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(-100,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowxbox, Vector2(0,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(100,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowxbox, Vector2(200,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(200,100), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowxbox, Vector2(200,0), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(200,-100), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowxbox, Vector2(200,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(100,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		
		
		if lives < 1:
			gameover(false)
			return
		
		summon(checkbox, Vector2(0,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(xbox, Vector2(-100,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(checkbox, Vector2(-200,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(xbox, Vector2(-200,-100), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(checkbox, Vector2(-200,0), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(xbox, Vector2(-200,100), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(checkbox, Vector2(-200,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(xbox, Vector2(-100,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(checkbox, Vector2(0,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(xbox, Vector2(100,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(checkbox, Vector2(200,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(xbox, Vector2(200,100), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(checkbox, Vector2(200,0), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(xbox, Vector2(200,-100), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(checkbox, Vector2(200,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(xbox, Vector2(100,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		
		summon(innerglowxbox, Vector2(0,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(-100,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(checkbox, Vector2(-200,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(-200,-100), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowxbox, Vector2(-200,0), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(-200,100), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(xbox, Vector2(-200,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(-100,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowxbox, Vector2(0,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(100,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(checkbox, Vector2(200,200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(200,100), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowxbox, Vector2(200,0), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(200,-100), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(xbox, Vector2(200,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(100,-200), 1.5)
		await get_tree().create_timer(0.15).timeout
		await get_tree().create_timer(0.85).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		
		summon(innerglowxbox, Vector2(0,-200), 5.0) #5x5 outline of x boxes
		summon(innerglowxbox, Vector2(-100,-200), 5.0)
		summon(innerglowxbox, Vector2(-200,-200), 5.0)
		summon(innerglowxbox, Vector2(-200,-100), 5.0)
		summon(innerglowxbox, Vector2(-200,0), 5.0)
		summon(innerglowxbox, Vector2(-200,100), 5.0)
		summon(innerglowxbox, Vector2(-200,200), 5.0)
		summon(innerglowxbox, Vector2(-100,200), 5.0)
		summon(innerglowxbox, Vector2(0,200), 5.0)
		summon(innerglowxbox, Vector2(100,200), 5.0)
		summon(innerglowxbox, Vector2(200,200), 5.0)
		summon(innerglowxbox, Vector2(200,100), 5.0)
		summon(innerglowxbox, Vector2(200,0), 5.0)
		summon(innerglowxbox, Vector2(200,-100), 5.0)
		summon(innerglowxbox, Vector2(200,-200), 5.0)
		summon(innerglowxbox, Vector2(100,-200), 5.0)
		await get_tree().create_timer(0.25).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		
		summon(checkbox, Vector2(0,-100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-100,-100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-100,0), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-100,100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(0,100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(100,100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(100,0), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(100,-100), 1.5)
		await get_tree().create_timer(0.25).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(checkbox, Vector2(0,-100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(xbox, Vector2(-100,-100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-100,0), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(xbox, Vector2(-100,100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(0,100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(xbox, Vector2(100,100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(100,0), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(xbox, Vector2(100,-100), 1.5)
		await get_tree().create_timer(0.25).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(checkbox, Vector2(0,-100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-100,-100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(innerglowxbox, Vector2(-100,0), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-100,100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(0,100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(100,100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(innerglowxbox, Vector2(100,0), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(100,-100), 1.5)
		await get_tree().create_timer(0.25).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(checkbox, Vector2(0,-100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(innerglowxbox, Vector2(-100,-100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(innerglowxbox, Vector2(-100,0), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-100,100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(0,100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(innerglowxbox, Vector2(100,100), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(innerglowxbox, Vector2(100,0), 1.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(100,-100), 1.5)
		await get_tree().create_timer(0.25).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		
		summon(checkbox, Vector2(100,-200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(0,-200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-100,-200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-200,-200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-200,-100), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(xbox, Vector2(-200,0), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-200,100), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-200,200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-100,200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(0,200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(xbox, Vector2(100,200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(200,200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(xbox, Vector2(200,100), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(200,0), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(200,-100), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(200,-200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(100,-200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(0,-200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(0,-100), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(0,0), 0.5)
		await get_tree().create_timer(0.25).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		
		summon(checkbox, Vector2(-100,0), 0.5)
		summon(xbox, Vector2(100,0), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-200,0), 0.5)
		summon(xbox, Vector2(200,0), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-300,0), 0.5)
		summon(xbox, Vector2(300,0), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-300,100), 0.5)
		summon(xbox, Vector2(300,100), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(xbox, Vector2(-300,200), 0.5)
		summon(checkbox, Vector2(300,200), 3)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-200,200), 0.5)
		summon(xbox, Vector2(200,200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-100,200), 0.5)
		summon(xbox, Vector2(100,200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(checkbox, Vector2(-100,100), 0.5)
		summon(xbox, Vector2(100,100), 0.5)
		await get_tree().create_timer(1).timeout
		summon(xbox, Vector2(-100,0), 1)
		summon(checkbox, Vector2(100,0), 1)
		await get_tree().create_timer(0.5).timeout
		summon(xbox, Vector2(-100,-100), 0.5)
		summon(checkbox, Vector2(100,-100), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(xbox, Vector2(-100,-200), 0.5)
		summon(checkbox, Vector2(100,-200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(xbox, Vector2(-200,-200), 0.5)
		summon(checkbox, Vector2(200,-200), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(xbox, Vector2(-300,-200), 0.5)
		summon(checkbox, Vector2(300,-200), 0.5)
		await get_tree().create_timer(1).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(innerglowcheckbox, Vector2(-300,-300), 1)
		summon(innerglowcheckbox, Vector2(300,-300), 1)
		await get_tree().create_timer(0.5).timeout
		summon(innerglowcheckbox, Vector2(-200,-300), 1)
		summon(innerglowcheckbox, Vector2(200,-300), 0.5)
		await get_tree().create_timer(0.25).timeout
		summon(innerglowcheckbox, Vector2(-200,-200), 1)
		summon(innerglowcheckbox, Vector2(200,-200), 1)
		await get_tree().create_timer(0.25).timeout
		summon(innerglowcheckbox, Vector2(-100,-200), 1)
		summon(innerglowcheckbox, Vector2(100,-200), 1)
		await get_tree().create_timer(0.25).timeout
		summon(innerglowcheckbox, Vector2(-100,-100), 1)
		summon(innerglowcheckbox, Vector2(100,-100), 1)
		await get_tree().create_timer(0.25).timeout
		summon(innerglowcheckbox, Vector2(-200,-100), 1)
		summon(innerglowcheckbox, Vector2(200,-100), 1)
		await get_tree().create_timer(0.25).timeout
		summon(innerglowcheckbox, Vector2(-200,-200), 1)
		summon(innerglowcheckbox, Vector2(200,-200), 1)
		await get_tree().create_timer(0.25).timeout
		summon(innerglowcheckbox, Vector2(0,-200), 1)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(0,-100), 1)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(0,0), 1)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(0,100), 1)
		await get_tree().create_timer(0.15).timeout
		summon(innerglowcheckbox, Vector2(0,200), 1)
		await get_tree().create_timer(1).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		summon(checkbox, Vector2(-500,0), 0.7)
		summon(checkbox, Vector2(500,0), 0.7)
		await get_tree().create_timer(0.3).timeout
		
		if lives < 1:
			gameover(false)
			return
		
		gameover(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	songposition = MusicPlayer.get_playback_position()
	
	if Input.is_action_just_pressed("Spawn Checkbox"):
		summon(checkbox, Vector2(randi_range(-500,500),randi_range(-500,500)), 1.0)
	if Input.is_action_just_pressed("Spawn Xbox"):
		summon(xbox, Vector2(randi_range(-500,500),randi_range(-500,500)), 1.0)
	if Input.is_action_just_pressed("Spawn Inner Glow Checkbox"):
		summon(innerglowcheckbox, Vector2(randi_range(-500,500),randi_range(-500,500)), 1.0)
	if Input.is_action_just_pressed("Spawn Inner Glow Xbox"):
		summon(innerglowxbox, Vector2(randi_range(-500,500),randi_range(-500,500)), 1.0)
		
	
	info.text = "Lives: %s\nPoints: %s\nCombo: %sx\nNotes left: %s" % [lives, points, combo, notes]
	
	
	if Input.is_action_just_pressed("Pause"):
		pass
		#get_tree().paused = true
		#$"Menu/PauseMenu".visible = true
	
	
	
	
	
	
	
	
	
	
	
	
	if Input.is_action_just_pressed("Play Song 1"):
		MusicPlayer.stream = load("res://Music/Panda Eyes Highscore.mp3")
		MusicPlayer.play(0.0)
		currentsong = "Highscore"
		
		
		await get_tree().create_timer(8.72-0.5).timeout
		summonwithstring("cbx-100+0001.5")
		await get_tree().create_timer(2.18).timeout
		summonwithstring("cbx+100+0001.5")
		await get_tree().create_timer(2.18).timeout
		summonwithstring("cbx+000-1001.5")
		await get_tree().create_timer(2.18).timeout
		summonwithstring("cbx+000+1001.5")
		
		
		
		
		
		await get_tree().create_timer(2.18).timeout
		
		await get_tree().create_timer(1.09).timeout
		summonwithstring("icb+200+2001.5")
		summonwithstring("icb-200-2001.5")
		await get_tree().create_timer(1.09).timeout
		summonwithstring("cbx+000+0001.5")
		
		await get_tree().create_timer(1.09).timeout
		summonwithstring("icb+200-2001.5")
		summonwithstring("icb-200+2001.5")
		await get_tree().create_timer(1.09).timeout
		summonwithstring("cbx+000+0001.5")
		
		await get_tree().create_timer(1.09).timeout
		summonwithstring("icb+200+2001.5")
		summonwithstring("icb-200-2001.5")
		summonwithstring("icb+200-2001.5")
		summonwithstring("icb-200+2001.5")
		await get_tree().create_timer(1.09).timeout
		summonwithstring("cbx+000+0001.5")
		
		await get_tree().create_timer(1.09).timeout
		summonwithstring("icb+200+2002.5")
		summonwithstring("icb-200-2002.5")
		summonwithstring("icb+200-2002.5")
		summonwithstring("icb-200+2002.5")
		
		summonwithstring("icb+200+1002.5")
		summonwithstring("icb-200-1002.5")
		summonwithstring("icb+200-1002.5")
		summonwithstring("icb-200+1002.5")
		
		summonwithstring("icb+100+2002.5")
		summonwithstring("icb-100-2002.5")
		summonwithstring("icb+100-2002.5")
		summonwithstring("icb-100+2002.5")
		await get_tree().create_timer(1.09).timeout
		summonwithstring("cbx+000+0001.5")
		
		
		
		
		
		await get_tree().create_timer(2.18).timeout
		summonwithstring("cbx+100+0001.5")
		summonwithstring("xbx-100+0001.5")
		await get_tree().create_timer(2.18).timeout
		summonwithstring("cbx-100+0001.5")
		summonwithstring("xbx+100+0001.5")
		await get_tree().create_timer(2.18).timeout
		summonwithstring("cbx+000+1001.5")
		summonwithstring("xbx+000-1001.5")
		await get_tree().create_timer(2.18).timeout
		summonwithstring("cbx+000+1001.5")
		summonwithstring("xbx+100+0001.5")
		
		
		
		
		
		
		await get_tree().create_timer(1.09).timeout
		summonwithstring("icb+200+2001.5")
		summonwithstring("ixb-200-2001.5")
		await get_tree().create_timer(1.09).timeout
		summonwithstring("cbx+000+0001.5")
		
		await get_tree().create_timer(1.09).timeout
		summonwithstring("ixb+200-2001.5")
		summonwithstring("icb-200+2001.5")
		await get_tree().create_timer(1.09).timeout
		summonwithstring("cbx+000+0001.5")
		
		await get_tree().create_timer(1.09).timeout
		summonwithstring("icb+200+2001.5")
		summonwithstring("ixb-200-2001.5")
		summonwithstring("ixb+200-2001.5")
		summonwithstring("icb-200+2001.5")
		await get_tree().create_timer(1.09).timeout
		summonwithstring("cbx+000+0001.5")
		
		await get_tree().create_timer(1.09).timeout
		summonwithstring("ixb+200+2001.0")
		summonwithstring("ixb-200-2001.0")
		summonwithstring("ixb+200-2001.0")
		summonwithstring("ixb-200+2001.0")
		
		summonwithstring("ixb+200+1001.0")
		summonwithstring("ixb-200-1001.0")
		summonwithstring("ixb+200-1001.0")
		summonwithstring("ixb-200+1001.0")
		
		summonwithstring("ixb+100+2001.0")
		summonwithstring("ixb-100-2001.0")
		summonwithstring("ixb+100-2001.0")
		summonwithstring("ixb-100+2001.0")
		await get_tree().create_timer(1.09).timeout
		summonwithstring("cbx+000+0001.5")
		await get_tree().create_timer(2.18/4).timeout
		
		
		
		
		
		
		
		
		
		
		
		
		
		summonwithstring("icb+000+3001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+152+2581.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+257+1541.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("icb+300+0001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+257-1541.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+152-2581.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("icb+000-3001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-152-2581.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-257-1541.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("icb-300+0001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-257+1541.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-152+2581.5")
		await get_tree().create_timer(2.18/12).timeout
		
		
		
		
		
		
		summonwithstring("cbx+000+3001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("xbx+152+2581.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("cbx+257+1541.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("xbx+300+0001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("cbx+257-1541.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("xbx+152-2581.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("cbx+000-3001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("xbx-152-2581.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("cbx-257-1541.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("xbx-300+0001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("cbx-257+1541.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("xbx-152+2581.5")
		await get_tree().create_timer(2.18/12).timeout
		
		
		
		
		
		
		summonwithstring("icb+000+3001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("ixb+152+2581.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+257+1541.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("ixb+300+0001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+257-1541.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("ixb+152-2581.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("icb+000-3001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("ixb-152-2581.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-257-1541.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("ixb-300+0001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-257+1541.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("ixb-152+2581.5")
		await get_tree().create_timer(2.18/12).timeout
		
		
		
		
		
		summonwithstring("cbx+000+3001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("ixb+152+2581.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("cbx+257+1541.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("ixb+300+0001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("cbx+257-1541.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("ixb+152-2581.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("cbx+000-3001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("ixb-152-2581.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("cbx-257-1541.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("ixb-300+0001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("cbx-257+1541.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("ixb-152+2581.5")
		await get_tree().create_timer(2.18/12).timeout
		
		
		
		
		
		
		
		
		
		summonwithstring("cbx-050-2001.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx-100-1001.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx-150-0001.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx-200+1001.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx-250+2001.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx-300+3001.5")
		await get_tree().create_timer(2.18/6).timeout
		
		summonwithstring("cbx+300+3001.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx+250+2001.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx+200+1001.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx+150-0001.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx+100-1001.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx+050-2001.5")
		await get_tree().create_timer(2.18/6).timeout
		
		
		
		
		
		summonwithstring("cbx-300+0901.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx-200+0401.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx-100+0101.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx+100+0101.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx+200+0401.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx+300+0901.5")
		await get_tree().create_timer(2.18/6).timeout
		
		summonwithstring("cbx+300-0901.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx+200-0401.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx+100-0101.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx-100-0101.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx-200-0401.5")
		await get_tree().create_timer(2.18/6).timeout
		summonwithstring("cbx-300-0901.5")
		await get_tree().create_timer(2.18/6).timeout
		
		
		
		
		
		
		summonwithstring("icb-300+3001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-250+2001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-200+1001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-150+0001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-100-1001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-050-2001.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("icb+050-2001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+100-1001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+150+0001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+200+1001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+250+2001.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+300+3001.5")
		await get_tree().create_timer(2.18/12).timeout
		
		
		
		
		
		
		summonwithstring("icb-300+0101.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-200+0401.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-100+0901.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+100+0901.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+200+0401.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+300+0101.5")
		await get_tree().create_timer(2.18/12).timeout
		
		summonwithstring("icb+300-0101.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+200-0401.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb+100-0901.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-100-0901.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-200-0401.5")
		await get_tree().create_timer(2.18/12).timeout
		summonwithstring("icb-300-0101.5")
		await get_tree().create_timer(2.18/12).timeout
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
		
		
		
		
		
		
		
		
	#if Input.is_action_just_pressed("test"):
		#var string = "xbx+630-3202.3"
		#print(string.substr(0,string.length()-11)) #type
		#if string.substr(0,string.length()-11) == "cbx":
			#print("checkbox")
		#elif string.substr(0,string.length()-11) == "xbx":
			#print("xbox")
		#elif string.substr(0,string.length()-11) == "icb":
			#print("innerglowcheckbox")
		#elif string.substr(0,string.length()-11) == "ixb":
			#print("innerglowxbox")
		#else:
			#print("No note found")
		#print(string.substr(string.length()-11,4))
		#print(string.substr(string.length()-7,4))
		#print(Vector2(string.substr(string.length()-11,4).to_float(),string.substr(string.length()-7,4).to_float())) #pos
		#print(string.substr(string.length()-3,3).to_float()) #time 
		#summonwithstring("xbx6303202.3")
