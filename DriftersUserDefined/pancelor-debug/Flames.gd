extends Drifter

onready var ttl:float = rand_range(5, 10+1) # number of evolves until death
var anim:float = 0.0
onready var flicker:float = rand_range(1.5,3)

func _physics_process(_delta):
	._physics_process(_delta) # call method on base class 
	anim += _delta*2*PI
	if randf()*4<1:
		scale.x *= 0.95
		scale.y *= 1.05
	rotation_degrees = sin(anim)*10

func evolve():
	ttl -= 1
	if ttl <= 0:
		tweak()
	elif world.vibe_nearby(cell).get_water() > 3:
		tweak()
	else:
		var dir = DirsOrthogonal[randi()%4]
		var vibe = world.vibe_at(cell+dir)
		if vibe.get_fire() > 2:
			ttl += 0.5
		elif vibe.weight_by({"Water":-3, "Sand":2, "Grass":1}) > 0 or randf()*10<1:
			world.log("the flames grow higher")
			intend_kill(dir)
			intend_spawn("res://DriftersUserDefined/pancelor-debug/Flames.tscn",dir)

func tweak():
	if randf()*30<1:
		world.log("new life from flames")
		intend_transmute("res://DriftersUserDefined/pancelor-debug/Sapling.tscn")
	else:
		world.log("the flames extinguish")
		intend_die()
