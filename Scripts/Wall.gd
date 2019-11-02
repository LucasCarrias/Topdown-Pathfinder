extends StaticBody2D

onready var grid = get_parent().WINDOW_GRID
var posible_steps = 0

func _ready():
	$Label.text = str(get_position_in_parent())
	
func check_steps(pos, double_check):
	var possible_movements = []
	var step = Vector2()
	var check_list = [0,-32,32,-64,64] if double_check else [0,-32,32]
	for x in [-32,32]:
		var possible = true
		for y in check_list:
			if (x!=-64 and x!=64):
				step = Vector2(x,y)
			if !is_single_pos(pos+Vector2(x,y)) or !is_pos_on_window(pos+Vector2(x,y)):
				possible = false
				break
		
		if possible:
			step = Vector2(step.x, 0)
			possible_movements.append(step)
	
	for y in [-32,32]:
		var possible = true
		for x in check_list:
			if (y!=-64 and y!=64):
				step = Vector2(x,y)
			if !is_single_pos(pos+Vector2(x,y)) or !is_pos_on_window(pos+Vector2(x,y)):
				possible = false
				break
		
		
		if possible:
			step = Vector2(0, step.y)
			possible_movements.append(step)
		
	
	#print(str(get_position_in_parent())+" "+str(possible_movements))
	return possible_movements

func is_single_pos(pos):
	for i in range(get_parent().get_child_count()-1):
			if get_parent().get_child(i).global_position == pos:
				return false
	return true

func is_pos_on_window(pos):
	var WINDOW_SIZE = get_parent().WINDOW_SIZE
	return (pos.x >= 0 and pos.y >= 0) and (pos.x <= WINDOW_SIZE.x and pos.y <=WINDOW_SIZE.y)