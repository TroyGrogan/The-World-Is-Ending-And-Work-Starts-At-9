extends CharacterBody2D

const SPEED = 60.0
const DAMAGE = 1
const MAX_HEALTH = 2.0
var health = MAX_HEALTH

var direction = 1
var is_near_player = false
var is_flipping = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var detection_area = $DetectionArea
@onready var attack_area = $AttackArea
@onready var hit_area = $HitArea
@onready var groan_audio = $groan_audio
@onready var attack_audio = $attack_audio

var is_attacking = false
var attack_timer = 0.0
const ATTACK_DURATION = 0.6

func _ready():
	$AttackArea/CollisionShape2D.disabled = true

func _physics_process(delta):
	if not is_attacking:
		velocity.x = SPEED * direction
		animated_sprite.flip_h = direction < 0
		attack_area.scale.x = direction
		if !groan_audio.playing:
			groan_audio.play()
		if is_on_wall() and not is_flipping:
			reverse_direction()
	else:
		groan_audio.stop()

	move_and_slide()

	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			end_attack()

func reverse_direction() -> void:
	is_flipping = true
	direction *= -1
	position.x += direction * 5
	await get_tree().create_timer(0.2).timeout
	is_flipping = false

# When the player enters the detection area
func _on_DetectionArea_body_entered(body):
	if body.name == "Player":
		is_near_player = true
		start_attack()

# When the player exits the detection area
func _on_DetectionArea_body_exited(body):
	if body.name == "Player":
		is_near_player = false

# When the player enters the AttackArea
func _on_AttackArea_body_entered(body):
	if body.name == "Player" and is_attacking:
		deal_damage()

# When the player enters the HitArea
func _on_HitArea_body_entered(area):
	if area.name == "AttackArea_1" or area.name == "AttackArea_2":
		take_damage(1)

# Start the attack when the player is near
func start_attack():
	if not is_attacking:
		is_attacking = true
		attack_timer = ATTACK_DURATION
		$AttackArea/CollisionShape2D.call_deferred("set_disabled", false)
		animated_sprite.play("attack")
		attack_audio.play()

		var player_position = get_parent().get_node("Player").global_position
		if player_position.x < global_position.x:
			direction = -1
		else:
			direction = 1

func deal_damage():
	var player = get_parent().get_node("Player")
	player.take_damage(DAMAGE)

# Handle taking damage and dying
func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	print("Zombie defeated!")
	groan_audio.stop()
	queue_free()

# End the attack and reset to walking behavior
func end_attack():
	is_attacking = false
	$AttackArea/CollisionShape2D.disabled = true
	animated_sprite.play("walking")
	groan_audio.play()
