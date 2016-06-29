
extends Node2D

var current_music

export(bool) var playing_music = true

func _ready():
	change_level("level1", "Spawn")
	
func change_level(level, spawn):
	if level == null :
		return
	var map = get_node("Map")
	
	for child in map.get_children() :
		child.queue_free()
	
	var level_scene = load("res://scenes/levels/" + level + ".tscn")
	var level_node = level_scene.instance()
	if(playing_music):
		change_music(level_node.music, level_node.loop)
	
	level_node.spawn_player(spawn)
	map.add_child(level_node)
	if controler.debug : print("level changed to " + level)
	
func change_music(music_name, loop = true) :
	var music_player = get_node("MusicPlayer")
	
	if current_music != music_name :
		current_music = music_name
		music_name = "res://musics/" + music_name + ".ogg"
		var music_stream = load(music_name)
		music_player.set_stream(music_stream)
		music_player.set_loop(loop)
		music_player.play(0)
		if controler.debug : print("playing music " + music_name)