extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite = $AnimatedSprite2D
var is_attacking = false
var attack_timer = 0.0
const ATTACK_DURATION = 0.6

func _physics_process(delta):
	# Handle attack timing
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false

	# Handle attacks
	if not is_attacking:
		if Input.is_action_just_pressed("attack_1"):
			is_attacking = true
			attack_timer = ATTACK_DURATION
			animated_sprite.play("attack_1")
			# Call a function to handle attack logic (e.g., dealing damage)
			perform_attack(1)
		elif Input.is_action_just_pressed("attack_2"):
			is_attacking = true
			attack_timer = ATTACK_DURATION
			animated_sprite.play("attack_2")
			perform_attack(2)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

# Handle movement only if not attacking
	if not is_attacking:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("move_left", "move_right")
		
		
		# Flip the sprite
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
				animated_sprite.flip_h = true
				
		#Play animations
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("walk")
		else:
			animated_sprite.play("jump")

		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		# During attack, prevent movement
		velocity.x = 0

	move_and_slide()
	
func perform_attack(attack_type):
	# Placeholder for attack logic
	# You can add collision detection, damage dealing, etc.
	if attack_type == 1:
		print("Performed Attack 1")
	elif attack_type == 2:
		print("Performed Attack 2")
