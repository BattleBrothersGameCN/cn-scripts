this.rf_falcon_released_effect <- ::inherit("scripts/skills/skill", {
	m = {
		InitiativeModifier = 20,
		__IsNewRound = false
	},
	function create()
	{
		this.m.ID = "effects.rf_falcon_released";
		this.m.Name = "猎鹰升空";
		this.m.Description = "借助猎鹰的力量，该角色对战场的感知提高了。";
		this.m.Icon = "skills/rf_falcon_released_effect.png";
		this.m.Overlay = "rf_falcon_released_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.InitiativeModifier, {
				AddSign = true
			}) + " [Initiative|Concept.Initiative] until the start of the your [turn|Concept.Turn] in the next [round|Concept.Round]")
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.Initiative += this.m.InitiativeModifier;
	}

	function onTurnStart()
	{
		if (this.m.__IsNewRound)
		{
			this.removeSelf();
		}
	}

	function onNewRound()
	{
		this.m.__IsNewRound = true;
	}

});
