this.rf_bearded_blade_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rf_bearded_blade";
		this.m.Name = "钩刃";
		this.m.Description = "准备使用斧头上的钩刃，缴械你的对手。";
		this.m.Icon = "skills/rf_bearded_blade_skill.png";
		this.m.IconDisabled = "skills/rf_bearded_blade_skill_sw.png";
		this.m.Overlay = "rf_bearded_blade_skill";
		this.m.SoundOnUse = [
			"sounds/combat/riposte_01.wav",
			"sounds/combat/riposte_02.wav",
			"sounds/combat/riposte_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.NonTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 15;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("获得[钩刃|Skill+rf_bearded_blade_effect]效果，创造[缴械|Skill+disarmed_effect]对手的可能")
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		if (_properties.IsSpecializedInAxes)
		{
			this.m.FatigueCostMult *= ::Const.Combat.WeaponSpecFatigueMult;
		}
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.rf_bearded_blade");
	}

	function onUse( _user, _targetTile )
	{
		this.m.Container.add(::new("scripts/skills/effects/rf_bearded_blade_effect"));

		if (!_user.isHiddenToPlayer())
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + "使出了钩刃");
		}

		return true;
	}

	function onRemoved()
	{
		this.m.Container.removeByID("effects.rf_bearded_blade");
	}

});
