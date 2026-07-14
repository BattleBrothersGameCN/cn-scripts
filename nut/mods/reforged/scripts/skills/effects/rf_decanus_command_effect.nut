this.rf_decanus_command_effect <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.rf_decanus_command";
		this.m.Name = "十夫长之命";
		this.m.Description = "该角色正在十夫长身边。";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.Icon = "skills/rf_decanus_command_effect.png";
		this.m.IconMini = "rf_decanus_command_effect_mini";
		this.m.IsSerialized = false;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("可以不消耗[行动点数|Concept.ActionPoints]使用[盾墙|Skill+shieldwall]技能")
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.IsHidden = true;
		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap())
		{
			return;
		}

		local shieldwall = this.getContainer().getSkillByID("actives.shieldwall");

		if (shieldwall == null)
		{
			return;
		}

		local myTile = actor.getTile();

		foreach( ally in ::Tactical.Entities.getAlliedActors(actor.getFaction(), myTile, 4) )
		{
			if (ally.getSkills().hasSkill("perk.rf_decanus"))
			{
				this.m.IsHidden = false;
				shieldwall.m.ActionPointCost = 0;
				break;
			}
		}
	}

});
