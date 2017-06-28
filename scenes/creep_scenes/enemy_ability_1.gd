extends Node2D

var enemy
export (PackedScene) var bullet

func __init__(enemy_obj):
	enemy = enemy_obj
	shoot()
	queue_free()

func shoot():
	var rot = enemy.get_rot()
	enemy.vel += -1 * Vector2(100, 0).rotated(rot - PI/2)
	for i in range(-18, 18, 2):
		var b = bullet.instance()
		enemy.bullet_container.add_child(b)
		b.damage = enemy.damage * 0.5
		b.start_at(deg2rad(i) + rot, enemy.get_node("gun").get_global_pos())