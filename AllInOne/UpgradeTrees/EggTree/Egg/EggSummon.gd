extends Summon
## Egg

var egg_upgrade: EggUpgrade 
#var timer: Label
#var stopwatch: float = 0

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
	#if egg_upgrade:
		#if stopwatch <= 0:
			#stopwatch = 1
			#if timer:
				#timer.text = str(int(egg_upgrade.time_until_hatch))
			#else:
				#timer = Label.new()
				#timer.text = str(int(egg_upgrade.time_until_hatch))
				#add_child(timer)
		#else:
			#stopwatch -= delta
	#if timer:
		#timer.rotation = -rotation
		#timer.position = Vector2(0, 20)
