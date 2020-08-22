extends AnimationPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var addAmount = 0
var timeSinceChanged = 0
var timeKeep = 3

export var colors = [Color()]
var curColor = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	timeSinceChanged += delta
	if timeSinceChanged > timeKeep:
		addAmount = 0
	$ammoAddLabel.text = "+ " + str(addAmount)
	pass
	
func addAmmo(time):
	curColor += 1
	$ammoAddLabel.self_modulate = colors[randi() % colors.size()]
	stop()
	play("ammoAdd")
	$particles.restart()
	$particles.emitting = true
	addAmount += time
	timeSinceChanged = 0
