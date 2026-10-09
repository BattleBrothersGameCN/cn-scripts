::Reforged.HooksMod.hook("scripts/skills/special/night_effect", function ( q )
{
	q.m.HitChancePerTile <- -10;
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				foreach( entry in ret )
				{
					if (entry.id == 12 && entry.icon == "ui/icons/ranged_skill.png")
					{
						entry.text = "每远一格，命中率" + ::MSU.Text.colorizeValue(this.m.HitChancePerTile, {
							AddSign = true,
							AddPercent = true
						}) + " chance to hit per tile of distance";
					}
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onGetHitFactors = function ( __original )
	{
		return {
			function onGetHitFactors( _skill, _targetTile, _tooltip )
			{
				__original(_skill, _targetTile, _tooltip);

				if (_skill.isAttack() && _skill.isRanged() && !this.isHidden())
				{
					local malus = this.m.HitChancePerTile * (this.getContainer().getActor().getTile().getDistanceTo(_targetTile) - _skill.getMinRange());

					if (malus != 0)
					{
						_tooltip.push({
							icon = "ui/tooltips/negative.png",
							text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(malus, {
								AddPercent = true
							}) + "[黑夜|Skill+night_effect]")
						});
					}
				}
			}

		}.onGetHitFactors;
	};
	q.onUpdate = function ( __original )
	{
		return {
			function onUpdate( _properties )
			{
				local oldRangedSkillMult = _properties.RangedSkillMult;
				__original(_properties);
				_properties.RangedSkillMult = oldRangedSkillMult;

				if (_properties.IsAffectedByNight)
				{
					_properties.HitChanceAdditionalWithEachTile += this.m.HitChancePerTile;
				}
			}

		}.onUpdate;
	};
});
