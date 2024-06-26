
/client/proc/view_var_Topic(href, href_list, hsrc)
	//This should all be moved over to datum/admins/Topic() or something ~Carn
	if ( (usr.client != src) || !holder )
		return
	if (href_list["Vars"])
		debug_variables(locate(href_list["Vars"]))

	//~CARN: for renaming mobs (updates their name, real_name, mind.name, their ID/PDA and datacore records).
	else if (href_list["rename"])
		if (!check_rights(R_VAREDIT))	return

		var/mob/M = locate(href_list["rename"])
		if (!istype(M))
			usr << "This can only be used on instances of type /mob"
			return

		var/new_name = sanitize(input(usr,"What would you like to name this mob?","Input a name",M.real_name) as text|null, MAX_NAME_LEN)
		if ( !new_name || !M )	return

		message_admins("Admin [key_name_admin(usr)] renamed [key_name_admin(M)] to [new_name].", key_name_admin(usr))
		M.fully_replace_character_name(M.real_name,new_name)
		href_list["datumrefresh"] = href_list["rename"]

	else if (href_list["varnameedit"] && href_list["datumedit"])
		if (!check_rights(R_VAREDIT))	return

		var/D = locate(href_list["datumedit"])
		if (!istype(D,/datum) && !istype(D,/client))
			usr << "This can only be used on instances of types /client or /datum"
			return

		modify_variables(D, href_list["varnameedit"], TRUE)

	else if (href_list["varnamechange"] && href_list["datumchange"])
		if (!check_rights(R_VAREDIT))	return

		var/D = locate(href_list["datumchange"])
		if (!istype(D,/datum) && !istype(D,/client))
			usr << "This can only be used on instances of types /client or /datum"
			return

		modify_variables(D, href_list["varnamechange"], FALSE)

	else if (href_list["varnamemass"] && href_list["datummass"])
		if (!check_rights(R_VAREDIT))	return

		var/atom/A = locate(href_list["datummass"])
		if (!istype(A))
			usr << "This can only be used on instances of type /atom"
			return

		cmd_mass_modify_object_variables(A, href_list["varnamemass"])

	else if (href_list["mob_player_panel"])
		if (!check_rights(0))	return

		var/mob/M = locate(href_list["mob_player_panel"])
		if (!istype(M))
			usr << "This can only be used on instances of type /mob"
			return

		holder.show_player_panel(M)
		href_list["datumrefresh"] = href_list["mob_player_panel"]
/*
	else if (href_list["give_disease2"])
		if (!check_rights(R_ADMIN|R_FUN))	return

		var/mob/M = locate(href_list["give_disease2"])
		if (!istype(M))
			usr << "This can only be used on instances of type /mob"
			return

		give_disease2(M)
		href_list["datumrefresh"] = href_list["give_spell"]
*/
	else if (href_list["godmode"])
		if (!check_rights(R_REJUVINATE))	return

		var/mob/M = locate(href_list["godmode"])
		if (!istype(M))
			usr << "This can only be used on instances of type /mob"
			return

		cmd_admin_godmode(M)
		href_list["datumrefresh"] = href_list["godmode"]

	else if (href_list["gib"])
		if (!check_rights(0))	return

		var/mob/M = locate(href_list["gib"])
		if (!istype(M))
			usr << "This can only be used on instances of type /mob"
			return

		cmd_admin_gib(M)
	else if (href_list["drop_everything"])
		if (!check_rights(R_DEBUG|R_ADMIN))	return

		var/mob/M = locate(href_list["drop_everything"])
		if (!istype(M))
			usr << "This can only be used on instances of type /mob"
			return

		if (usr.client)
			usr.client.cmd_admin_drop_everything(M)

	else if (href_list["mapswap"])
		if (!check_rights(R_DEBUG|R_ADMIN))
			return
		if (usr.client)
			usr.client.cmd_admin_mapswap()

	else if (href_list["direct_control"])
		if (!check_rights(0))	return

		var/mob/M = locate(href_list["direct_control"])
		if (!istype(M))
			usr << "This can only be used on instances of type /mob"
			return

		if (usr.client)
			usr.client.cmd_assume_direct_control(M)

	else if (href_list["delall"])
		if (!check_rights(R_DEBUG|R_SERVER))	return

		var/atom/movable/AM = locate(href_list["delall"])
		if (!ismovable(AM))
			usr << "This can only be used on instances of type /atom/movable"
			return

		else if (istype(AM, /mob/living/human))
			usr << "You can't delete all of this type."
			return

		var/action_type = WWinput(src, "Strict type ([AM.type]) or type and all subtypes?", "Mass-deletion", "Strict type", list("Strict type","Type and subtypes","Cancel"))
		if (action_type == "Cancel" || !action_type)
			return

		if (WWinput(src, "Are you really sure you want to delete all objects of type [AM.type]?", "Mass-deletion", "Yes", list("Yes","No")) != "Yes")
			return

		if (WWinput(src, "Second confirmation required. Delete??", "Mass-deletion", "Yes", list("Yes","No")) != "Yes")
			return

		var/AM_type = AM.type
		switch(action_type)
			if ("Strict type")
				var/i = FALSE
				for (var/atom/movable/AM2 in world)
					if (AM2.type == AM_type)
						i++
						qdel(AM2)
				if (!i)
					usr << "No objects of this type exist"
					return
				log_admin("[key_name(usr)] deleted all objects of type [AM_type] ([i] objects deleted)")
				message_admins("<span class='notice'>[key_name(usr)] deleted all objects of type [AM_type] ([i] objects deleted)</span>", key_name(usr))
			if ("Type and subtypes")
				var/i = FALSE
				for (var/atom/movable/AM2 in world)
					if (istype(AM2,AM_type))
						i++
						qdel(AM2)
				if (!i)
					usr << "No objects of this type exist"
					return
				log_admin("[key_name(usr)] deleted all objects of type or subtype of [AM_type] ([i] objects deleted)")
				message_admins("<span class='notice'>[key_name(usr)] deleted all objects of type or subtype of [AM_type] ([i] objects deleted)</span>", key_name(usr))

	else if (href_list["explode"])
		if (!check_rights(R_SPAWN))	return

		var/atom/A = locate(href_list["explode"])
		if (!isobj(A) && !ismob(A) && !isturf(A))
			usr << "This can only be done to instances of type /obj, /mob and /turf"
			return

		cmd_admin_explosion(A)
		href_list["datumrefresh"] = href_list["explode"]

	else if (href_list["mark_object"])
		if (!check_rights(0))	return

		var/datum/D = locate(href_list["mark_object"])
		if (!istype(D))
			usr << "This can only be done to instances of type /datum"
			return

		holder.marked_datum_weak = WEAKREF(D)
		href_list["datumrefresh"] = href_list["mark_object"]

	else if (href_list["rotatedatum"])
		if (!check_rights(0))	return

		var/atom/A = locate(href_list["rotatedatum"])
		if (!istype(A))
			usr << "This can only be done to instances of type /atom"
			return

		switch(href_list["rotatedir"])
			if ("right")	A.set_dir(turn(A.dir, -45))
			if ("left")	A.set_dir(turn(A.dir, 45))
		href_list["datumrefresh"] = href_list["rotatedatum"]

	else if (href_list["makemonkey"])
		if (!check_rights(R_SPAWN))	return

		var/mob/living/human/H = locate(href_list["makemonkey"])
		if (!istype(H))
			usr << "This can only be done to instances of type /mob/living/human"
			return

		if (WWinput(usr, "Confirm mob type change?", "Transform", "Transform", list("Transform","Cancel")) != "Transform")
			return

		if (!H)
			usr << "Mob doesn't exist anymore"
			return
		holder.Topic(href, list("monkeyone"=href_list["makemonkey"]))


	else if (href_list["setspecies"])
		if (!check_rights(R_SPAWN))	return

		var/mob/living/human/H = locate(href_list["setspecies"])
		if (!istype(H))
			usr << "This can only be done to instances of type /mob/living/human"
			return

		var/new_species = input("Please choose a new species.","Species",null) as null|anything in all_species

		if (!H)
			usr << "Mob doesn't exist anymore"
			return

		if (H.set_species(new_species))
			usr << "Set species of [H] to [H.species]."
		else
			usr << "Failed! Something went wrong."

	else if (href_list["addlanguage"])
		if (!check_rights(R_SPAWN))	return

		var/mob/H = locate(href_list["addlanguage"])
		if (!istype(H))
			usr << "This can only be done to instances of type /mob"
			return

		var/new_language = input("Please choose a language to add.","Language",null) as null|anything in all_languages

		if (!new_language)
			return

		if (!H)
			usr << "Mob doesn't exist anymore"
			return

		if (H.add_language(new_language))
			usr << "Added [new_language] to [H]."
		else
			usr << "Mob already knows that language."

	else if (href_list["remlanguage"])
		if (!check_rights(R_SPAWN))	return

		var/mob/H = locate(href_list["remlanguage"])
		if (!istype(H))
			usr << "This can only be done to instances of type /mob"
			return

		if (!H.languages.len)
			usr << "This mob knows no languages."
			return

		var/datum/language/rem_language = input("Please choose a language to remove.","Language",null) as null|anything in H.languages

		if (!rem_language)
			return

		if (!H)
			usr << "Mob doesn't exist anymore"
			return

		if (H.remove_language(rem_language.name))
			usr << "Removed [rem_language] from [H]."
		else
			usr << "Mob doesn't know that language."

	else if (href_list["addverb"])
		if (!check_rights(R_DEBUG))	  return

		var/mob/living/H = locate(href_list["addverb"])

		if (!istype(H))
			usr << "This can only be done to instances of type /mob/living"
			return
		var/list/possibleverbs = list()
		possibleverbs += "Cancel" 								// One for the top...
		possibleverbs += typesof(/mob/proc,/mob/verb,/mob/living/proc,/mob/living/verb)
		switch(H.type)
			if (/mob/living/human)
				possibleverbs += typesof(/mob/living/human/proc,/mob/living/human/verb,/mob/living/human/verb,/mob/living/human/proc)
		possibleverbs -= H.verbs
		possibleverbs += "Cancel" 								// ...And one for the bottom

		var/verb = input("Select a verb!", "Verbs",null) as anything in possibleverbs
		if (!H)
			usr << "Mob doesn't exist anymore"
			return
		if (!verb || verb == "Cancel")
			return
		else
			H.verbs += verb

	else if (href_list["remverb"])
		if (!check_rights(R_DEBUG))	  return

		var/mob/H = locate(href_list["remverb"])

		if (!istype(H))
			usr << "This can only be done to instances of type /mob"
			return
		var/verb = input("Please choose a verb to remove.","Verbs",null) as null|anything in H.verbs
		if (!H)
			usr << "Mob doesn't exist anymore"
			return
		if (!verb)
			return
		else
			H.verbs -= verb

	else if (href_list["addorgan"])
		if (!check_rights(R_SPAWN))	return

		var/mob/living/human/M = locate(href_list["addorgan"])
		if (!istype(M))
			usr << "This can only be done to instances of type /mob/living/human"
			return

		var/new_organ = input("Please choose an organ to add.","Organ",null) as null|anything in typesof(/obj/item/organ)-/obj/item/organ
		if (!new_organ) return

		if (!M)
			usr << "Mob doesn't exist anymore"
			return

		if (locate(new_organ) in M.internal_organs)
			usr << "Mob already has that organ."
			return

		new new_organ(M)


	else if (href_list["remorgan"])
		if (!check_rights(R_SPAWN))	return

		var/mob/living/human/M = locate(href_list["remorgan"])
		if (!istype(M))
			usr << "This can only be done to instances of type /mob/living/human"
			return

		var/obj/item/organ/rem_organ = input("Please choose an organ to remove.","Organ",null) as null|anything in M.internal_organs

		if (!M)
			usr << "Mob doesn't exist anymore"
			return

		if (!(locate(rem_organ) in M.internal_organs))
			usr << "Mob does not have that organ."
			return

		usr << "Removed [rem_organ] from [M]."
		rem_organ.removed()
		qdel(rem_organ)

	else if (href_list["fix_nano"])
		if (!check_rights(R_DEBUG)) return

		var/mob/H = locate(href_list["fix_nano"])

		fix_nanoUI(usr, H)

	else if (href_list["regenerateicons"])
		if (!check_rights(0))	return

		var/mob/M = locate(href_list["regenerateicons"])
		if (!ismob(M))
			usr << "This can only be done to instances of type /mob"
			return
		M.regenerate_icons()

	else if (href_list["adjustDamage"] && href_list["mobToDamage"])
		if (!check_rights(R_DEBUG|R_ADMIN|R_FUN))	return

		var/mob/living/L = locate(href_list["mobToDamage"])
		if (!istype(L)) return

		var/Text = href_list["adjustDamage"]

		var/amount =  input("Deal how much damage to mob? (Negative values here heal)","Adjust [Text]loss",0) as num

		if (!L)
			usr << "Mob doesn't exist anymore"
			return

		switch(Text)
			if ("brute")	L.adjustBruteLoss(amount)
			if ("fire")	L.adjustBurnLoss(amount)
			if ("toxin")	L.adjustToxLoss(amount)
			if ("oxygen")L.adjustOxyLoss(amount)
			if ("brain")	L.adjustBrainLoss(amount)
			if ("clone")	L.adjustCloneLoss(amount)
			else
				usr << "You caused an error. DEBUG: Text:[Text] Mob:[L]"
				return

		if (amount != FALSE)
			log_admin("[key_name(usr)] dealt [amount] amount of [Text] damage to [L]")
			message_admins("<span class='notice'>[key_name(usr)] dealt [amount] amount of [Text] damage to [L]</span>", key_name(usr))
			href_list["datumrefresh"] = href_list["mobToDamage"]

	else if (href_list["call_proc"])
		var/datum/D = locate(href_list["call_proc"])
		if (istype(D) || istype(D, /client)) // can call on clients too, not just datums
			callproc_targetpicked(1, D)

	else if (href_list["mass_call_proc"])
		var/datum/D = locate(href_list["mass_call_proc"])
		var/procname = input(usr, "Which proc? Arguments are not supported here.") as text
		if ((!istype(D) && !istype(D, /client)) || !hascall(D, procname))
			usr << "<span class = 'warning'>This isn't a datum/client type, or it has no call '[procname]'.</span>"
			return
		for (var/datum/DD in world)
			if (istype(DD, D.type))
				call(DD, procname)()

	if (href_list["datumrefresh"])
		var/datum/DAT = locate(href_list["datumrefresh"])
		if (istype(DAT, /datum) || istype(DAT, /client))
			debug_variables(DAT)

	return
