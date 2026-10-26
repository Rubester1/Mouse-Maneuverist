extends Area2D

@onready var supplementarytext = preload("res://Objects/supplementary_text.tscn")
@onready var is_mouse_hovering: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(func(): is_mouse_hovering = true)
	mouse_exited.connect(func(): is_mouse_hovering = false)
	top_level = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Interaction") or is_in_group("inner")) and (is_mouse_hovering or is_in_group("outer")):
		print("youre didnt")
		var supple = supplementarytext.instantiate()
		supple.text = "No More Combo"
		get_parent().add_child(supple)
		supple.global_position = global_position
		supple.global_position.x -= 125.0
		#get_parent().say("Tricked ya!")
		get_parent().editlives(-1)
		queue_free()
