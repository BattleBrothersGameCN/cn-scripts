this.rf_take_aim_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rf_take_aim";
		this.m.Name = "仔细瞄准";
		this.m.Description = "聚精会神，更好地瞄准目标。以便用弩射中掩体后的目标，或是用火枪攻击到更远的目标。";
		this.m.Icon = "skills/rf_take_aim_skill.png";
		this.m.IconDisabled = "skills/rf_take_aim_skill_sw.png";
		this.m.Overlay = "rf_take_aim_skill";
		this.m.SoundOnUse = [];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 25;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		local takeAimEffect = ::new("scripts/skills/effects/rf_take_aim_effect");
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("获得[瞄准中|Skill+rf_take_aim_effect]效果"),
			children = takeAimEffect.getTooltip().slice(2)
		});

		if (::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()) || !this.getContainer().getActor().getMainhandItem().isLoaded())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("需要完成装填的武器")
			});
		}

		return ret;
	}

	function isEnabled()
	{
		local weapon = this.getContainer().getActor().getMainhandItem();

		if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Crossbow) && !this.getContainer().hasSkill("actives.fire_handgonne"))
		{
			return false;
		}

		return true;
	}

	function isUsable()
	{
		local actor = this.getContainer().getActor();

		if (!this.isEnabled())
		{
			return false;
		}

		return this.skill.isUsable() && actor.getMainhandItem().isLoaded() && !this.getContainer().hasSkill("effects.rf_take_aim") && !actor.isEngagedInMelee();
	}

	function isHidden()
	{
		return !this.getContainer().getActor().isArmedWithRangedWeapon();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Container.add(::new("scripts/skills/effects/rf_take_aim_effect"));
		return true;
	}

	function onRemoved()
	{
		this.m.Container.removeByID("effects.rf_take_aim");
	}

});
