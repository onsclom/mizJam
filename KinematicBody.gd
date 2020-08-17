extends KinematicBody

const MOVE_SPEED = 12 
const JUMP_FORCE = 20
const GRAVITY = .98
#9.8
const MAX_FALL_SPEED = 30

const H_LOOK_SENS = .5
const V_LOOK_SENS = .5

var noise = OpenSimplexNoise.new()

onready var cam = $CamHolder

var y_velo = 0

var time = 0

func _ready():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	
	print("Values:")
	print(noise.get_noise_2d(1.0, 1.0))
	print(noise.get_noise_3d(0.5, 3.0, 15.0))
	print(noise.get_noise_4d(0.5, 1.9, 4.7, 0.0))
	
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		cam.rotation_degrees.x -= event.relative.y * V_LOOK_SENS
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * H_LOOK_SENS
	if Input.is_action_just_pressed("left_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	time += delta
	
	
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vec.z -= 1
	if Input.is_action_pressed("move_backwards"):
		move_vec.z += 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_vec *= MOVE_SPEED
	move_vec.y = y_velo
	y_velo = move_and_slide(move_vec, Vector3(0, 1, 0)).y
	
	var grounded = is_on_floor()
	y_velo -= GRAVITY
	var just_jumped = false
	if grounded and Input.is_action_just_pressed("jump"):
		just_jumped = true
		y_velo = JUMP_FORCE
	if grounded and y_velo <= 0:
		y_velo = -0.1
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED
		
	
	var random = floor(noise.get_noise_2d(1.0, time*20)*5)
	$Light1.omni_range = 25.0 + random
	$Light2.omni_range = 35.0 + random
	

