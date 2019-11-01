extends StaticBody2D

onready var grid = get_parent().WINDOW_GRID
var posible_steps = 0

func _ready():
	$Label.text = str(get_position_in_parent())
	
func check_steps(pos):
	var possible_movements = []
	var step = Vector2()
	for x in [-32,32]:
		var possible = true
		for y in [-32,0,32]:
			step = pos + Vector2(x,y)
			if !is_single_pos(step):
				possible = false
				break
		if possible:
			step = Vector2(step.x, 0)
			possible_movements.append(step)
	
	for y in [-32,32]:
		var possible = true
		for x in [-32,0,32]:
			step = pos + Vector2(x,y)
			if !is_single_pos(step):
				possible = false
				break
		if possible:
			step = Vector2(0, step.y)
			possible_movements.append(step)
	
	print(str(get_position_in_parent())+" "+str(possible_movements))
	return possible_movements

func is_single_pos(pos):
	for i in range(get_parent().get_child_count()-1):
			if get_parent().get_child(i).global_position == pos:
				return false
	return true