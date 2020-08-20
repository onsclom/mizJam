extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var PlayerCam = $Player/CamHolder
onready var LagCam = $CameraLag
onready var Ray = $Player/CamHolder/CamBase/RayCast
onready var hoverInfo = $CanvasLayer/CenterContainer/Label

onready var gun = $CameraLag/Gun
onready var gunParticles = $CameraLag/Gun/CPUParticles

onready var screenshakeCam = $Player/CamHolder/CamBase

onready var mouseFocused = false

onready var progressBar = $CanvasLayer/ProgressBar
onready var player = $Player

onready var gunRay = $Player/CamHolder/CamBase/GunRay

onready var deathScreen = $CanvasLayer/DeathScreen
onready var ammoLabel = $CanvasLayer/ammo

var alive = true
var walking = false

var ammo = 10

func _input(event):
	
	if event.is_action_pressed("click"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Called when the node enters the scene tree for the first time.
func _ready():
	#GameSingleton.player = self
	LagCam.global_transform.origin = PlayerCam.global_transform.origin
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not alive:
		return
	
	LagCam.global_transform.origin.x = PlayerCam.global_transform.origin.x
	LagCam.global_transform.origin.z = PlayerCam.global_transform.origin.z
	LagCam.startHeight = PlayerCam.global_transform.origin.y
	
	var a = LagCam.global_transform.basis.get_rotation_quat()
	var b = PlayerCam.global_transform.basis.get_rotation_quat()
	var c = a.slerp(b,.4)
	LagCam.global_transform.basis = Basis(c)
	pass
	
	hoverInfo.visible = false
	if Ray.is_colliding():
		if "hoverText" in Ray.get_collider() and Ray.get_collider().hoverText != null:
			hoverInfo.text = Ray.get_collider().hoverText
			hoverInfo.visible = true
			
			if Input.is_action_just_pressed("use"):
				Ray.get_collider().activate(self)
				$chestSound.playing = true
				
	if Input.is_action_just_pressed("click"):
		shoot()
		
		
	mouseFocused = Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	progressBar.value = round(player.energy/player.maxEnergy*100)

func activateGun():
	ammoLabel.visible = true
	gun.visible = true

func shoot():
	if mouseFocused == false or not gun.visible:
		return
		
	if ammo <= 0:
		#PLAY OUT OF AMMO SOUND
		return
	ammo -= 1
	
	screenshakeCam.add_trauma(1.0)
	gunParticles.restart()
	gunParticles.emitting = true
	$ShootSound.playing = true
		
	var collider = gunRay.get_collider()
	if collider != null:
		if "lives" in collider:
			collider.lives -= 1
			#change this to death later probly
			GameSingleton.score += 1
			#play hit sound?
			$hitSound.playing = true
			$Player.energy += 20
			$Player.energy = min($Player.energy, $Player.maxEnergy)
			

func death():
	if not alive:
		return
	$deathSound.playing = true
	$Player/CamHolder/CamBase.add_trauma(1.0)
	alive = false
	print("dead in player")
	deathScreen.visible = true
