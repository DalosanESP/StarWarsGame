extends Area2D

export var PixelesPorSegundo : int = -50

func _ready():
	pass

func _process(delta):
	position.x += PixelesPorSegundo * delta
		
	if position.y > 600:
		queue_free()

