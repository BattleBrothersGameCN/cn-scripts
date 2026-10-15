this.rf_banshee_potion_effect <- ::inherit("scripts/skills/effects/rf_anatomist_potion_effect", {
	m = {
		RerollMoraleChance = 50
	},
	function create()
	{
		this.rf_anatomist_potion_effect.create();
		this.m.ID = "effects.rf_banshee_potion";
		this.m.Name = "凝滞心境";
		this.m.Description = "该角色的体液异常稳定，这让他的心智能本能地抵抗恐惧和哀伤，又极易和积极情绪共鸣。偶有人发现他神情空洞地歪着头发呆，似乎是被脑海里轻微的嗡鸣声所吸引。";
		this.m.Icon = "skills/rf_banshee_potion_effect.png";
		this.m.Overlay = "rf_banshee_potion_effect";
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.RerollMoraleChance, {
					AddSign = true,
					AddPercent = true
				}) + " chance to reroll failed [morale checks|Concept.Morale]")
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::Reforged.Mod.Tooltips.parseString("抵消所有妨碍获得自信[士气|Concept.Morale]的效果")
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("移除[$ $|Skill+dastard_trait]和[$ $|Skill+insecure_trait]")
			}
		]);
		return ret;
	}

	function onAdded()
	{
		this.getContainer().removeByID("trait.dastard");
		this.getContainer().removeByID("trait.insecure");
	}

	function onUpdate( _properties )
	{
		_properties.RerollMoraleChance += 50;
	}

	function onAfterUpdate( _properties )
	{
		for( local i = _properties.MV_ForbiddenMoraleStates.len() - 1; i >= 0; i-- )
		{
			if (_properties.MV_ForbiddenMoraleStates[i] == ::Const.MoraleState.Confident)
			{
				_properties.MV_ForbiddenMoraleStates.remove(i);
			}
		}
	}

});
