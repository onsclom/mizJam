extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	GameSingleton.curRoot = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	GameSingleton.changeScene(GameSingleton.gameScene)
	pass # Replace with function body.
