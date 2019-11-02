extends Node2D

const WINDOW_SIZE = Global.WINDOW_SIZE
var WINDOW_GRID = Global.WINDOW_GRID

var WALL = preload("res://Scenes/Wall.tscn")


var rng = RandomNumberGenerator.new()
var childs_count

func _ready():	
	rng.randomize()
	while get_child_count() < 100:
		walls_generator(100)
	create_borders()
	
func _process(delta):
	pass
		
func walls_generator(amount):
	var last_pos
	for i in range(amount):
		var wall = WALL.instance()				
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
	var steps = object.check_steps(last_pos, true) #Possible steps
	while not done and loops < 50:
		loops += 1
		if steps == []:
			loops = 50
			break
		current_pos = last_pos
		current_pos += steps[rng.randi_range(0, len(steps)-1)]
		done = is_single_pos(object) and is_pos_on_window(object.global_position)
	
	if loops == 50:
		object.set_rand_pos(true)
		current_pos = object.global_position
	object.global_position = current_pos
	

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
			wall.get_node("Label").visible = false
			wall.modulate = Color(0,0.4,0)
			wall.global_position = Vector2(32*x, y)
	
	for x in [-32, WINDOW_SIZE.x+32]:
		for y in range(-1,WINDOW_GRID.y+1):
			wall = WALL.instance()
			add_child(wall)
			wall.get_node("Label").visible = false
			wall.modulate = Color(0,0.4,0)
			wall.global_position = Vector2(x, 32*y)
	wall = WALL.instance()
	add_child(wall)
	wall.modulate = Color(0,0.4,0)
	wall.global_position = Vector2(WINDOW_SIZE.x+32, 32*(WINDOW_GRID.y+1))

func set_rand_pos(object):
	var done = false	
	while not done:
		var pos_x = 32*floor(rng.randi_range(1,  WINDOW_GRID.x-1))
		var pos_y = 32*floor(rng.randi_range(1,  WINDOW_GRID.y-1))
		object.global_position = Vector2(pos_x, pos_y)
		done = is_single_pos(object) and is_pos_on_window(object.global_position)