extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@export var speed = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var horizontal_direction = "E"
var vertical_direction = "N"
var animation_type = "idle"

func _physics_process(delta):
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	var 
#
#	direction = Input.get_axis("ui_up", "ui_down")
#	if direction:
#		velocity.y = direction * SPEED
#	else:
#		velocity.y = move_toward(velocity.y, 0, SPEED)
	var direction_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction_vector.length() > 0:
		animation_type = "running"
		horizontal_direction = "W" if direction_vector.x < 0 else "E" if direction_vector.x > 0 else ""
		vertical_direction = "N" if direction_vector.y < 0 else "S" if direction_vector.y > 0 else ""
	else:
		animation_type = "idle"
	
	if direction_vector.x != 0 and direction_vector.y != 0:
		direction_vector = Vector2(256, 128).normalized()*direction_vector.sign()
#		direction_vector = Vector2(1, 0).rotated(deg_to_rad(26.5))*direction_vector.sign()
		direction_vector = direction_vector.normalized()
	
	var new_animation_name = "%s_%s%s" % [animation_type, vertical_direction, horizontal_direction]

	if animated_sprite.animation != new_animation_name:
		animated_sprite.play(new_animation_name)
		print(direction_vector)
	velocity = direction_vector * speed
	move_and_slide()
