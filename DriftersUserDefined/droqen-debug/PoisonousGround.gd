extends Drifter


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	$CPUParticles2D.preprocess = randf()
#	$CPUParticles2D.restart()

func evolve(vibe:Vibe):
	if randf() < 0.01:
		intent_spawn_drifter = load("res://DriftersUserDefined/droqen-debug/BigSnail.tscn").instance()
		intent_spawn_dir = Vector2.ZERO
