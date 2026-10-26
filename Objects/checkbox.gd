extends Area2D

@onready var supplementarytext = preload("res://Objects/supplementary_text.tscn")
@onready var glowring = preload("res://VFX/glow_ring.tscn")
@onready var is_mouse_hovering: bool = false


# Called when the node enters the scene tree for the first time.
#func _on_mouse_entered() -> void:
	#print("mouse entered")
	#is_mouse_hovering = true
	#
#func _on_mouse_exited() -> void:
	#print("mouse exited")
	#is_mouse_hovering = false

func _ready() -> void:
	mouse_entered.connect(func(): is_mouse_hovering = true)
	mouse_exited.connect(func(): is_mouse_hovering = false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Interaction") or is_in_group("inner")) and (is_mouse_hovering or is_in_group("outer")):
		print("youre did it")
		
		#var glow = glowring.instantiate()
		#get_parent().add_child(glow)
		#glow.global_position = global_position
		
		if is_in_group("check"):
			var supple = supplementarytext.instantiate()
			supple.text = "+0.1x Combo"
			get_parent().add_child(supple)
			supple.global_position = global_position
			supple.global_position.x -= 125.0
			
			get_parent().editpoints(100)
			get_parent().editcombo(0.1)
			#get_parent().say("Nice.")
		
		if is_in_group("life"):
			var supple = supplementarytext.instantiate()
			supple.text = "+1 Life!!"
			get_parent().add_child(supple)
			supple.global_position = global_position
			supple.global_position.x -= 125.0
			
			get_parent().editpoints(250)
			get_parent().editlives(1)
		
		if is_in_group("life"):
			var supple = supplementarytext.instantiate()
			supple.text = "+1000 Points!!"
			get_parent().add_child(supple)
			supple.global_position = global_position
			supple.global_position.x -= 125.0
			
			get_parent().editpoints(1000)
		
		queue_free()
