extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var gameScene = preload("res://ViewportSolution.tscn")
var scorpion = preload("res://Scorpion.tscn")
var game
var score = 0
var curRoot = null

var playerSens = 5

var rng = RandomNumberGenerator.new()
var monsterSpawnDist = 60

var origScorpSpeed = 11.0
var scorpSpeed = origScorpSpeed
var maxScorpSpeed = 20.0
var scorpIncreasePerSec = .025

var firstTime = true

var gameStarted = false

var controls = preload("res://Controls.tscn")

func _input(event):
	if event.is_action_pressed("click"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	GameSingleton.curRoot = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if gameStarted:
		scorpSpeed = lerp(scorpSpeed, maxScorpSpeed, .025*delta)
	
	if player == null:
		return
	
	if player.get_parent().alive == false and Input.is_action_just_pressed("restart"):
		changeScene(gameScene)
		score = 0
		scorpSpeed = origScorpSpeed
		
	if Input.is_action_just_pressed("+"):
		playerSens+=1
	elif Input.is_action_just_pressed("-"):
		playerSens-=1
		
	playerSens = clamp(playerSens, 0, 10)

func makeScorp(dir):
	var newScorp = scorpion.instance()
	var rand_x = rng.randf_range(-1, 1)
	var rand_z = rng.randf_range(-1, 1)
	var offset = Vector3(rand_x, 0, rand_z)
	offset = offset.normalized()
	dir = dir.rotated(Vector3(0,1,0), rng.randf_range(-1,1))
	newScorp.global_transform.origin = player.global_transform.origin + dir * monsterSpawnDist
	
	
	curRoot.add_child(newScorp)

func changeScene(scene):
	scorpSpeed = origScorpSpeed
	gameStarted = false
	curRoot.get_tree().change_scene_to(scene)
