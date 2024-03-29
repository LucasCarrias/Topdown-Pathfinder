extends Area2D

const WINDOW_SIZE = Global.WINDOW_SIZE
var WINDOW_GRID = Global.WINDOW_GRID
var rng = RandomNumberGenerator.new()

var RIGHT = false
var LEFT = false
var UP = false
var DOWN = false
var direction = {"right":false, "down":false, "left":false, "up":false, "stop":true}
var step = 32
var move = false

func _ready():
	pass

func _process(delta):
	movement()
	break_wall()
#MOVEMENT START
func movement():	
	if !$Front.is_colliding() and !is_arrow_released():
		if move:
			move()			
		else:
			if $MoveDelay.is_stopped():
				$MoveDelay.start()
		move = false
	else:
		update_direction("stop")
		
	if Input.is_action_pressed("ui_right"):
		update_direction("right")
	if Input.is_action_pressed("ui_left"):
		update_direction("left")
	if Input.is_action_pressed("ui_up"):
		update_direction("up")
	if Input.is_action_pressed("ui_down"):
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
	if not direction["stop"]:
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

func _on_MoveDelay_timeout():
	move = true
#MOVEMENT END
func break_wall():
	if $Front.is_colliding():
		if Input.is_action_just_pressed("ui_accept"):
			$Front.get_collider().queue_free()
				
				
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

func _on_Stuck_body_entered(body):
	if body != self:
		set_rand_pos(self)
