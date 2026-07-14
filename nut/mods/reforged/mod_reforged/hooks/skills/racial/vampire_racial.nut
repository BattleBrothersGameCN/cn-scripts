::Reforged.HooksMod.hook("scripts/skills/racial/vampire_racial", function ( q )
{
	q.m.RF_HasFed <- false;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "吸血鬼";
				this.m.Description = "";
				this.m.Icon = "/ui/orientation/vampire_01_orientation.png";
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
						icon = "ui/icons/regular_damage.png",
						text = ::Reforged.Mod.Tooltips.parseString("恢复等于对敌方造成的[生命值|Concept.Hitpoints]伤害的" + ::MSU.Text.colorPositive("100%") + "的敌方[生命值|Concept.Hitpoints]伤害转化为治疗自身")
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
						text = "免疫毒素"
					},
					{
						id = 23,
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
				baseProperties.IsImmuneToPoison = true;
			}

		}.onAdded;
	};
	q.onTargetHit = function ( __original )
	{
		return {
			function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
			{
				if (_damageInflictedHitpoints > 0 && _skill != null && !_skill.isRanged())
				{
					this.m.RF_HasFed = true;
				}

				__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
			}

		}.onTargetHit;
	};
});
