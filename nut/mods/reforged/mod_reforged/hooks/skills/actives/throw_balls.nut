::Reforged.HooksMod.hook("scripts/skills/actives/throw_balls", function ( q )
{
	q.m.AdditionalAccuracy <- 20;
	q.m.AdditionalHitChance <- -15;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.FatigueCost = 12;
				this.m.IsShieldRelevant = false;
			}

		}.create;
	};
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
						text = "剩余" + ::MSU.Text.colorPositive(ammo) + "枚流星锤"
					});
				}
				else
				{
					ret.push({
						id = 8,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = ::MSU.Text.colorNegative("流星锤用尽")
					});
				}

				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("无视盾牌的[远程防御|Concept.RangeDefense]加成")
				});

				if (this.getContainer().getActor().isEngagedInMelee())
				{
					ret.push({
						id = 9,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("角色[陷入近战|Concept.ZoneOfControl]，无法使用"))
					});
				}

				return ret;
			}

		}.getTooltip;
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
				}
			}

		}.onAnySkillUsed;
	};
});
