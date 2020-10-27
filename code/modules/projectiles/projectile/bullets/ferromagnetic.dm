/obj/item/projectile/bullet/magnetic
	icon_state = "magjectile"
	damage = 30
	armour_penetration = 20
	light_range = 3
	pixels_per_second = TILES_TO_PIXELS(16.667)
	range = 35
	light_color = LIGHT_COLOR_RED
	wound_bonus = 15

/obj/item/projectile/bullet/magnetic/disabler
	icon_state = "magjectile-nl" //nl stands for non-lethal
	damage = 2
	armour_penetration = 10
	stamina = 30
	light_color = LIGHT_COLOR_BLUE
	wound_bonus = CANT_WOUND

/obj/item/projectile/bullet/magnetic/weak
	damage = 20
	armour_penetration = 10
	light_range = 2
	range = 25
	wound_bonus = -30

/obj/item/projectile/bullet/magnetic/weak/disabler
	damage = 2
	stamina = 20

/obj/item/projectile/bullet/magnetic/hyper
	damage = 15
	armour_penetration = 20
	stamina = 15
	movement_type = FLYING | UNSTOPPABLE
	range = 6
	light_range = 1
	light_color = LIGHT_COLOR_RED
	wound_bonus = 20

/obj/item/projectile/bullet/incendiary/mag_inferno
	icon_state = "magjectile-large"
	damage = 25
	armour_penetration = 20
	movement_type = FLYING | UNSTOPPABLE
	range = 20
	pixels_per_second = TILES_TO_PIXELS(12.5)
	light_range = 4
	light_color = LIGHT_COLOR_RED
	wound_bonus = 15

/obj/item/projectile/bullet/incendiary/mag_inferno/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, -1, 0, 0, 1, 2, flame_range = 2)
	return BULLET_ACT_HIT
