::Reforged.HooksMod.hook("scripts/skills/actives/taunt", function ( q )
{
	q.m.DefenseModifierFraction <- 0.2;
	q.m.MaxRangeForDefenseDebuff <- 1;
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				if (this.m.DefenseModifierFraction != 0)
				{
					if (::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
					{
						ret.push({
							id = 10,
							type = "text",
							icon = "ui/icons/special.png",
							text = ::Reforged.Mod.Tooltips.parseString("对相邻目标使用时，降低其[近战防御|Concept.MeleeDefense]和[远程防御|Concept.RangeDefense]，降低值为" + ::MSU.Text.colorizePct(this.m.DefenseModifierFraction) + "x你当前的[决心|Concept.Bravery]")
						});
					}
					else
					{
						ret.push({
							id = 10,
							type = "text",
							icon = "ui/icons/special.png",
							text = ::Reforged.Mod.Tooltips.parseString("对相邻目标使用时，降低其[近战防御|Concept.MeleeDefense]和[远程防御|Concept.RangeDefense]，降低值为" + ::MSU.Text.colorizeValue(this.calculateDefenseModifier()) + " (" + ::MSU.Text.colorizePct(this.m.DefenseModifierFraction) + "x你当前的[决心|Concept.Bravery])）")
						});
					}
				}

				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "技能范围为" + ::MSU.Text.colorizeValue(this.getMaxRange()) + "格"
				});
				return ret;
			}

		}.getTooltip;
	};
	q.onVerifyTarget = function ( __original )
	{
		return {
			function onVerifyTarget( _originTile, _targetTile )
			{
				local ret = __original(_originTile, _targetTile);

				if (ret && _targetTile.getEntity().getSkills().hasSkill("effects.taunted"))
				{
					return false;
				}

				return ret;
			}

		}.onVerifyTarget;
	};
	q.onUse = function ( __original )
	{
		return {
			function onUse( _user, _targetTile )
			{
				local ret = __original(_user, _targetTile);

				if (!ret)
				{
					return ret;
				}

				local target = _targetTile.getEntity();

				if (this.getContainer().getActor().getTile().getDistanceTo(_targetTile) <= this.m.MaxRangeForDefenseDebuff)
				{
					local tauntEffect = target.getSkills().getSkillByID("effects.taunted");
					tauntEffect.m.DefenseModifier = this.calculateDefenseModifier();
				}

				target.getSkills().update();
				return true;
			}

		}.onUse;
	};
	q.calculateDefenseModifier <- {
		function calculateDefenseModifier()
		{
			local defenseModifier = -1.0 * this.m.DefenseModifierFraction * this.getContainer().getActor().getCurrentProperties().getBravery();
			return ::Math.min(0, defenseModifier);
		}

	}.calculateDefenseModifier;
});
