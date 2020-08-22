extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lastSens
var showTime = 2
var changedSince = showTime

export var activePos = Vector2() 
export var inactivePos = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	lastSens = GameSingleton.playerSens

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lastSens != GameSingleton.playerSens:
		lastSens = GameSingleton.playerSens
		changedSince = 0 
		
	changedSince += delta
		
	if changedSince < showTime:
		rect_position=rect_position.linear_interpolate(activePos,delta*10)
	else:
		rect_position=rect_position.linear_interpolate(inactivePos,delta*10)
		
		
	text = "[-] " + str(GameSingleton.playerSens) + "/10 [+]"
