extends Area2D

var RIGHT = false
var LEFT = false
var UP = false
var DOWN = false
var direction = {"right":false, "down":false, "left":false, "up":false}
var step = 32

func _ready():
	pass

func _process(delta):
	movement()
	
func movement():
	
	if !$Front.is_colliding() and is_arrow_released():
		move()
	
	if Input.is_action_just_pressed("ui_right"):
		update_direction("right")
	if Input.is_action_just_pressed("ui_left"):
		update_direction("left")
	if Input.is_action_just_pressed("ui_up"):
		update_direction("up")
	if Input.is_action_just_pressed("ui_down"):
		update_direction("down")
	
	change_front_direction()

func move():
	var motion = Vector2(step,step)
	if direction["right"]:
		motion.x *= 1
	elif direction["left"]:
		motion.x *= -1
	else:
		motion.x *= 0
	if direction["down"]:
		motion.y *= 1
	elif direction["up"]:
		motion.y *= -1
	else:
		motion.y *= 0
	global_position += motion
	
	
func change_front_direction():
	var angle = 0
	for dir in direction.keys():
		if direction[dir]:
			break
		else:
			angle += 90
	$Front.rotation_degrees = angle

func update_direction(new_dir):
	for dir in direction.keys():
		if dir != new_dir:
			direction[dir]= false
		else:
			direction[dir] = true

func is_arrow_released():
	var keys = ["ui_right", "ui_left", "ui_up", "ui_down"]
	for key in keys:
		if Input.is_action_just_released(key):
			return true
	return false			
