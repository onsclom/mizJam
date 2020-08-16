extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var mainCamera = $Character/KinematicBody/CamHolder/CamBase
onready var viewportCamera = $ViewportContainer/Viewport/stars/Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	viewportCamera.global_transform.basis = mainCamera.global_transform.basis
