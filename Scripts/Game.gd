extends Node2D

const WINDOW_SIZE = Vector2(1024, 640)
var WINDOW_GRID = Vector2(WINDOW_SIZE.x/32, WINDOW_SIZE.y/32)

var WALL = preload("res://Scenes/Wall.tscn")
var WALL_SCRIPT = preload("res://Scenes/Wall.gd")

var rng = RandomNumberGenerator.new()

func _ready():	
	rng.randomize()
	create_camera()	
	create_borders()
func _process(delta):
	while get_child_count() < 200:
		walls_generator(rng.randi_range(5,30))
func walls_generator(amount):
	var last_pos = get_child(get_child_count()-1).global_position
	for i in range(amount):
		var wall = WALL.instance()
		wall.set_script(WALL_SCRIPT)		
		add_child(wall)
		wall.z_index += 3
		if i == 0:
			set_rand_pos(wall)
		else:
			next_wall_position(wall, last_pos)
		last_pos = wall.global_position

func next_wall_position(object, last_pos):
	var current_pos
	var loops = 0
	var done = false	
	var steps = object.check_steps(last_pos)
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
		var pos_x = 32*floor(rng.randi_range(1,  WINDOW_GRID.x-1))
		var pos_y = 32*floor(rng.randi_range(1,  WINDOW_GRID.y-1))
		object.global_position = Vector2(pos_x, pos_y)
		done = is_single_pos(object) and is_pos_on_window(object.global_position)

func is_single_pos(object):
	for i in range(get_child_count()-1):			
			if get_child(i).global_position == object.global_position:
				return false
	return true
	
func is_pos_on_window(pos):
	return (pos.x >= 0 and pos.y >= 0) and (pos.x <= WINDOW_SIZE.x and pos.y <=WINDOW_SIZE.y)

func create_borders():
	var wall = WALL.instance()
	
	for y in [-32, WINDOW_SIZE.y+32]:
		for x in range(-1,WINDOW_GRID.x+1):
			wall = WALL.instance()
			add_child(wall)
			wall.modulate = Color(0,0.4,0)
			wall.global_position = Vector2(32*x, y)
	
	for x in [-32, WINDOW_SIZE.x+32]:
		for y in range(-1,WINDOW_GRID.y+1):
			wall = WALL.instance()
			add_child(wall)
			wall.modulate = Color(0,0.4,0)
			wall.global_position = Vector2(x, 32*y)
	wall = WALL.instance()
	add_child(wall)
	wall.modulate = Color(0,0.4,0)
	wall.global_position = Vector2(WINDOW_SIZE.x+32, 32*(WINDOW_GRID.y+1))
	
func create_camera():
	var camera = Camera2D.new()
	$Player.add_child(camera)
	camera.anchor_mode = 1
	camera.current = true
	camera.limit_left = -32
	camera.limit_right = WINDOW_SIZE.x+32
	camera.limit_top = -32
	camera.limit_bottom = WINDOW_SIZE.y+32
	camera.set_zoom(Vector2(1,1))