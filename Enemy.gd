extends KinematicBody


var player

var MOVE_SPEED = 1
var speedIncreasePerSecond = .2
var lives = 1

var warningRange = 4
var warningTime = .5
var warned = false
var warning = false
var warningCount = 0

var respawnDist = 60

var dead = false
var maxDist = 70

var stepCounter = 0
var stepSoundTime = .1

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	player = GameSingleton.player
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#MOVE_SPEED += speedIncreasePerSecond*delta
	
	if dead:
		return
		
	if lives == 0:
		dead = true
		lives = -1 #makes it so this doesnt happen again
		
		MOVE_SPEED = 0
		$MeshInstance.visible = false
		$CollisionShape.disabled = true
		$CPUParticles.emitting = true
		
		yield(get_tree().create_timer(2.0), "timeout")
		queue_free()
		
	stepCounter += delta
	if stepCounter >= stepSoundTime:
		$walking.playing = true
		stepCounter -= stepSoundTime
		
	#$Area/CollisionShape2.disabled = false
	var distToPlayer = player.global_transform.origin.distance_to(global_transform.origin)
	if distToPlayer > maxDist:
		teleportInFront()
		queue_free()
	elif warned == false and distToPlayer < warningRange:
		$screech.playing = true
		warned = true
		$Area/CollisionShape2.disabled = true
	
	
	if warned and warningCount<warningTime:
		warningCount += delta
		if warningCount>warningTime:
			$Area/CollisionShape2.disabled = false
		return
		
	
	var dest = player.global_transform.origin + player.dir.normalized()*player.global_transform.origin.distance_to(global_transform.origin)*(player.MOVE_SPEED/GameSingleton.scorpSpeed)
	
	if global_transform.origin.distance_to(Vector3(dest.x, global_transform.origin.y, dest.z)) <= GameSingleton.scorpSpeed:
		dest = player.global_transform.origin
	
	var x = dest.x - global_transform.origin.x
	var z = dest.z - global_transform.origin.z
	var move_vec = Vector3(x,0,z)
	move_vec = move_vec.normalized()

	move_and_slide(move_vec * MOVE_SPEED * GameSingleton.scorpSpeed - Vector3(0,50,0), Vector3(0, 1, 0))

#for debugging 		
#	if Input.is_action_just_pressed("jump"):
#		teleportInFront()
		
func teleportInFront():
	
	var dir = -1* GameSingleton.player.global_transform.basis.z
	dir = dir.normalized()
	
	GameSingleton.makeScorp(dir)
	queue_free()
	


func _on_Area_body_entered(body):
	if not dead and body.name == "Player":
		body.death()
