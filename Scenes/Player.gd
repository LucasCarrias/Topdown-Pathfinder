extends Area2D

const WINDOW_SIZE = Vector2(1024, 640)
var WINDOW_GRID = Vector2(WINDOW_SIZE.x/32, WINDOW_SIZE.y/32)
var rng = RandomNumberGenerator.new()

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
	if !is_single_pos(global_position):
		set_rand_pos(self)
		
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

func set_rand_pos(object):
	var done = false	
	while not done:
		var pos_x = 32*floor(rng.randi_range(1,  WINDOW_GRID.x-1))
		var pos_y = 32*floor(rng.randi_range(1,  WINDOW_GRID.y-1))
		object.global_position = Vector2(pos_x, pos_y)
		done = is_single_pos(object.global_position) and is_pos_on_window(object.global_position)

func is_single_pos(pos):
	for i in range(1,get_parent().get_child_count()-1):
			if get_parent().get_child(i).global_position == pos:
				return false
	return true

func is_pos_on_window(pos):
	return (pos.x >= 0 and pos.y >= 0) and (pos.x <= WINDOW_SIZE.x and pos.y <=WINDOW_SIZE.y)