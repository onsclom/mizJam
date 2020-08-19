extends Control

#this syncs the two cameras
onready var viewportCamera = $ViewportContainer2/Viewport/stars/Camera
onready var mainCamera = $ViewportContainer/Viewport/Spatial/Character/Player/CamHolder/CamBase


# Called when the node enters the scene tree for the first time.
func _ready():
	GameSingleton.game = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	viewportCamera.global_transform.basis = mainCamera.global_transform.basis
	pass
