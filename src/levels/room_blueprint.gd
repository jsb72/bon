extends Node2D
@onready var player: Player = %Player

@onready var ground: Sprite2D = $lvl1/ground


@onready var zoomcam: PhantomCamera2D = $zoomcam
@onready var cam: PhantomCamera2D = %cam
@onready var cam_2: PhantomCamera2D = %cam2
@onready var camoffesetbottom: PhantomCamera2D = $camoffesetbottom
@onready var camoffesetbottom_2: PhantomCamera2D = %camoffesetbottom2
@onready var dezoomlvl_7: PhantomCamera2D = $dezoomlvl7


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


@onready var intro: Node2D = $intro
@onready var lvl_1: Node2D = $lvl1
@onready var lvl_2: Node2D = $lvl2
@onready var paralaxmulticlolor: Parallax2D = $lvl1/paralaxmulticlolor

var lvl_2_loaded:bool = false

@onready var blackgroundparticle: GPUParticles2D = $lvl1/Parallax2D2/GPUParticles2D


@onready var cadavre: AnimatedSprite2D = $cadavre

@onready var fractale_ciel: RigidBody2D = $fractale_ciel


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
	cam.noise.positional_noise= true
	camoffesetbottom.noise.positional_noise= true
	zoomcam.noise.positional_noise= true
	
	display_list_cadavre()
	
	if !Global.debug_mod: player.global_position = Vector2(0,-2871)
	creer_ground()

	
	#to avoid intro de merde
	if !Global.debug_mod:
		player.hide()
		player.process_mode = Node.PROCESS_MODE_DISABLED
	
	lvl_2.hide()
	lvl_2.process_mode = Node.PROCESS_MODE_DISABLED
	paralaxmulticlolor.hide()

	

var index_music : int = 0
var label_music : String = ""
var volume_music : float = -10.0
func music_player_logic():
	if player.global_position.x < -3562:
		index_music=1
		label_music="noise"
		
	if !lvl_2_loaded:
		if player.global_position.x > -3562:
			index_music=0
			label_music="portal"
		
	if lvl_2_loaded:		
		if player.global_position.x > -3562 and player.global_position.x < 1310:
			index_music=2
			label_music="stimulation"
		if player.global_position.x > 1310:
			index_music=1
			label_music="noise"
			
	if player.global_position.x > 3485 and player.global_position.y > 3002 and player.global_position.x < 4300 and player.global_position.y < 3300:
		index_music=0
		label_music="portal"
		
	if player.global_position.x > 14081 :
		if player.position.y > 372 and player.global_position.y < 5455:
			index_music=1
			label_music="noise"
		if player.global_position.y > 5455:
			index_music=3
			label_music="intense"
			
	if label_music == "portal" :
		if Global.blue_prince:
			index_music=4
			label_music="blue_prince"
			
	if audio_stream_player.get_stream_playback().get_current_clip_index() !=index_music:
		audio_stream_player.get_stream_playback().switch_to_clip_by_name(label_music)
		audio_stream_player.volume_db=volume_music
		
	if Global.buttonturnoff_activated:
		audio_stream_player.stream_paused=true
	
func slowvoid_logic():
	var limit = - 5555
	if player.global_position.x < limit:
		var diff = limit - player.global_position.x
		diff = diff/1000
		if diff >0.9:
			diff = 0.9
		Engine.time_scale = 1 - diff
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
var intro_visible : bool = true
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("start"):
		var f_ = fractale_ciel.duplicate()
		f_.global_position = player.global_position
		f_.global_position.y -= 200
		f_.process_mode = Node.PROCESS_MODE_INHERIT
		f_.visible = true
		$".".add_child(f_)  
	
	if player.global_position.x > 14000:
		blackgroundparticle.hide()
	else:
		blackgroundparticle.show()
	
	"""if last_cad_player_ != null:
		if last_cad_player_.global_position.y < -2990 :
			ladder_completed = true"""
	if player.global_position.y < -4780:
		var diff = -4780 - player.global_position.y
		var ratio = diff*0.0005
		var new_zoom = 1 - ratio
		if new_zoom < 0.026 :
			new_zoom = 0.026
		cam.zoom = Vector2(new_zoom,new_zoom)
		cam_2.zoom = Vector2(new_zoom,new_zoom)
	
	if player.is_on_floor():
		if intro_visible:
			intro_visible = false
			intro.hide()
			intro.process_mode = Node.PROCESS_MODE_DISABLED
			cam.limit_top = -10000000
			cam_2.limit_top = -10000000
		
		
		"""var tween = get_tree().create_tween()
		tween.tween_property(player.point_light_2d, "energy", 1.0, 10.0)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(player.point_light_2d_2, "energy", 1.0, 10.0)"""

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
		Global.arc_en_ciel = true
func _on_camzoneoffset_lvl_5_body_exited(body: Node2D) -> void:
	if body is Player : 
		camoffesetbottom.priority = 0
		camoffesetbottom_2.priority = 0
		
var danslazone7:bool=false
func _on_zoomzonelvl_7_body_entered(body: Node2D) -> void:
	if body is Player : 
		dezoomlvl_7.priority = 10
		danslazone7 = true
func _on_zoomzonelvl_7_body_exited(body: Node2D) -> void:
	if body is Player : 
		dezoomlvl_7.priority = 0
		danslazone7 = false
	
func _on_cinematic_animation_finished() -> void:
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
		
		
		
		
		
		
		
@onready var triangles: Node2D = $intro/triangles
@onready var cinematic: AnimatedSprite2D = $intro/cinematic

@onready var cadavreplayer: CharacterBody2D = $cadavreplayer
var cpt_ : int = 0
func _on_button_body_entered_specific_last_btn_blue_print(body: Node2D) -> void:
	if body is Player:
	
		if danslazone7:
			if !Global.blue_prince : Global.blue_prince = true
			
			var new_cinematic = cinematic.duplicate()
			$".".add_child(new_cinematic)  
			
			await get_tree().create_timer(5).timeout
			#on largue le perso apres la fin de la cinematique
			
			cpt_+=1
			for i in range(0,cpt_):
				if danslazone7:
					var cad_player_ = cadavreplayer.duplicate()
					cad_player_.global_position = Vector2(0,-2904)
					$".".add_child(cad_player_)  
					cad_player_.set_default_anim()
					
					#temps pour passer au tour de boucle suivant
					await get_tree().create_timer(1).timeout
					
			new_cinematic.queue_free()
			
		
		
		


func _on_button_TURNOFF_body_entered(body: Node2D) -> void:
	if body is Player:
		await get_tree().create_timer(0.5).timeout
		Global.buttonturnoff_activated = true
		player.process_mode = Node.PROCESS_MODE_DISABLED
		
		
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://src/generique.tscn")
		
		
		
		
		
@onready var triangle_platform: Node2D = $lvl1/SECRET/triangle_platform

func gen_sierpinski() -> void:
	#under
	var triangle_2 = triangle_platform.duplicate()
	triangle_2.global_position += Vector2(112*4,120*4)
	$".".add_child(triangle_2)  
	
	#lvl1
	var triangle_ = triangle_platform.duplicate()
	triangle_.global_position += Vector2(-112*4,-120*4)
	$".".add_child(triangle_)  
	
	var triangle_3 = triangle_platform.duplicate()
	triangle_3.global_position += Vector2(112*4,-120*4)
	$".".add_child(triangle_3)  
	
	
	#milieu supp
	var triangle_4 = triangle_platform.duplicate()
	triangle_4.global_position += Vector2(0,-120*4*2)
	$".".add_child(triangle_4)  
	#milieu supp-1
	var triangle_5 = triangle_platform.duplicate()
	triangle_5.global_position += Vector2(-112*4-112*2,-120*4*2)
	$".".add_child(triangle_5)  
	#milieu supp+1
	var triangle_6 = triangle_platform.duplicate()
	triangle_6.global_position += Vector2(112*4+112*2,-120*4*2)
	$".".add_child(triangle_6)  
	
	


func _on_bouton_o_rzone_body_entered(body: Node2D) -> void:
	if body is Player:
		var tween = get_tree().create_tween()
		tween.tween_property(player.point_light_2d, "energy", 0.0, 1.0)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(player.point_light_2d_2, "energy", 0.0, 1.0)


func _on_bouton_o_rzone_body_exited(body: Node2D) -> void:
	if body is Player:
		var tween = get_tree().create_tween()
		tween.tween_property(player.point_light_2d, "energy", 1.0, 1.0)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(player.point_light_2d_2, "energy", 1.0, 1.0)


func _on_novisibleplayerzone_body_entered(body: Node2D) -> void:
	if body is Player:
		body.sprite.hide()


func _on_novisibleplayerzone_body_exited(body: Node2D) -> void:
	if body is Player:
		body.sprite.show()
