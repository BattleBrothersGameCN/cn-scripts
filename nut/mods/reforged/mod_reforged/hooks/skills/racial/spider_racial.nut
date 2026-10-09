::Reforged.HooksMod.hook("scripts/skills/racial/spider_racial", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "蜘蛛";
				this.m.Description = "";
				this.m.Icon = "ui/orientation/spider_01_orientation.png";
				this.m.IsHidden = false;
				this.addType(::Const.SkillType.StatusEffect);

				if (this.isType(::Const.SkillType.Perk))
				{
					this.removeType(::Const.SkillType.Perk);
				}
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getTooltip();
				ret.extend([
					{
						id = 10,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = ::Reforged.Mod.Tooltips.parseString("战场上每有一个同阵营的盟友，[决心|Concept.Bravery]" + ::MSU.Text.colorPositive("+3") + " for every other ally on the battlefield of the same faction")
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/direct_damage.png",
						text = ::Reforged.Mod.Tooltips.parseString("攻击[$ $|Skill+web_effect]的目标时，穿甲伤害提高" + ::MSU.Text.colorPositive("100%"))
					},
					{
						id = 20,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("不受[$ $|Skill+night_effect]惩罚影响")
					},
					{
						id = 21,
						type = "text",
						icon = "ui/icons/special.png",
						text = "免疫毒素"
					},
					{
						id = 23,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("免疫[$ $|Skill+disarmed_effect]")
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
	q.onAdded = function ()
	{
		return {
			function onAdded()
			{
				local baseProperties = this.getContainer().getActor().getBaseProperties();
				baseProperties.IsAffectedByNight = false;
				baseProperties.IsImmuneToDisarm = true;
				baseProperties.IsImmuneToPoison = true;
			}

		}.onAdded;
	};
});
