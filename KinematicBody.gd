extends KinematicBody

const MOVE_SPEED = 12 
const JUMP_FORCE = 20
const GRAVITY = .98
#9.8
const MAX_FALL_SPEED = 30

const H_LOOK_SENS = .5
const V_LOOK_SENS = .5

var runningMod = 1.5

var noise = OpenSimplexNoise.new()

onready var cam = $CamHolder

var stepCounter = 0
var stepSoundTime = .25
onready var stepSound = $StepSound

var running = false

var y_velo = 0

var time = 0

var energy = 100
var maxEnergy = 100
var energyFillRate = 20
var energyUseRate = 50


func _ready():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	
	GameSingleton.player = self
	pass

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		cam.rotation_degrees.x -= event.relative.y * V_LOOK_SENS
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * H_LOOK_SENS
	if Input.is_action_just_pressed("left_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if get_parent().alive == false:
		return
	
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
	
	var running = false
	if ( Input.is_action_pressed("run") or Input.is_action_pressed("jump") ) and move_vec != Vector3(0.0,0.0,0.0):
		if energy > 0:
			move_vec *= runningMod
			energy -= delta*50.0
			energy = max(0, energy)
			running = true
		#else walking
		
	else:
		energy += delta * 20
		energy = min(maxEnergy, energy)
		#walking
		
	if move_vec != Vector3(0.0,0.0,0.0):
		get_parent().walking = true
		stepCounter += delta
		if running and ( stepCounter > (stepSoundTime / runningMod) ):
			stepCounter -= (stepSoundTime/runningMod)
			$StepSound.playing = true
		elif stepCounter > stepSoundTime:
			stepCounter -= stepSoundTime
			$StepSound.playing = true
	else:
		get_parent().walking = false
	
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_vec *= MOVE_SPEED
	move_vec.y = y_velo
	y_velo = move_and_slide(move_vec, Vector3(0, 1, 0)).y
	
	var grounded = is_on_floor()
	y_velo -= GRAVITY
	var just_jumped = false
#	if grounded and Input.is_action_just_pressed("jump"):
#		just_jumped = true
#		y_velo = JUMP_FORCE
	if grounded and y_velo <= 0:
		y_velo = -0.1
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED
		
	
	var random = floor(noise.get_noise_2d(1.0, time*20)*5)
	$Light1.omni_range = 25.0 + random
	$Light2.omni_range = 35.0 + random
	
func death():
	get_parent().death()
