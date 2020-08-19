extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var startHeight
var totalTime = 0
var lastOffset = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	totalTime += delta
	if startHeight != null and get_parent().walking:
		global_transform.origin.y = startHeight + sin(totalTime*5)*.05
		lastOffset = sin(totalTime*5)*.05
		#print(global_transform.origin.y)
	else:
		lastOffset = lerp(lastOffset, 0.0, 0.1)
		global_transform.origin.y = startHeight + lastOffset
		totalTime = 0
	
