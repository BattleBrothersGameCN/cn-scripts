this.rf_swordmaster_push_through_skill <- ::inherit("scripts/skills/actives/line_breaker", {
	m = {},
	function create()
	{
		this.line_breaker.create();
		this.m.ID = "actives.rf_swordmaster_push_through";
		this.m.Name = "推搡";
		this.m.Description = "利用肌肉和擒抱技巧，在一次行动中，击退目标并占据其位置。";
		this.m.Icon = "skills/rf_swordmaster_push_through_skill.png";
		this.m.IconDisabled = "skills/rf_swordmaster_push_through_skill_sw.png";
		this.m.Overlay = "rf_swordmaster_push_through_skill";
		this.m.SoundOnUse = [
			"sounds/combat/indomitable_01.wav",
			"sounds/combat/indomitable_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/knockback_hit_01.wav",
			"sounds/combat/knockback_hit_02.wav",
			"sounds/combat/knockback_hit_03.wav"
		];
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.LineBreaker;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		local actor = this.getContainer().getActor();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("会[趔趄|Skill+staggered_effect]目标")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("对目标施展一次免费的" + ::Reforged.NestedTooltips.getNestedSkillName(this.getContainer().getAttackOfOpportunity()) + " on the target")
		});
		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("若攻击成功，自动对目标使用免费的[破阵者|Skill+line_breaker]技能")
		});

		if (actor.getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("被[定身|Concept.Rooted]时无法使用"))
			});
		}

		if (!this.isEnabled())
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("需要装备剑")
			});
		}

		return ret;
	}

	function isEnabled()
	{
		if (this.getContainer().getActor().isDisarmed())
		{
			return false;
		}

		local weapon = this.getContainer().getActor().getMainhandItem();
		return weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Sword);
	}

	function isUsable()
	{
		local actor = this.getContainer().getActor();
		return this.line_breaker.isUsable() && !actor.getCurrentProperties().IsRooted && !actor.getCurrentProperties().IsStunned && this.isEnabled();
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		target.getSkills().add(::new("scripts/skills/effects/staggered_effect"));

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + "推出并趔趄了" + ::Const.UI.getColorizedEntityName(target));
		}

		local aoo = this.getContainer().getAttackOfOpportunity();
		local overlay = aoo.m.Overlay;
		aoo.m.Overlay = "";
		local success = aoo.useForFree(_targetTile);
		aoo.m.Overlay = overlay;

		if (success)
		{
			local tag = {
				User = _user,
				TargetTile = _targetTile,
				TargetEntity = target
			};
			::Time.scheduleEvent(::TimeUnit.Virtual, 1, this.onPushThrough.bindenv(this), tag);
		}

		return success;
	}

	function onPushThrough( _tag )
	{
		if (_tag.TargetEntity.isAlive())
		{
			this.line_breaker.onUse(_tag.User, _tag.TargetTile);
		}
		else
		{
			::Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, null, null, false);
		}
	}

});
