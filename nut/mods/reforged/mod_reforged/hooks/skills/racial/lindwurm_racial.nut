::Reforged.HooksMod.hook("scripts/skills/racial/lindwurm_racial", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "林德蠕龙";
				this.m.Description = "";
				this.m.Icon = "ui/orientation/lindwurm_orientation.png";
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
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("对对该角色造成" + ::MSU.Text.colorPositive("11") + "点或以上[生命值|Concept.Hitpoints]伤害的接邻敌人施加[$ $|Skill+lindwurm_acid_effect]效果")
					},
					{
						id = 20,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("不受[$ $|Skill+night_effect]惩罚影响")
					},
					{
						id = 24,
						type = "text",
						icon = "ui/icons/special.png",
						text = "免疫击退和钩拽技能"
					},
					{
						id = 26,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("免疫[$ $|Skill+disarmed_effect]")
					},
					{
						id = 27,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("免疫[定身|Concept.Rooted]")
					},
					{
						id = 28,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("免疫[$ $|Skill+stunned_effect]")
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
				baseProperties.IsImmuneToKnockBackAndGrab = true;
				baseProperties.IsImmuneToStun = true;
				baseProperties.IsImmuneToRoot = true;
			}

		}.onAdded;
	};
});
