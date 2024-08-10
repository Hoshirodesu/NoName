extends CharacterBody2D

#const  normalspeed = 60
const speed = 400
const jump_velocity = -400
const jump_power = -1700
const DASH_SPEED = 900
var dashing = false
var can_dash = true
const acc = 50
const friction = 70
const gravity = 100
const max_jumps = 2
var current_jumps = 1
const dashspeed = 800
const dashlength = 10

@onready var sprite = $Sprite2D

func _physics_process(delta):
	var input_dir: Vector2 = input()
	print(input_dir)
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
		$dash_again.start()
	
	if dashing:
		velocity.x = input_dir.x * DASH_SPEED
	else:
		velocity.x = input_dir.x * speed
	
	if Input.is_action_just_pressed("attack"):
		$AnimationPlayer.play("attack")
		print("Attack")
		
	
	#if Input.is_action_just_pressed("ui_accept"):
		#dash.start_dash(dashlength)
	#var speed = dashspeed if dash.is_dashing() else normalspeed
	
	if input_dir != Vector2.ZERO:
		accelerate(input_dir)
	else:
		add_friction()
		#play_animation()
	player_movement()
	jump()

func input() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("backward", "forward")
	input_dir = input_dir.normalized()
	return input_dir

func accelerate(direction):
	velocity = velocity.move_toward(speed * direction, acc)
	
func add_friction():
	velocity = velocity.move_toward(Vector2.ZERO, friction)
	
func player_movement():
	move_and_slide()

func jump():
	if Input.is_action_just_pressed("jump"):
		if current_jumps < max_jumps:
			velocity.y = jump_power
			current_jumps = current_jumps + 1
	else:
		velocity.y += gravity
		
	if is_on_floor():
		current_jumps = 1


func _on_dash_timer_timeout() -> void:
	dashing = false
	
func _on_dash_again_timeout() -> void:
	can_dash = true
