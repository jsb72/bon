extends Node2D
@onready var player: Player = %Player

@onready var ground: Sprite2D = $lvl1/ground

@onready var zoomcam: PhantomCamera2D = $zoomcam
@onready var cam: PhantomCamera2D = %cam
@onready var cam_2: PhantomCamera2D = %cam2
@onready var camoffesetbottom: PhantomCamera2D = $camoffesetbottom
@onready var camoffesetbottom_2: PhantomCamera2D = %camoffesetbottom2

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var canvas_modulate: CanvasModulate = $CanvasModulate

@onready var intro: Node2D = $intro
@onready var lvl_1: Node2D = $lvl1
@onready var lvl_2: Node2D = $lvl2
@onready var paralaxmulticlolor: Parallax2D = $lvl1/paralaxmulticlolor

var lvl_2_loaded:bool = false


@onready var cadavre: AnimatedSprite2D = $cadavre

func display_list_cadavre():
	for cadavre_elem in Global.list_des_morts:
		var cad = cadavre.duplicate()
		cad.global_position = cadavre_elem
		cad.global_position.y -= 36
		$".".add_child(cad)  

func duplicate_room1(offset_x):
	var r = ground.duplicate()
	r.position.x = r.position.x + offset_x 
	r.z_index = r.z_index -1
	$".".add_child(r)  

func creer_ground():
	var len = 0.274 * 13902
	for i in range(10):
		duplicate_room1(i*len)
	ground.hide()
	ground.process_mode = Node.PROCESS_MODE_DISABLED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_list_cadavre()
	
	#player.global_position = Vector2(0,-2876.0)
	creer_ground()

	canvas_modulate.hide()
	player.hide()
	player.process_mode = Node.PROCESS_MODE_DISABLED
	lvl_2.hide()
	lvl_2.process_mode = Node.PROCESS_MODE_DISABLED
	paralaxmulticlolor.hide()

func music_player_logic():
	if player.position.x > 14081 and player.position.y > 372 :
		if audio_stream_player.get_stream_playback().get_current_clip_index() !=1:
			audio_stream_player.get_stream_playback().switch_to_clip_by_name("noise")
			audio_stream_player.volume_db=-10.0
	
	if player.position.x < -3562:
		if audio_stream_player.get_stream_playback().get_current_clip_index() !=1:
			audio_stream_player.get_stream_playback().switch_to_clip_by_name("noise")
			audio_stream_player.volume_db=-10.0
			
	if player.position.x > -3562:
		if lvl_2_loaded :
			if audio_stream_player.get_stream_playback().get_current_clip_index() !=2:
				audio_stream_player.get_stream_playback().switch_to_clip_by_name("stimulation")
				audio_stream_player.volume_db=-15.0
	

	
func slowvoid_logic():
	var limit = - 5555
	if player.global_position.x < limit:
		var diff = limit - player.global_position.x
		diff = diff/1000
		if diff >0.9:
			diff = 0.9
		Engine.time_scale = 1 - diff
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.is_on_floor():
		intro.hide()
		intro.process_mode = Node.PROCESS_MODE_DISABLED
		cam.limit_top = -10000000
		cam_2.limit_top = -10000000

	if !audio_stream_player.playing:
		audio_stream_player.play()

	if Global.arc_en_ciel and !paralaxmulticlolor.visible:
		paralaxmulticlolor.show()
		
	music_player_logic()
	slowvoid_logic()

#CAMERA LOGIC
func _on_zoom_zone_body_entered(body: Node2D) -> void:
	if body is Player : zoomcam.priority = 10
func _on_zoom_zone_body_exited(body: Node2D) -> void:
	if body is Player : zoomcam.priority = 0
func _on_no_bottom_offset_zone_body_entered(body: Node2D) -> void:
	if body is Player : camoffesetbottom.priority = 10
func _on_no_bottom_offset_zone_body_exited(body: Node2D) -> void:
	if body is Player : 
		camoffesetbottom.priority = 0
		camoffesetbottom_2.priority = 0
#CAMERA LOGIC FOR LVL2
func _on_no_offset_zone_lvl_2_body_entered(body: Node2D) -> void:
	if body is Player : camoffesetbottom.priority = 10
func _on_no_offset_zone_lvl_2_body_exited(body: Node2D) -> void:
	if body is Player : 
		camoffesetbottom.priority = 0
		camoffesetbottom_2.priority = 0
#CAMERA LOGIC FOR LVL4
func _on_cam_off_zone_lvl_4_body_entered(body: Node2D) -> void:
	if body is Player : 
		camoffesetbottom.priority = 10
		cam.limit_right = 26240
		cam_2.limit_right = 26240
func _on_cam_off_zone_lvl_4_body_exited(body: Node2D) -> void:
	if body is Player : 
		camoffesetbottom.priority = 0
		camoffesetbottom_2.priority = 0
		
func _on_camzoneoffset_lvl_5_body_entered(body: Node2D) -> void:
	if body is Player : 
		camoffesetbottom.priority = 10
func _on_camzoneoffset_lvl_5_body_exited(body: Node2D) -> void:
	if body is Player : 
		camoffesetbottom.priority = 0
		camoffesetbottom_2.priority = 0
	
func _on_cinematic_animation_finished() -> void:
	canvas_modulate.show()
	player.show()
	player.process_mode = Node.PROCESS_MODE_INHERIT

func _on_change_scene_whenvoid_body_entered(body: Node2D) -> void:
	if body is Player:
		if !lvl_2_loaded:
			lvl_1.hide()
			lvl_1.process_mode = Node.PROCESS_MODE_DISABLED
			lvl_2.show()
			lvl_2.process_mode = Node.PROCESS_MODE_INHERIT
			
			lvl_2_loaded = true
	
func _on_change_scene_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		if !lvl_2_loaded:
			lvl_1.hide()
			lvl_1.process_mode = Node.PROCESS_MODE_DISABLED
			lvl_2.show()
			lvl_2.process_mode = Node.PROCESS_MODE_INHERIT
			
			lvl_2_loaded = true

func _on_change_scene_zone_2_lvl_3_body_entered(body: Node2D) -> void:
	if body is Player:
		if lvl_2_loaded:
			lvl_1.show()
			lvl_1.process_mode = Node.PROCESS_MODE_INHERIT
			lvl_2.hide()
			lvl_2.process_mode = Node.PROCESS_MODE_DISABLED
			
			lvl_2_loaded = false
			
			Global.arc_en_ciel = true


func _on_deathzone_body_entered(body: Node2D) -> void:
	if body is Player:
		player.respawn()
		
