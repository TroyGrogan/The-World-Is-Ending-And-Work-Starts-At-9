extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const MAX_HEALTH = 5.0  # Full health with 5 hearts

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_area_1 = $AttackArea_1
@onready var attack_area_2 = $AttackArea_2
@onready var respawn_point = get_parent().get_node("RespawnPoint")

var health = MAX_HEALTH
var is_attacking = false
var attack_timer = 0.0
const ATTACK_DURATION = 0.6

func _ready():
	$AttackArea_1/CollisionShape2D.disabled = true
	$AttackArea_2/CollisionShape2D.disabled = true

func _physics_process(delta):
	# Handle attack timing
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			end_attack()

	# Handle attacks
	if not is_attacking:
		if Input.is_action_just_pressed("attack_1"):
			start_attack(1)
		elif Input.is_action_just_pressed("attack_2"):
			start_attack(2)

	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle movement and sprite flipping
	if not is_attacking:
		# Handle jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get input direction
		var direction = Input.get_axis("move_left", "move_right")

		# Flip sprite and adjust attack area positions based on direction
		if direction > 0:
			animated_sprite.flip_h = false
			attack_area_1.scale.x = 1
			attack_area_2.scale.x = 1
		elif direction < 0:
			animated_sprite.flip_h = true
			attack_area_1.scale.x = -1
			attack_area_2.scale.x = -1

		# Play movement animations
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("walk")
		else:
			animated_sprite.play("jump")

		# Move character
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = 0

	move_and_slide()

# Function to reduce health when hit by an enemy
func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

# Function to handle player's death and respawn
func die():
	print("Player has been defeated!")
	health = MAX_HEALTH
	global_position = respawn_point.global_position
	animated_sprite.play("idle")

# Start the attack
func start_attack(attack_type):
	is_attacking = true
	attack_timer = ATTACK_DURATION
	if attack_type == 1:
		$AttackArea_1/CollisionShape2D.disabled = false
		animated_sprite.play("attack_1")
	elif attack_type == 2:
		$AttackArea_2/CollisionShape2D.disabled = false
		animated_sprite.play("attack_2")

# End the attack
func end_attack():
	is_attacking = false
	$AttackArea_1/CollisionShape2D.disabled = true
	$AttackArea_2/CollisionShape2D.disabled = true
	animated_sprite.play("idle")
