::Reforged.HooksMod.conflictWith([
	"mod_legends",
	"mod_betterFencing [Is already included and/or enhanced in Reforged]",
	"mod_items_recipes [A similar feature is included in Reforged]",
	"mod_tactical_hit_factors [A similar feature is included in Reforged]",
	"mod_tactical_tooltip [A similar feature is included in Reforged]",
	"tnf_newChampions [Breaks the implementation of champion enemies in Reforged]"
]);
::Reforged.checkConflictWithFilename <- {
	function checkConflictWithFilename()
	{
		local conflicts = {
			["l_native scenarios to "] = "15 or 27 roster limit for all scenarios is incompatible with Reforged. It overwrites various vanilla files and has not been updated in many years. Use Origin Customizer by NgGH707 instead from https://www.nexusmods.com/battlebrothers/mods/445",
			mod_better_combat_log = "Better Combat Log is incompatible with Reforged as it overwrites functions in the actor class that break Reforged behavior. For a compatible mod that shows morale checks in the combat log use MoraleCheck Log by UnauthorizedShell from https://www.nexusmods.com/battlebrothers/mods/663",
			mod_detailed_status_effects = "Detailed Status Effects is incompatible with Reforged. Reforged has its own tactical tooltip which shows the detailed information via nested tooltips.",
			mod_numbers = "mod_numbers is incompatible with Reforged. Causes enemies to have wrong names. Use More Indirect Numeral Adjectives by UnauthorizedShell instead.",
			mod_show_enemy_stats = "Show Enemy Stats is not compatible with Reforged. A similar feature is already included in Reforged.",
			mod_smart_recruiter = "Smart Recruiter is not compatible with Reforged. Use Clever Recruiter by Enduriel instead.",
			mod_sr_alternative = "Smart Recruiter is not compatible with Reforged. Use Clever Recruiter by Enduriel instead.",
			mod_uncapped_levels = "Uncapped Levels and Perk Points is incompatible with Reforged. In Reforged the maximum player level is uncapped.",
			tnf_tryout = "tnf_tryout is incompatible with Reforged. Use Clever Recruiter by Enduriel instead."
		};
		local coreCount = 0;
		local assetsCount = 0;

		foreach( filePath in ::IO.enumerateFiles("data/") )
		{
			if (filePath.find("data/mod_reforged_core") != null)
			{
				coreCount++;
			}
			else if (filePath.find("data/mod_reforged_assets") != null)
			{
				assetsCount++;
			}

			foreach( filename, reason in conflicts )
			{
				if (filePath.find("data/" + filename) != null)
				{
					::Hooks.errorAndQuit(reason);
				}
			}
		}

		if (coreCount > 1)
		{
			::Hooks.errorAndQuit("You have extra Reforged core files in your data folder. Delete the extra ones and keep the latest version only.");
		}

		if (assetsCount > 1)
		{
			::Hooks.errorAndQuit("You have extra Reforged assets files in your data folder. Delete the extra ones and keep the latest version only.");
		}
	}

}.checkConflictWithFilename;
