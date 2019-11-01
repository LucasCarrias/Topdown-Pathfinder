extends Node2D

const WINDOW_SIZE = Vector2(1024, 640)
var WINDOW_GRID = Vector2(WINDOW_SIZE.x/32, WINDOW_SIZE.y/32)

var WALL = preload("res://Scenes/Wall.tscn")
var WALL_SCRIPT = preload("res://Scenes/Wall.gd")
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()	
	walls_generator(100)
	
func _process(delta):
	pass

func walls_generator(amount):
	var last_pos = get_child(get_child_count()-1).global_position
	for i in range(amount):
		var wall = WALL.instance()
		wall.set_script(WALL_SCRIPT)		
		add_child(wall)		
		if i == 0 and get_child_count() < 2:
			set_rand_pos(wall)
		else:
			next_wall_position(wall, last_pos)
		last_pos = wall.global_position

func next_wall_position(object, last_pos):
	var current_pos
	var loops = 0
	var done = false	
	var steps = object.check_steps()	
	while not done and loops < 50:
		loops += 1
		current_pos = last_pos
		current_pos += steps[rng.randi_range(0, len(steps)-1)]
		done = is_single_pos(object) and is_pos_on_window(object.global_position)

	if loops == 50:
		done = false
		set_rand_pos(object)
		current_pos = object.global_position
	object.global_position = current_pos
	
	
func set_rand_pos(object):
	var done = false	
	while not done:
		var pos_x = 32*floor(rng.randi_range(0,  WINDOW_GRID.x))
		var pos_y = 32*floor(rng.randi_range(0,  WINDOW_GRID.y))
		object.global_position = Vector2(pos_x, pos_y)
		done = is_single_pos(object) and is_pos_on_window(object.global_position)

func is_single_pos(object):
	for i in range(get_child_count()-1):			
			if get_child(i).global_position == object.global_position:
				return false
	return true
	
func is_pos_on_window(pos):
	return (pos.x >= 0 and pos.y >= 0) and (pos.x <= WINDOW_SIZE.x and pos.y <=WINDOW_SIZE.y)

