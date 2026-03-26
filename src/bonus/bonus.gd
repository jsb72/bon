extends Node2D

@onready var text_anim: AnimationPlayer = $Node2D/info_bonus/text_anim
@onready var move_y_anim: AnimationPlayer = $Node2D/move_y_anim
@onready var light_effect_anim: AnimationPlayer = $Node2D/sprites/Sprite2D2/light_effect_anim
@onready var fadout_sprit_anim: AnimationPlayer = $Node2D/sprites/fadout_sprit_anim

@export var type_bonus : String = ""
@onready var info_bonus: RichTextLabel = $Node2D/info_bonus
@onready var sprintsprite: Sprite2D = $Node2D/sprites/sprintsprite
@onready var dashsprite: Sprite2D = $Node2D/sprites/dashsprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprintsprite.hide()
	dashsprite.hide()
	if !Global.sprint_unlock:
		if type_bonus == "sprint":
			info_bonus.text = "[color=#FFFFFF]You can now sprint if you keep dash input pressed![/color]"
			sprintsprite.show()
	if !Global.dash_unlock:
		if type_bonus == "dash":
			info_bonus.text = "[color=#FFFFFF]You can now dash with right click or RT button![/color]"
			dashsprite.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func anim():
	move_y_anim.stop()
	light_effect_anim.stop()
	fadout_sprit_anim.play("new_animation")
	text_anim.play("new_animation")
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if !Global.sprint_unlock and type_bonus == "sprint":
			Global.sprint_unlock = true
			anim()

		if !Global.dash_unlock and type_bonus == "dash":
			Global.dash_unlock = true
			anim()
