extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var mainCamera = $Character/Player/CamHolder/CamBase
onready var viewportCamera = $ViewportContainer/Viewport/stars/Camera

var noise = OpenSimplexNoise.new()

onready var player = $Character/Player
var chunkSize = 80.0

var chunkSubAmount = 10

var scorpion = preload("res://Scorpion.tscn")
var chunkScene = preload("res://Chunk.tscn")

var cactusScene = preload("res://Cactus.tscn")
var groundScene = preload("res://Ground.tscn")
var chestScene = preload("res://Chest.tscn")

var mountainScenes = [preload("res://Mountains1.tscn"),preload("res://Mountains2.tscn"),preload("res://Mountains3.tscn")]

var rng = RandomNumberGenerator.new()

export var spawnTime = 3
var minSpawnTime = 1
#spawnTime will be decreased by spawnTime*spawnSpeedup every second
var spawnSpeedup = 0
var spawnCount = 0
var monsterSpawnDist = 60

onready var chunks = {
	Vector2(0,0): $Chunk
}

var currentlyActive = {
	Vector2(0,0):true
}

# Called when the node enters the scene tree for the first time.
func _ready():
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 40.0
	noise.persistence = 0.8
	
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawnTime != -1:
		spawnTime = lerp(spawnTime, minSpawnTime, .025*delta)
	#sync the background star world and current world
	
	var playerGridPos = Vector2(player.global_transform.origin.x / chunkSize, player.global_transform.origin.z / chunkSize)
	var roundedGridPos = Vector2( int(round(playerGridPos.x)), int(round(playerGridPos.y )) )
	
	var neighbors = [Vector2(0,0),Vector2(-1,1),Vector2(0,1),Vector2(1,1),Vector2(1,0),Vector2(1,-1),Vector2(0,-1),Vector2(-1,-1),Vector2(-1,0)]
	#print(roundedGridPos)
	
	var shouldBeActive = {}
	
	for neighbor in neighbors:
		var curPos = roundedGridPos + neighbor
		if curPos in chunks and chunks[curPos] != null:
			chunks[curPos].visible = true
		else:
			var newChunk = chunkScene.instance()
			add_child(newChunk)
			newChunk.transform.origin = Vector3(curPos.x * chunkSize, 0, curPos.y * chunkSize)
			chunks[curPos] = newChunk
			
			#generate stuff for that chunk
			chunkStuffGenerate(newChunk, curPos)
			
		currentlyActive[curPos]=true
		shouldBeActive[curPos] = true
		
	for vector in currentlyActive.keys():
		if (vector in shouldBeActive) == false:
			if chunks[vector] != null:
				chunks[vector].visible = false
				currentlyActive.erase(vector)
	
	
	if GameSingleton.gameStarted:			
		spawnCount += delta
		spawnTime -= spawnSpeedup*spawnTime*delta
		
		
		monsterSpawning()
	
func monsterSpawning():
	if spawnTime <= -1:
		return
	if $Character.alive and spawnCount > spawnTime:
		spawnCount -= spawnTime
		var newScorp = scorpion.instance()
		add_child(newScorp)
		var rand_x = rng.randf_range(-1, 1)
		var rand_z = rng.randf_range(-1, 1)
		var offset = Vector3(rand_x, 0, rand_z)
		offset = offset.normalized()
		newScorp.global_transform.origin = player.global_transform.origin + offset * monsterSpawnDist
				
func chunkStuffGenerate(chunk, vector):
	for x in range(chunkSubAmount):
		for z in range(chunkSubAmount):
			var localPos = Vector2(x*(chunkSize/chunkSubAmount)+(chunkSize/chunkSubAmount)*.5, z*(chunkSize/chunkSubAmount)+(chunkSize/chunkSubAmount)*.5)
			localPos -= Vector2(chunkSize,chunkSize)/2
			var globalPos = Vector2(localPos.x + chunkSize*vector.x, localPos.y + chunkSize*vector.y)
			
			var noiseVal = noise.get_noise_2d(globalPos.x, globalPos.y)  
			
			if noiseVal < .15 and noiseVal > -.15:
				var newGround = groundScene.instance()
				chunk.add_child(newGround)
				newGround.transform.origin.x = localPos.x
				newGround.transform.origin.z = localPos.y
			else:
				#if no path then maybe make cactus?
				if rng.randf_range(0.0,1.0) > .9:
					var newCact = cactusScene.instance()
					chunk.add_child(newCact)
					newCact.transform.origin.x = localPos.x
					newCact.transform.origin.z = localPos.y
				elif rng.randf_range(0.0,1.0) > .975:
					var newMount = mountainScenes[randi()%mountainScenes.size()].instance()
					chunk.add_child(newMount)
					newMount.transform.origin.x = localPos.x
					newMount.transform.origin.z = localPos.y
				elif rng.randf_range(0.0,1.0) > .97:
					var newChest = chestScene.instance()
					chunk.add_child(newChest)
					newChest.transform.origin.x = localPos.x
					newChest.transform.origin.z = localPos.y
					newChest.get_node("Chest").type = 1
			
			
	
	
	
	
