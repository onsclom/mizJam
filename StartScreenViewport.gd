extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var fade = $CanvasLayer/Fade
var started = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("click") and not started:
		started = true
		fade.play("FadeOut")
		Startup.playing = true
	pass


func _on_Fade_animation_finished(anim_name):
	#when animation finishes, go to control screne
	GameSingleton.changeScene(GameSingleton.controls)
	pass # Replace with function body.
