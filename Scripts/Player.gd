extends KinematicBody2D

const SPEED = 100
const FLOOR = Vector2(0,-1)
const GRAVITY = 12
const JUMP_HEIGHT = 600
const CAST_ENEMY = 22
const CAST_WALL = 10
onready var motion : Vector2 = Vector2.ZERO
onready var enemy = get_tree().get_nodes_in_group("Enemy")[0]
var can_move : bool


var playback: AnimationNodeStateMachinePlayback #enlace con el animation tree

func _ready():
	playback = $AnimationTree.get("parameters/playback")
	playback.start("Estatico")#estado inicial del arbol
	$AnimationTree.active = true #para activar el arbol

func _process(delta):
	motion_ctrl()
	direction_ctrl()
	salto_ctrl()
	ataque_ctrl()
	bloqueo_ctrl()
	 
func get_axis() -> Vector2:
	var axisX = Vector2.ZERO
	var axisY = Vector2.ZERO
	axisX.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axisY.y = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
	return axisX
	return axisY
	
func motion_ctrl():
	motion.y += GRAVITY
	
	if can_move:
		motion.x = get_axis().x * SPEED
		
		if get_axis().x == 0:
			playback.travel("Estatico")
		else:
			playback.travel("Caminar")
		
		if get_axis().x ==1:
				$Sprite.flip_h = false
		elif get_axis().x == -1:
				$Sprite.flip_h = true
			
	motion = move_and_slide(motion,FLOOR)
	
func direction_ctrl():
	match $Sprite.flip_h:
		true:
			$RayWall.cast_to.x = -CAST_WALL
			$RayEnemy.cast_to.x = -CAST_ENEMY
		false:
			$RayWall.cast_to.x = CAST_WALL
			$RayEnemy.cast_to.x = CAST_ENEMY
func salto_ctrl():
	match is_on_floor():
		true:
			can_move = true
			$RayWall.enabled = false
		
			if Input.is_action_just_pressed("Salto"):
				$Sonidos/Jump.play()
				motion.y -= JUMP_HEIGHT
		
		false:
			
			$RayWall.enabled = true
			
			if motion.y < 0:
				playback.travel("Salto")
			
			else:
				playback.travel("Salto")
			
			if $RayWall.is_colliding():
				can_move = false
				
				var col = $RayWall.get_collider()
				
func ataque_ctrl():
	if is_on_floor():
		if get_axis().x == 0 and Input.is_action_just_pressed("Ataque"):
			match playback.get_current_node():
				"Estatico":
					playback.travel("Ataque1")
					$Sonidos/Ataque1.play()
				"Ataque1":
					playback.travel("Ataque2")
					$Sonidos/Ataque2.play()
				"Ataque2":
					playback.travel("Ataque3")
					$Sonidos/Ataque3.play()
		if get_axis().x == 0 and Input.is_action_just_pressed("Combo"):
			match playback.get_current_node():
				"Estatico":
					playback.travel("Combo1")
					$Sonidos/Ataque1.play()
				"Combo1":
					playback.travel("Combo2")
					$Sonidos/Ataque2.play()
				"Combo2":
					playback.travel("Combo3")
					$Sonidos/Ataque3.play()
		
	if playback.get_current_node() == "Ataque1" or playback.get_current_node() == "Ataque2" or playback.get_current_node() == "Ataque3" or playback.get_current_node() == "Combo1" or playback.get_current_node() == "Combo2" or playback.get_current_node() == "Combo3":
		$RayEnemy.enabled = true
	else:
		$RayEnemy.enabled = false
	
	var col = $RayEnemy.get_collider() 
	if $RayEnemy.is_colliding() and col.is_in_group("Enemy"):
		col.queue_free()

func bloqueo_ctrl():
	if Input.is_action_pressed("Bloqueo"):
		playback.travel("Bloqueo")
