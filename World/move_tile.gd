extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func offset_elevation(amount:int):
	animated_sprite_2d.offset.y = amount * -8
