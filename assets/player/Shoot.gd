extends Area2D

var player : CharacterBody2D
const SPEED = 180

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	player.can_shoot = false
	$AnimatedSprite2D.play()
	$SoundShoot.play()

func _physics_process(delta):
	position.y -= SPEED * delta

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	player.can_shoot = true
	queue_free() 
