extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hoverText = "e to open"
var openTexture = preload("res://Art/chestOpen.png")

#0 is gun chest
#1 is bullet chest
export var type = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func activate(player):
	hoverText = null
	get_parent().mesh.material.albedo_texture = openTexture
	if type == 0:
		player.activateGun()
	else:
		player.ammo += 4
	get_parent().queue_free()
	#this also makes it unusable
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
