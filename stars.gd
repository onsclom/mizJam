extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var starAmount = 250
var star = preload("res://star.tscn")
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.

export var startScreen = false
func _ready():
	rng.randomize()
	for x in range(starAmount):
		var pos = Vector3(rng.randf_range(-1,1),rng.randf_range(-1,1),rng.randf_range(-1,1))
		pos = pos.normalized()
		var newStar = star.instance()
		add_child(newStar)
		newStar.transform.origin = pos*5
		
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if get_node("../Camera2")!=null:
	#	rotation_degrees.z = -get_node("../Camera2").rotation_degrees.z
	
	if startScreen:
		$Camera.rotation_degrees.x += delta*1
		$Camera.rotation_degrees.z += delta*1
	pass
