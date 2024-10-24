extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_area_1 = $AttackArea_1  # Reference to AttackArea_1 node
@onready var attack_area_2 = $AttackArea_2  # Reference to AttackArea_2 node

var is_attacking = false
var attack_timer = 0.0
const ATTACK_DURATION = 0.6

func _ready():
	$AttackArea_1/CollisionShape2D.disabled = true  # Disable attack collision by default
	$AttackArea_2/CollisionShape2D.disabled = true  # Disable attack collision by default

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
		if direction > 0:  # Moving right
			animated_sprite.flip_h = false
			attack_area_1.scale.x = 1  # Reset the attack area scale to normal
			attack_area_2.scale.x = 1
		elif direction < 0:  # Moving left
			animated_sprite.flip_h = true
			attack_area_1.scale.x = -1  # Flip the attack area horizontally
			attack_area_2.scale.x = -1  # Flip the attack area horizontally

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
		# During attack, prevent movement
		velocity.x = 0

	move_and_slide()

# Start the attack (called when the player initiates an attack)
func start_attack(attack_type):
	is_attacking = true
	attack_timer = ATTACK_DURATION
	if attack_type == 1:
		$AttackArea_1/CollisionShape2D.disabled = false  # Enable the attack area for attack 1
		animated_sprite.play("attack_1")
	elif attack_type == 2:
		$AttackArea_2/CollisionShape2D.disabled = false  # Enable the attack area for attack 2
		animated_sprite.play("attack_2")

# End the attack (called when the attack timer runs out)
func end_attack():
	is_attacking = false
	$AttackArea_1/CollisionShape2D.disabled = true  # Disable the attack area 1
	$AttackArea_2/CollisionShape2D.disabled = true  # Disable the attack area 2
	animated_sprite.play("idle")  # Return to idle animation
