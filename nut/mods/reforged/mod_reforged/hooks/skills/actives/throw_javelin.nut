::Reforged.HooksMod.hook("scripts/skills/actives/throw_javelin", function ( q )
{
	q.m.AdditionalAccuracy = 20;
	q.m.AdditionalHitChance = -15;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.FatigueCost = 14;
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
						text = "剩余" + ::MSU.Text.colorPositive(ammo) + "支标枪"
					});
				}
				else
				{
					ret.push({
						id = 8,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = ::MSU.Text.colorNegative("标枪用尽")
					});
				}

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
	q.onAfterUpdate = function ( __original )
	{
		return {
			function onAfterUpdate( _properties )
			{
				local additionalAccuracy = this.m.AdditionalAccuracy;
				__original(_properties);
				this.m.AdditionalAccuracy = additionalAccuracy;
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
				}
			}

		}.onAnySkillUsed;
	};
});
