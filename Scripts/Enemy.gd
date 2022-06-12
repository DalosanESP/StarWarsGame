extends KinematicBody2D

const DISPARO = preload("res://Escenas/Disparo.tscn")
export var pixelesPorSegundo : int = - 50
var velocidadActual = pixelesPorSegundo

export(int,1,10) var health: int = 3

onready var distancia = get_tree().get_nodes_in_group("Enemy")[0]

func _ready():
	$AnimationPlayer.play("Caminar")

func _process(delta):
	position.x += velocidadActual * delta
	if position.x < 0 or position.x > 600:
		velocidadActual = - velocidadActual
	if health <= 0:
		queue_free()
		
func damage_ctrl():
	health -=1

func disparo():
	var disparo = DISPARO.instance()
	disparo.position = position
	get_parent().add_child(disparo)
	
	var distancia = $Distancia.get_collider() 
	if $Distancia.is_colliding():
		distancia.queue_free() 
	
	  
