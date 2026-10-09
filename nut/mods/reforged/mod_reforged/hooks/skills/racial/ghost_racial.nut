::Reforged.HooksMod.hook("scripts/skills/racial/ghost_racial", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "幽灵";
				this.m.Icon = "ui/orientation/ghost_01_orientation.png";
				this.m.IsHidden = false;

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
						icon = "ui/icons/melee_defense.png",
						text = ::Reforged.Mod.Tooltips.parseString("受到攻击时，距离攻击者每有一格远，[近战防御|Concept.MeleeDefense]和[远程防御|Concept.RangeDefense]" + ::MSU.Text.colorPositive("+10") + " [Melee Defense|Concept.MeleeDefense] and [Ranged Defense|Concept.RangeDefense] for each tile between you and the attacker")
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
						text = ::Reforged.Mod.Tooltips.parseString("不会受到[临时创伤|Concept.InjuryTemporary]，也不会被其影响。")
					},
					{
						id = 22,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("免疫[$ $|Skill+bleeding_effect]")
					},
					{
						id = 23,
						type = "text",
						icon = "ui/icons/special.png",
						text = "免疫毒素"
					},
					{
						id = 24,
						type = "text",
						icon = "ui/icons/special.png",
						text = "免疫击退和钩拽技能"
					},
					{
						id = 25,
						type = "text",
						icon = "ui/icons/special.png",
						text = "免疫火焰"
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
						text = ::Reforged.Mod.Tooltips.parseString("免疫[昏迷|Skill+stunned_effect]")
					},
					{
						id = 29,
						type = "text",
						icon = "ui/icons/morale.png",
						text = ::Reforged.Mod.Tooltips.parseString("不受[士气|Concept.Morale]影响")
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
				local actor = this.getContainer().getActor();
				actor.m.MoraleState = ::Const.MoraleState.Ignore;
				local baseProperties = actor.getBaseProperties();
				baseProperties.IsAffectedByInjuries = false;
				baseProperties.IsAffectedByNight = false;
				baseProperties.IsImmuneToBleeding = true;
				baseProperties.IsImmuneToDisarm = true;
				baseProperties.IsImmuneToFire = true;
				baseProperties.IsImmuneToKnockBackAndGrab = true;
				baseProperties.IsImmuneToPoison = true;
				baseProperties.IsImmuneToRoot = true;
				baseProperties.IsImmuneToStun = true;
				baseProperties.IsIgnoringArmorOnAttack = true;
			}

		}.onAdded;
	};
});
