extends Sprite3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var size = .06
var rng := RandomNumberGenerator.new()
var speed = 0
var curtime = 0
#var variance = .02
var variance = 0
var specialTextures = [preload("res://Art/specialStar/big.png"),preload("res://Art/specialStar/bigBlue.png"),preload("res://Art/specialStar/blueSpecial.png"),preload("res://Art/specialStar/specialStar.png")]

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	if rng.randf_range(0,1.0) > .8:
		texture = specialTextures[randi()%specialTextures.size()]
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	curtime += delta
