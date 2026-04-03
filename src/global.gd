extends Node

var debug_mod:bool=true

var nb_fractal:int = 0

var door_opened:bool = false
var door2_opened:bool = false
var cube_opened : bool = false

var arc_en_ciel:bool = false

var dash_unlock:bool = false
var sprint_unlock:bool = false
var doublejump_unlock:bool = false

var banane:bool =false

var list_des_morts: Array[Vector2]

var blue_prince : bool = false

var buttonturnoff_activated : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("escape"):
		get_tree().quit()
	
	if debug_mod:
		nb_fractal=3
		dash_unlock = true
		sprint_unlock = true
		doublejump_unlock = true
		arc_en_ciel = true
		blue_prince = true
	"""if Input.is_action_just_pressed("start") and !buttonturnoff_activated:
		get_tree().reload_current_scene()
		nb_fractal = 0
		banane=false
		buttonturnoff_activated=false"""
		

		
		
		
		
		
		
