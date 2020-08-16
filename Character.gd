extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var PlayerCam = $KinematicBody/CamHolder
onready var LagCam = $CameraLag
onready var Ray = $KinematicBody/CamHolder/CamBase/RayCast
onready var hoverInfo = $CanvasLayer/CenterContainer/Label

onready var gun = $CameraLag/Gun
onready var gunParticles = $CameraLag/Gun/CPUParticles

onready var screenshakeCam = $KinematicBody/CamHolder/CamBase

onready var mouseFocused = false

func _input(event):
	
	if event.is_action_pressed("click"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	LagCam.global_transform.origin = PlayerCam.global_transform.origin
	
	var a = LagCam.global_transform.basis.get_rotation_quat()
	var b = PlayerCam.global_transform.basis.get_rotation_quat()
	var c = a.slerp(b,.1)
	LagCam.global_transform.basis = Basis(c)
	pass
	
	hoverInfo.visible = false
	if Ray.is_colliding():
		if "hoverText" in Ray.get_collider() and Ray.get_collider().hoverText != null:
			hoverInfo.text = Ray.get_collider().hoverText
			hoverInfo.visible = true
			
			if Input.is_action_just_pressed("use"):
				Ray.get_collider().activate(self)
				print("USED")
				
	if Input.is_action_just_pressed("click"):
		shoot()
		
		
	mouseFocused = Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED

func activateGun():
	gun.visible = true

func shoot():
	if mouseFocused == false:
		return
	if gun.visible == true:
		print("wow")
		screenshakeCam.add_trauma(1.0)
	if gun.visible == true:
		gunParticles.restart()
		gunParticles.emitting = true
