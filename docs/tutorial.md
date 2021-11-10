# tutorial

## how to add a simple drifter

(the stuff described here is also shown in the [video](./video.md))

1. if this is your first drifter, make a new folder in `DriftersUserDefined/` with a good name. maybe just your username? e.g. `DriftersUserDefined/pancelor`
2. add a new scene, e.g. `CoolFrog.tscn`
  1. Make the root node of type `Node2D`
  2. attach a new script to the root node with the same-ish name as the scene; e.g. `CoolFrog.gd`
  3. delete everything and replace it with this:
  ```python
  extends Drifter

  # every so often
  func evolve():
    tweak()

  # when the player clicks
  func tweak():
    intend_spawn(_my_own_path, DirsOrthogonal[randi()%4])
  ```
  4. attach a `Sprite` node to your root node and "quick load" a 10x10 png that you've saved in your folder
    * if you want an animated sprite, attach a `NavdiBitsySprite` instead
  5. Add `CoolFrog.tscn` to the list of `spawnables` in `GardenWorld.tscn`
    * this auto-spawns one on game start
    * it also lets you spawn it by clicking in empty grid cells
3. set the [vibe](#vibes) for your drifter
  * `guts`: 0-100. higher = more likely to overwrite other drifters when they collide
  * `major_element`: a [vibe](#vibes); choose anything except "guts"
  * `minor_element`: a [vibe](#vibes); choose anything except "guts"
  * `evolve_skip_odds`: higher = your drifter's `evolve` method will get called less often
  * `evolve_wait_after`: number of frames of cooldown to wait before calling `evolve` again on your drifter. set it to, idk, 30 to prevent your drifter from suddenly moving a whole lot at once. up to you
4. Run the game with F5; you should see your drifter spawn! click on it to duplicate it.

## so what are `evolve` and `tweak`?

the system tries to call `evolve` on every frame on every drifter. however, drifters with high `evolve_skip_odds` will have a high chance of being skipped each frame.

the system calls `tweak` when the player clicks on a drifter. give your drifters cute `tweak` methods! ideas: duplicate, destroy, change into something else, do a little bounce animation (like [BigSnail](../DriftersUserDefined/droqen-test/BigSnail.gd))...

if you don't really know why you would want a separate `evolve` and `tweak` for your drifter, I recommend making them the same and setting a high `evolve_skip_odds`, maybe 10000. this basically means that the system will auto-click your drifter once in every long while

## guts

only one drfiter can be in a grid cell at a time; if two drifters both want to go to the same cell, the drifter with the higher "guts" is more likely to win

## vibes

### what are vibes

drifters are deliberately not allowed to ask the system what other drifters are near them. instead, they ask for the nearby "vibe", which is deliberately vague and will hopefully lead to messy unplanned beautiful interactions without needing to code them explicitly!

each drifter has a `major_element` and `minor_element`, which are one of the following:

```python
       # alternate interpretations:
Fire   #  red, energy, passion
Water  #  blue, wisdom, adaptability
Earth  #  brown, stability, calm
Grass  #  green, life, progress
Wind   #  white, change, restlessness
Sand   #  yellow, volatility, intelligence
Gem    #  purple, magic, uniqueness
Coal   #  black, death, decay
```

ideas:
* a computer drifter:
  * major: Sand (intelligence) or Gem (magic, or the how computers depend on very precise structure to work)
  * minor: Fire (energy) or Coal (electric power)
* a frog drifter:
  * major: Water (frogs live in water) or Grass (frogs are green, and alive)
  * minor: Wind (jumping is sorta like restlessness) or Sand (jumping is volatile? idk) or Fire (frogs are high-energy)
* a blacksmith drifter:
  * major: Coal (blacksmiths use coal, and have black soot everywhere) or Sand (blacksmiths are humans which are intelligent) or Fire (blacksmiths use fire to forge tools)
  * minor: also any of the above

it's up to you! take whichever two Elements feel most like your drifter to you.

### vibecheck

to interact with the rest of the world, check the nearby vibes. For example:

```python
# Leaf.gd
extends Drifter

func evolve():
  var vibe = world.vibe_nearby(cell)
  if vibe.get_element("Fire") > 1:
    world.log("a wandering leaf bursts into flames")
    intend_transmute("res://DriftersUserDefined/pancelor-debug/Flames.tscn")
  elif randf()<1/50:
    # settle
    tweak()
  else:
    # move towards wind but away from guts:
    var dir = vibiest_dir(DirsAdjacent,{"Wind":1, "Guts":-2})

    intend_move(dir)

func tweak():
  intend_transmute("res://DriftersUserDefined/pancelor-debug/Sapling.tscn")
```

see the [api](./api.md) for descriptions of `world.vibe_nearby`, `vibiest_dir`, etc