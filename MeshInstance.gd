extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var textures = [preload("res://Art/torchAnim/torch1.png"),preload("res://Art/torchAnim/torch2.png"),preload("res://Art/torchAnim/torch3.png"),preload("res://Art/torchAnim/torch4.png")]
var elapsed = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed += delta
	var tick = floor(elapsed/.3)
	get_mesh().get_material().albedo_texture = textures[int(tick)%4]
	pass
