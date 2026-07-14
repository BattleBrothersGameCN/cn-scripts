this.rf_centurion_command_effect <- ::inherit("scripts/skills/skill", {
	m = {
		InitiativeBonus = 30
	},
	function create()
	{
		this.m.ID = "effects.rf_centurion_command";
		this.m.Name = "百夫长之命";
		this.m.Description = "该角色正在百夫长身边。";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.Icon = "skills/rf_centurion_command_effect.png";
		this.m.IconMini = "rf_centurion_command_effect_mini";
		this.m.IsSerialized = false;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.InitiativeBonus, {
				AddSign = true
			}) + "点[主动值|Concept.Initiative]")
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = true;
		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap())
		{
			return;
		}

		local myTile = actor.getTile();

		foreach( ally in ::Tactical.Entities.getAlliedActors(actor.getFaction(), myTile, 6) )
		{
			if (ally.getSkills().hasSkill("perk.rf_centurion"))
			{
				this.m.IsHidden = false;
				_properties.Initiative += this.m.InitiativeBonus;
				break;
			}
		}
	}

});
