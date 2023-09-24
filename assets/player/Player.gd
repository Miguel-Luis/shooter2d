extends CharacterBody2D

@export var Shoot : PackedScene

const SPEED = 100
var motion = Vector2.ZERO # Es lo mismo que poner Vector2(0, 0)
var can_shoot : bool = true
var screen_size

func _ready():
	$AnimatedSprite2D.play()
	screen_size = get_viewport_rect().size  # Tamaño de la ventana
	
func _physics_process(delta):
	motion_ctrl()
	animation_ctrl()
	motion = move_and_collide(motion * delta)
	
func _input(event):
	if event.is_action_pressed("ui_accept") and can_shoot:
		shoot_ctrl()

# Obtener ejes.
func get_axis() -> Vector2:
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis

# Controlador de movimiento.
func motion_ctrl():
	if get_axis() == Vector2.ZERO:
		motion =  Vector2.ZERO
	else:
		motion = get_axis().normalized() * SPEED
	
	# Limpiar movimiento del personaje.
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

# Controlador de animaciones
func animation_ctrl():
	if get_axis().x == 1:
		$AnimatedSprite2D.animation = "Horizontal"
		$AnimatedSprite2D.flip_h = true
	elif get_axis().x == -1:
		$AnimatedSprite2D.animation = "Horizontal"
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.animation = "Vertical"

# Controlador de disparos
func shoot_ctrl():
	var shoot = Shoot.instantiate()
	shoot.global_position = $ShootSpaw.global_position
	get_tree().call_group("level", "add_child", shoot)
