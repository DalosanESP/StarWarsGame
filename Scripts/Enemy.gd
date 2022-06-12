extends KinematicBody2D


export var pixelesPorSegundo : int = - 20
var velocidadActual = pixelesPorSegundo

export(int,1,10) var health: int = 3

onready var distancia = get_tree().get_nodes_in_group("Enemy")[0]

func _ready():
	$AnimationPlayer.play("Caminar")

func _process(delta):
	position.x += velocidadActual * delta
	if position.x < 50 or position.x > 600:
		velocidadActual = - velocidadActual
	if health <= 0:
		queue_free()
		
func damage_ctrl():
	health -=1

	
	  
