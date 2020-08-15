extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var PlayerCam = $KinematicBody/CamBase
onready var LagCam = $CameraLag

func _input(event):
	if event.is_action_pressed("click"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	LagCam.global_transform.origin = PlayerCam.global_transform.origin
	
	var a = Quat(LagCam.global_transform.basis)
	var b = Quat(PlayerCam.global_transform.basis)
	var c = a.slerp(b,.1)
	LagCam.global_transform.basis = Basis(c)
	pass
