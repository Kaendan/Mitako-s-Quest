
extends Area2D

##########################################################################
## Variables                                                            ##
##########################################################################
###################
## Consts        ##
###################

const DIRECTION_UP = 0
const DIRECTION_DOWN = 1
const DIRECTION_LEFT = 2
const DIRECTION_RIGHT = 3

################################
## Other                      ##
################################

var tree_player = AnimationTreePlayer
var sword_hit = preload("res://scripts/sword_hit.gd")
var pathFollow = null

# States
var current_direction = DIRECTION_LEFT

##########################################################################
## Private Functions                                                    ##
##########################################################################

func _ready():
	tree_player = get_node("Sprite/AnimationTreePlayer")
	tree_player.transition_node_set_current("direction", current_direction)
	tree_player.set_active(true)
	
	connect("area_enter", self, "_on_enter")
	get_node("Timer").connect("timeout", self, "_on_timeout")

	set_fixed_process(true)

func _fixed_process(delta):
	if pathFollow && !controler.is_interacting :
		#move the monster and retrieve the old and new pos
		var old_pos = pathFollow.get_pos()
		pathFollow.set_offset(pathFollow.get_offset() + (50 * delta))		
		set_pos(pathFollow.get_pos())
		var pos = pathFollow.get_pos()
		
		#compute the angle with the old and new pos
		var travel = pos - old_pos
		var angle = travel.angle_to(Vector2(1,0))
		current_direction = get_direction_from_angle(angle)
		update_animation()
	
func update_animation():
	tree_player.transition_node_set_current("direction", current_direction)
	
func get_direction_from_angle(angle):
	if(angle >= -((3 * PI) / 4) and angle < -(PI / 4)):
		return DIRECTION_UP
	elif(angle >= -(PI / 4) and angle < (PI / 4) ):
		return DIRECTION_RIGHT
	elif(angle >= (PI / 4) and angle < ((3 * PI) / 4)):
		return DIRECTION_DOWN
	return DIRECTION_LEFT
		
func _on_enter(area):
	if (area extends sword_hit):
		set_fixed_process(false)
		get_node("Sprite").queue_free()
		get_node("HitBox").queue_free()
		get_node("SoundPlayer").play("bat")
		get_node("Particles").set_emitting(true)
		get_node("Timer").start()
		
func _on_timeout():
	queue_free()
