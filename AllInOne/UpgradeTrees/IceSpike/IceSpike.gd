extends Trap
## Activate on collision
## Damage enemy on collision and shoot ice shard projectiles in every direction

@export var ice_shard: PackedScene

func activate(body: Node2D):
	super(body)
	## Assume body is enemy bc alrdy checked
	## Damage Enemy
	if body.has_method("damage"):
		body.damage(make_attack(1))
	## Spawn Shards
	var count = 1 + Statics.trap_count_buff + GlobalStats.get_stat(GlobalStats.COUNT)
	var direction: Vector2 = Vector2(0, 0)
	for i in count:
		var shard: Projectile = ice_shard.instantiate()
		GameManager.instance.projectile_parent.add_child(shard)
		shard.global_position = global_position
		shard.setup_projectile(parent, null, direction)
