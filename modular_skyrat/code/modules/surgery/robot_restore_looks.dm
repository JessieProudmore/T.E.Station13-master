/datum/surgery/robot_restore_looks
	name = "Restore robotic limb looks"
	steps = list(
	/datum/surgery_step/weld_plating,
	/datum/surgery_step/restore_paintjob)

	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_bodypart_type = 0
	desc = "A procedure that welds the robotic limbs back into the patient's preferred state aswell as re-applying their paintjob."

/datum/surgery/robot_restore_looks/can_start(mob/user, mob/living/patient, obj/item/tool)
	. = ..()
	if(.)
		var/mob/living/carbon/C = patient
		for(var/obj/item/bodypart/BP in C.bodyparts)
			if(BP.status & BODYPART_ROBOTIC)
				return TRUE
		return FALSE

/datum/surgery_step/restore_paintjob
	name = "Spray paint"
	implements = list(
		/obj/item/toy/crayon/spraycan = 100)
	time = 58

/datum/surgery_step/restore_paintjob/tool_check(mob/user, obj/item/tool, mob/living/carbon/target)
	var/obj/item/toy/crayon/spraycan/sc = tool
	if(sc.is_capped)
		to_chat(user, "<span class='warning'>Take the cap off first!</span>")
		return FALSE
	if(sc.charges < 10)
		to_chat(user, "<span class='warning'>Not enough paint in the can!</span>")
		return FALSE
	return TRUE

/datum/surgery_step/restore_paintjob/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/toy/crayon/spraycan/sc = tool
	sc.use_charges(user, 10, FALSE)
	sc.audible_message("<span class='notice'>You hear spraying.</span>")
	playsound(target.loc, 'sound/effects/spray.ogg', 5, 1, 5)
	if(target?.dna?.species)
		for(var/obj/item/bodypart/O in target.bodyparts)
			if(O.status == BODYPART_ROBOTIC)
				O.icon = target.dna.species.icon_limbs
				O.render_like_organic = TRUE
				O.synthetic = TRUE
				if(O.body_zone == BODY_ZONE_L_LEG || O.body_zone == BODY_ZONE_R_LEG)
					if(!target.dna.features["legs"] == "Plantigrade")
						O.use_digitigrade = FULL_DIGITIGRADE
				O.update_limb(O,target)
		if(isipcperson(target) && target.dna?.species?.mutant_bodyparts)
			var/continues = input(user, "Do you wish to repaint the unit's chassis model?", "Additional Changes") as null|anything in list("Yes", "No")
			if(continues == "Yes")
				var/new_ipc_chassis = input(user, "Choose a new chassis", "New Chassis") as null|anything in GLOB.ipc_chassis_list
				if(new_ipc_chassis)
					target.dna.features["ipc_chassis"] = new_ipc_chassis
		else if(issynthliz(target) && target.dna?.species?.mutant_bodyparts)
			var/continues = input(user, "Do you wish to set the unit's appearances to synthlizard defaults?", "Additional Changes") as null|anything in list("Yes", "Customize", "No")
			if(continues == "Yes")
				target.dna.features["ipc_antenna"] = "Synthetic Lizard - Antennae"
				target.dna.features["mam_tail"] = "Synthetic Lizard"
				target.dna.features["mam_snouts"] = "Synthetic Lizard - Snout"
				target.dna.features["legs"] = "Digitigrade"
				target.Digitigrade_Leg_Swap(FALSE)
				target.dna.features["mam_body_markings"] = "Synthetic Lizard - Plates"
				target.dna.features["taur_body"] = null
			if(continues == "Customize")
				var/new_color1 = input(user, "Choose the main color:", "Synthlizard remodeling","#"+target.dna.features["mcolor"]) as color|null
				if(new_color1)
					var/temp_hsv = RGBtoHSV(new_color1)
					if(ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3]) // mutantcolors must be bright
						target.dna.features["mcolor"] = sanitize_hexcolor(new_color1)
					else
						to_chat(user, "<span class='notice'>You realize this is too dark and decide to keep going with the customization.</span>")
				var/new_color2 = input(user, "Choose the secondary color:", "Synthlizard remodeling","#"+target.dna.features["mcolor2"]) as color|null
				if(new_color2)
					var/temp_hsv = RGBtoHSV(new_color2)
					if(ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3]) // mutantcolors must be bright
						target.dna.features["mcolor2"] = sanitize_hexcolor(new_color2)
					else
						to_chat(user, "<span class='notice'>You realize this is too dark and decide to keep going with the customization.</span>")
				var/new_color3 = input(user, "Choose the tertiary color:", "Synthlizard remodeling","#"+target.dna.features["mcolor3"]) as color|null
				if(new_color3)
					var/temp_hsv = RGBtoHSV(new_color3)
					if(ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3]) // mutantcolors must be bright
						target.dna.features["mcolor3"] = sanitize_hexcolor(new_color3)
					else
						to_chat(user, "<span class='notice'>You realize this is too dark and decide to keep going with the customization.</span>")
				var/new_antenna = input(user, "Choose a new antenna model", "Synthlizard remodeling") as null|anything in GLOB.synth_antennas_list			
				if(new_antenna)
					target.dna.features["ipc_antenna"] = new_antenna
				var/new_tail = input(user, "Choose a new tail model", "Synthlizard remodeling") as null|anything in GLOB.synth_tails_list
				if(new_tail)
					target.dna.features["mam_tail"] = new_tail
				var/new_snout = input(user, "Choose a new snout model", "Synthlizard remodeling") as null|anything in GLOB.synth_snouts_list
				if(new_snout)
					target.dna.features["mam_snouts"] = new_snout
				var/new_leg = input(user, "Choose a new leg model", "Synthlizard remodeling") as null|anything in list("Plantigrade", "Digitigrade")	
				if(new_leg)
					target.dna.features["legs"] = new_leg
					if(new_leg == "Digitigrade")
						target.Digitigrade_Leg_Swap(FALSE)
					else
						target.Digitigrade_Leg_Swap(TRUE)
				var/new_marking = input(user, "Choose a new marking style", "Synthlizard remodeling") as null|anything in GLOB.synth_markings_list
				if(new_marking)
					target.dna.features["mam_body_markings"] = new_marking
				var/possible_taurs = GLOB.synth_taur_list
				possible_taurs += "None"
				var/new_taur = input(user, "Choose a new taur model", "Synthlizard remodeling") as null|anything in possible_taurs
				if(new_taur)
					if(new_taur == "None")
						target.dna.features["taur_body"] = null
					else
						target.dna.features["taur_body"] = new_taur
		if(target.dna?.species?.mutant_bodyparts)
			var/continues = input(user, "Do you wish to set the reassign the unit's gender?", "Additional Changes") as null|anything in list("Yes", "No")
			if(continues == "Yes")
				var/new_gender = input(user, "Choose a new gender", "New Gender") as null|anything in list(MALE, FEMALE, NEUTER, PLURAL)
				if(new_gender)
					target.set_gender(new_gender, TRUE)
		target.update_body()
	return TRUE

/datum/surgery_step/restore_paintjob/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to spray paint on [target]...</span>",
			"[user] begins to spray paint on [target]'s [parse_zone(target_zone)].",
			"[user] begins to spray paint on [target]'s [parse_zone(target_zone)].")
