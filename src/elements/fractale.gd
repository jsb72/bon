extends Node2D

@onready var touchedsong: AudioStreamPlayer2D = $touchedsong
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

var touched = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !touched:
		touched = true
		touchedsong.play()
		animation_player.play("disapear")
		
		body.shakecamtimer.start()
		



func _on_touchedsong_finished() -> void:
	queue_free()
	Global.nb_fractal +=1
