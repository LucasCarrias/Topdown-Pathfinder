extends Node2D

const WINDOW_SIZE = Global.WINDOW_SIZE
var WINDOW_GRID = Global.WINDOW_GRID

var MAP_GEN = preload("res://Scenes/MapGenerator.tscn")


var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	create_map()
	create_camera()

func create_map():
	var map_gen = MAP_GEN.instance()
	
	
	
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