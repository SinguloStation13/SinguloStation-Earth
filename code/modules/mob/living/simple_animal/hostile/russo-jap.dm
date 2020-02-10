/mob/living/simple_animal/hostile/human/japanese
	name = "Japanese Soldier"
	desc = "A japanese soldier."
	icon_state = "japmelee"
	icon_dead = "japmelee_dead"
	turns_per_move = 2
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"
	speak = list("TENNOHEIKA BANZAI!!","BANZAI!!","banzai!","Tennoheika banzai!","Shinjimae!")
	speak_emote = list("grumbles", "mumbles")
	emote_hear = list("curses","grumbles","banzai's")
	emote_see = list("stares murderously", "draws metal")
	speak_chance = TRUE
	speed = 4
	move_to_delay = 6
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	move_to_delay = 6
	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 40
	attacktext = "slashed"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	mob_size = MOB_MEDIUM
	language = new/datum/language/japanese

	corpse = /mob/living/carbon/human/corpse/japanese

	faction = JAPANESE


/mob/living/simple_animal/hostile/human/japanese/death()
	..()
	if(corpse)
		new corpse (src.loc)
	qdel(src)
	return

/mob/living/simple_animal/hostile/human/japanesecap
	name = "Japanese Captain"
	desc = "A japanese captain."
	icon_state = "japcommander"
	icon_dead = "japmelee_dead"
	turns_per_move = 3
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"
	speak = list("omae wa mou, shinde iru", "hah hah hah hah, baka ne")
	speak_emote = list("grumbles", "mumbles")
	emote_hear = list("curses","grumbles","banzai's")
	emote_see = list("stares 'omae wa mou shinde iru-ly'", "draws metal")
	speak_chance = TRUE
	speed = 6
	move_to_delay = 4
	stop_automated_movement_when_pulled = 0
	maxHealth = 120
	health = 120
	move_to_delay = 4
	harm_intent_damage = 10
	melee_damage_lower = 35
	melee_damage_upper = 45
	attacktext = "pistol-whipped"
	attack_sound = 'sound/weapons/punch3.ogg'
	mob_size = MOB_MEDIUM

	corpse = /mob/living/carbon/human/corpse/japanesecap

	faction = JAPANESE


/mob/living/simple_animal/hostile/human/japanesecap/death()
	..()
	if(corpse)
		new corpse (src.loc)
	qdel(src)
	return


/mob/living/simple_animal/hostile/human/ww2_jap
	name = "Japanese Soldier"
	desc = "A jap soldier! he looks hostile!"
	icon_state = "ww2_jap_ranged1"
	icon_dead = "bandit2_dead"
	turns_per_move = 2
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "whacks"
	speak = list()
	speak_emote = list()
	emote_hear = list()
	emote_see = list("aims", "raises his rifle")
	speak_chance = TRUE
	speed = 6
	move_to_delay = 3
	stop_automated_movement_when_pulled = 0
	maxHealth = 150
	health = 150
	move_to_delay = 4
	harm_intent_damage = 10
	melee_damage_lower = 35
	melee_damage_upper = 45
	attacktext = "bayoneted"
	attack_sound = 'sound/weapons/slice.ogg'
	mob_size = MOB_MEDIUM
	starves = FALSE
	behaviour = "hostile"
	faction = JAPANESE
	ranged = 1
	projectiletype = /obj/item/projectile/bullet/rifle/a77x58
	corpse = /mob/living/carbon/human/corpse/japanese_ww2
	projectilesound = 'sound/weapons/kar_shot.ogg'
	casingtype = null
	language = new/datum/language/japanese

	New()
		..()
		messages["injured"] = "!!I am injured!"
		messages["backup"] = "!!I need backup!"
		messages["enemy_sighted"] = "!!Found an american dog!"
		messages["grenade"] = "!!GRENADE!!!"

		gun = new/obj/item/weapon/gun/projectile/boltaction/arisaka99/bayonet(src)
		icon_state = "ww2_jap_ranged[rand(1,4)]"
/mob/living/simple_animal/hostile/human/ww2_jap/death()
	..()
	if(corpse)
		new corpse (src.loc)
	qdel(src)
	return


/mob/living/simple_animal/hostile/human/ww2_jap/summer
	name = "Japanese Soldier"
	desc = "A jap soldier! he looks hostile!"
	icon_state = "ww2_jap_ranged_summer1"

	New()
		..()
		icon_state = "ww2_jap_ranged_summer[rand(1,4)]"

/mob/living/simple_animal/hostile/human/ww2_american
	name = "American Soldier"
	desc = "An american soldier! he looks hostile!"
	icon_state = "ww2_american_ranged1"
	icon_dead = "bandit2_dead"
	turns_per_move = 2
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "whacks"
	speak = list("You're dead!", "Just try and kill me bastards!")
	speak_emote = list("grumbles", "mumbles")
	emote_hear = list("curses","grumbles")
	emote_see = list("aims", "raises his rifle")
	speak_chance = TRUE
	speed = 6
	move_to_delay = 3
	stop_automated_movement_when_pulled = 0
	maxHealth = 150
	health = 150
	move_to_delay = 4
	harm_intent_damage = 10
	melee_damage_lower = 35
	melee_damage_upper = 45
	attacktext = "whacked"
	attack_sound = 'sound/weapons/slice.ogg'
	mob_size = MOB_MEDIUM
	starves = FALSE
	behaviour = "hostile"
	faction = AMERICAN
	ranged = 1
	projectiletype = /obj/item/projectile/bullet/rifle/a3006
	corpse = /mob/living/carbon/human/corpse/ww2_american
	projectilesound = 'sound/weapons/kar_shot.ogg'
	casingtype = null
	New()
		..()
		messages["injured"] = "!!Injured!"
		messages["backup"] = "!!I need backup!"
		messages["enemy_sighted"] = "!!Found a jap!"
		messages["grenade"] = "!!GRENADE!!!"
/mob/living/simple_animal/hostile/human/ww2_american/death()
	..()
	if(corpse)
		new corpse (src.loc)
	qdel(src)
	return