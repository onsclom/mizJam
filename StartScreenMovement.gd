extends KinematicBody

var moveSpeed = -10

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform.origin += Vector3(0,0,moveSpeed*delta)
	pass
