this.rf_take_aim_effect <- ::inherit("scripts/skills/skill", {
	m = {
		DiversionMaxLevelDifference = null
	},
	function create()
	{
		this.m.ID = "effects.rf_take_aim";
		this.m.Name = "瞄准中";
		this.m.Description = "该角色正聚精会神，以期更好的瞄准目标。";
		this.m.Icon = "skills/rf_take_aim_effect.png";
		this.m.IconMini = "rf_take_aim_effect_mini";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "在下次远程攻击中："
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "弩可忽略任何障碍物造成的命中率惩罚，射击也不会走偏"
		});
		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "火铳的最大射程增加" + ::MSU.Text.colorPositive(1) + "点，如向交近距离上开火，则是其攻击范围会增加" + ::MSU.Text.colorPositive(1) + " instead"
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("会在结束[回合|Concept.Turn]后失效")
		});
		return ret;
	}

	function isEnabled()
	{
		local skill = this.getContainer().getSkillByID("actives.rf_take_aim");
		return skill != null && skill.isEnabled();
	}

	function onUpdate( _properties )
	{
		if (this.isEnabled())
		{
			_properties.RangedAttackBlockedChanceMult = 0;
		}
	}

	function onAfterUpdate( _properties )
	{
		local fireHandgonne = this.getContainer().getSkillByID("actives.fire_handgonne");

		if (fireHandgonne != null)
		{
			fireHandgonne.m.MaxRange += 1;
		}
	}

	function onBeforeAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		this.m.DiversionMaxLevelDifference = null;

		if (_skill.isAttack() && _skill.isRanged())
		{
			local weapon = this.getContainer().getActor().getMainhandItem();

			if (weapon != null && weapon.isWeaponType(::Const.Items.WeaponType.Crossbow))
			{
				this.m.DiversionMaxLevelDifference = ::Const.Combat.DiversionMaxLevelDifference;
				::Const.Combat.DiversionMaxLevelDifference = -100;
			}
		}
	}

	function onAnySkillExecutedFully( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (this.m.DiversionMaxLevelDifference != null)
		{
			::Const.Combat.DiversionMaxLevelDifference = this.m.DiversionMaxLevelDifference;
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.removeSelf();
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.removeSelf();
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

});
