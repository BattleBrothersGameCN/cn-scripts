this.rf_swordmaster_tackle_skill <- ::inherit("scripts/skills/actives/rf_swordmaster_active_abstract", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rf_swordmaster_tackle";
		this.m.Name = "擒抱";
		this.m.Description = "以纯粹的力量和技巧擒抱敌人，与他们交换位置。";
		this.m.Icon = "skills/rf_swordmaster_tackle_skill.png";
		this.m.IconDisabled = "skills/rf_swordmaster_tackle_skill_sw.png";
		this.m.Overlay = "rf_swordmaster_tackle_skill";
		this.m.SoundOnUse = [
			"sounds/combat/indomitable_01.wav",
			"sounds/combat/indomitable_02.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.LineBreaker;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		local attack = this.getContainer().getAttackOfOpportunity();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("免费对目标施展一次" + ::Reforged.NestedTooltips.getNestedSkillName(this.getContainer().getAttackOfOpportunity()) + " on the target")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("若攻击成功，[击晕|Skill+stunned_effect]目标并和其交换位置")
		});

		if (!this.getContainer().getActor().isArmedWithTwoHandedWeapon() && !this.getContainer().getActor().getItems().hasEmptySlot(::Const.ItemSlot.Offhand))
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("需要双手剑或双手持握的单手剑")
			});
		}

		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::MSU.Text.colorNegative("被定身时无法使用")
			});
		}

		this.addEnabledTooltip(ret);
		return ret;
	}

	function getCursorForTile( _tile )
	{
		return ::Const.UI.Cursor.Rotation;
	}

	function isUsable()
	{
		return this.rf_swordmaster_active_abstract.isUsable() && !this.getContainer().getActor().getCurrentProperties().IsRooted && (this.getContainer().getActor().isArmedWithTwoHandedWeapon() || this.getContainer().getActor().getItems().hasEmptySlot(::Const.ItemSlot.Offhand));
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (target.isAlliedWith(this.getContainer().getActor()))
		{
			return false;
		}

		return this.skill.onVerifyTarget(_originTile, _targetTile) && !target.getCurrentProperties().IsImmuneToStun && !target.getCurrentProperties().IsRooted && target.getCurrentProperties().IsMovable && !target.getCurrentProperties().IsImmuneToRotation;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local userTile = _user.getTile();
		local aoo = this.getContainer().getAttackOfOpportunity();
		local overlay = aoo.m.Overlay;
		aoo.m.Overlay = "";
		local success = aoo.useForFree(_targetTile);
		aoo.m.Overlay = overlay;

		if (success && target.isAlive())
		{
			target.getSkills().add(::new("scripts/skills/effects/stunned_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + "擒抱并击晕了" + ::Const.UI.getColorizedEntityName(target));
			}

			::Tactical.getNavigator().switchEntities(_user, target, null, null, 1.0);
		}

		return success;
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		return _targetTile;
	}

});
