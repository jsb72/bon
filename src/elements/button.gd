extends Node2D

@onready var animation_player: AnimationPlayer = $Sprite2D2/AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var pushed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if !pushed :
			animation_player.play("new_animation")
			audio_stream_player_2d.play()
			pushed = true


func _on_body_exited(body: Node2D) -> void:
	pass
