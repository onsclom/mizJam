extends KinematicBody


var player

var MOVE_SPEED = 25
var speedIncreasePerSecond = 0
var lives = 1

var respawnDist = 60

var dead = false
var maxDist = 70

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	player = GameSingleton.player
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	MOVE_SPEED += speedIncreasePerSecond*delta
	
	if dead:
		return
	
	if player.global_transform.origin.distance_to(global_transform.origin) > maxDist:
		GameSingleton.makeScorp(2)
		queue_free()
		
	var x = player.global_transform.origin.x - global_transform.origin.x
	var z = player.global_transform.origin.z - global_transform.origin.z
	var move_vec = Vector3(x,-50,z)
	
	move_vec = move_vec.normalized()
	
	move_and_slide(move_vec * MOVE_SPEED, Vector3(0, 1, 0))
	
	
	if lives == 0:
		dead = true
		lives = -1 #makes it so this doesnt happen again
		
		MOVE_SPEED = 0
		$MeshInstance.visible = false
		$CollisionShape.disabled = true
		$CPUParticles.emitting = true
		
		yield(get_tree().create_timer(2.0), "timeout")
		queue_free()
		
func teleportInFront():
	print("TELEPORTING IN FRONT?")
	
	var dir = GameSingleton.player.global_transform.basis.z
	dir = dir.normalized()
	
	GameSingleton.makeScorp(dir)
	queue_free()
	


func _on_Area_body_entered(body):
	if not dead and body.name == "Player":
		body.death()
