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

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	speed = rng.randf_range(.1,.5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	curtime += delta
	pixel_size = size + sin(speed*curtime)*variance
