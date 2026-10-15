::Reforged.HooksMod.hook("scripts/skills/effects/lone_wolf_effect", function ( q )
{
	q.m.BonusMult <- 1.15;
	q.isHidden = function ()
	{
		return {
			function isHidden()
			{
				return !this.isInValidPosition();
			}

		}.isHidden;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getTooltip();
				ret.extend([
					{
						id = 10,
						type = "text",
						icon = "ui/icons/melee_skill.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.BonusMult) + "[近战技能|Concept.MeleeSkill]")
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/ranged_skill.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.BonusMult) + "[远程技能|Concept.RangeSkill]")
					},
					{
						id = 12,
						type = "text",
						icon = "ui/icons/melee_defense.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.BonusMult) + "[近战防御|Concept.MeleeDefense]")
					},
					{
						id = 13,
						type = "text",
						icon = "ui/icons/ranged_defense.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.BonusMult) + "[远程防御|Concept.RangeDefense]")
					},
					{
						id = 14,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.BonusMult) + "[决心|Concept.Bravery]")
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
	q.onUpdate = function ()
	{
		return {
			function onUpdate( _properties )
			{
				if (this.isInValidPosition())
				{
					_properties.MeleeSkillMult *= this.m.BonusMult;
					_properties.RangedSkillMult *= this.m.BonusMult;
					_properties.MeleeDefenseMult *= this.m.BonusMult;
					_properties.RangedDefenseMult *= this.m.BonusMult;
					_properties.BraveryMult *= this.m.BonusMult;
				}
			}

		}.onUpdate;
	};
	q.isInValidPosition <- {
		function isInValidPosition()
		{
			local actor = this.getContainer().getActor();

			if (!actor.isPlacedOnMap())
			{
				return false;
			}

			local myTile = actor.getTile();
			local numAlliesWithinTwoTiles = 0;

			foreach( ally in ::Tactical.Entities.getInstancesOfFaction(actor.getFaction()) )
			{
				if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
				{
					continue;
				}

				switch(ally.getTile().getDistanceTo(myTile))
				{
				case 1:
					return false;

				case 2:
					numAlliesWithinTwoTiles++;
					break;
				}
			}

			return numAlliesWithinTwoTiles <= 1;
		}

	}.isInValidPosition;
});
