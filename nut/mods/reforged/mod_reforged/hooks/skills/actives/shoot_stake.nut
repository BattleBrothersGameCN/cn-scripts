::Reforged.HooksMod.hook("scripts/skills/actives/shoot_stake", function ( q )
{
	q.m.AdditionalAccuracy = 10;
	q.m.AdditionalHitChance = -3;
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.getRangedTooltip(this.skill.getDefaultTooltip());
				local ammo = this.getAmmo();

				if (ammo > 0)
				{
					ret.push({
						id = 8,
						type = "text",
						icon = "ui/icons/ammo.png",
						text = "剩余" + ::MSU.Text.colorPositive(ammo) + "支弩箭"
					});
				}
				else
				{
					ret.push({
						id = 8,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = ::MSU.Text.colorNegative("需要装备非空弩箭袋")
					});
				}

				if (!this.getItem().isLoaded())
				{
					ret.push({
						id = 9,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = ::MSU.Text.colorNegative("必须重新装填才能再次射击")
					});
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onAfterUpdate = function ()
	{
		return {
			function onAfterUpdate( _properties )
			{
				if (_properties.IsSpecializedInCrossbows)
				{
					this.m.FatigueCostMult *= ::Const.Combat.WeaponSpecFatigueMult;
				}
			}

		}.onAfterUpdate;
	};
	q.onAnySkillUsed = function ()
	{
		return {
			function onAnySkillUsed( _skill, _targetEntity, _properties )
			{
				if (_skill == this)
				{
					_properties.RangedSkill += this.m.AdditionalAccuracy;
					_properties.HitChanceAdditionalWithEachTile += this.m.AdditionalHitChance;

					if (_properties.IsSharpshooter)
					{
						_properties.DamageDirectMult += 0.05;
					}
				}
			}

		}.onAnySkillUsed;
	};
});
