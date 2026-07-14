local getThresholdForInjury = function ( _script )
{
	foreach( entry in ::Const.Injury.All )
	{
		if (entry.Script == _script)
		{
			return entry.Threshold * 100;
		}
	}
};
::Reforged.HooksMod.hookTree("scripts/entity/world/world_entity", function ( q )
{
	q.updateStrength = function ( __original )
	{
		return {
			function updateStrength()
			{
				local original_IsApplyingNestingForEvents = ::Reforged.NestedTooltips.__IsApplyingNestingForEvents;
				::Reforged.NestedTooltips.__IsApplyingNestingForEvents = 0;
				__original();
				::Reforged.NestedTooltips.__IsApplyingNestingForEvents = original_IsApplyingNestingForEvents;
			}

		}.updateStrength;
	};
});
::Reforged.HooksMod.hookTree("scripts/entity/tactical/actor", function ( q )
{
	q.getName = function ( __original )
	{
		return {
			function getName()
			{
				return ::Reforged.NestedTooltips.isApplyingNestingForEvents() ? ::Reforged.Mod.Tooltips.parseString(this.format("[%s|EventActor+%i]", ::Reforged.Mod.Tooltips.removeAllFromString(__original()), this.getID())) : __original();
			}

		}.getName;
	};
	q.getNameOnly = function ( __original )
	{
		return {
			function getNameOnly()
			{
				return ::Reforged.NestedTooltips.isApplyingNestingForEvents() ? ::Reforged.Mod.Tooltips.parseString(this.format("[%s|EventActor+%i]", ::Reforged.Mod.Tooltips.removeAllFromString(__original()), this.getID())) : __original();
			}

		}.getNameOnly;
	};
});
::Reforged.HooksMod.hookTree("scripts/items/item", function ( q )
{
	q.getName = function ( __original )
	{
		return {
			function getName()
			{
				return ::Reforged.NestedTooltips.isApplyingNestingForEvents() ? ::Reforged.Mod.Tooltips.parseString(this.format("[%s|Obj+%s,contentType:ui-item]", ::Reforged.Mod.Tooltips.removeAllFromString(__original()), ::Reforged.Mod.Tooltips.parseObject(this))) : __original();
			}

		}.getName;
	};
	q.getIcon = function ( __original )
	{
		return {
			function getIcon()
			{
				return ::Reforged.NestedTooltips.isApplyingNestingForEvents() ? ::Reforged.Mod.Tooltips.parseString(this.format("[Img/gfx/ui/items/%s|Obj+%s,contentType:ui-item]", ::Reforged.Mod.Tooltips.removeAllFromString(__original()), ::Reforged.Mod.Tooltips.parseObject(this))) : __original();
			}

		}.getIcon;
	};
});
::Reforged.HooksMod.hookTree("scripts/skills/skill", function ( q )
{
	q.getName = function ( __original )
	{
		return {
			function getName()
			{
				return ::Reforged.NestedTooltips.isApplyingNestingForEvents() ? ::Reforged.Mod.Tooltips.parseString(this.format("[%s|Skill+%s%s]", ::Reforged.Mod.Tooltips.removeAllFromString(__original()), this.ClassName, ::MSU.isNull(this.getContainer()) ? "" : ",entityId:" + this.getContainer().getActor().getID())) : __original();
			}

		}.getName;
	};

	if (q.contains("getNameOnly"))
	{
		q.getNameOnly = function ( __original )
		{
			return {
				function getNameOnly()
				{
					return ::Reforged.NestedTooltips.isApplyingNestingForEvents() ? ::Reforged.Mod.Tooltips.parseString(this.format("[%s|Skill+%s%s]", ::Reforged.Mod.Tooltips.removeAllFromString(__original()), this.ClassName, ::MSU.isNull(this.getContainer()) ? "" : ",entityId:" + this.getContainer().getActor().getID())) : __original();
				}

			}.getNameOnly;
		};
	}

	q.getIcon = function ( __original )
	{
		return {
			function getIcon()
			{
				return ::Reforged.NestedTooltips.isApplyingNestingForEvents() ? ::Reforged.Mod.Tooltips.parseString(this.format("[Img/gfx/%s|Skill+%s%s]", ::Reforged.Mod.Tooltips.removeAllFromString(__original()), this.ClassName, ::MSU.isNull(this.getContainer()) ? "" : ",entityId:" + this.getContainer().getActor().getID())) : __original();
			}

		}.getIcon;
	};
	q.getIconColored = function ( __original )
	{
		return {
			function getIconColored()
			{
				return ::Reforged.NestedTooltips.isApplyingNestingForEvents() ? ::Reforged.Mod.Tooltips.parseString(this.format("[Img/gfx/%s|Skill+%s%s]", ::Reforged.Mod.Tooltips.removeAllFromString(__original()), this.ClassName, ::MSU.isNull(this.getContainer()) ? "" : ",entityId:" + this.getContainer().getActor().getID())) : __original();
			}

		}.getIconColored;
	};
	q.getIconDisabled = function ( __original )
	{
		return {
			function getIconDisabled()
			{
				return ::Reforged.NestedTooltips.isApplyingNestingForEvents() ? ::Reforged.Mod.Tooltips.parseString(this.format("[Img/gfx/%s|Skill+%s%s]", ::Reforged.Mod.Tooltips.removeAllFromString(__original()), this.ClassName, ::MSU.isNull(this.getContainer()) ? "" : ",entityId:" + this.getContainer().getActor().getID())) : __original();
			}

		}.getIconDisabled;
	};
});
::Reforged.HooksMod.hookTree("scripts/factions/faction", function ( q )
{
	q.getName = function ( __original )
	{
		return {
			function getName()
			{
				return ::Reforged.NestedTooltips.isApplyingNestingForEvents() ? ::Reforged.Mod.Tooltips.parseString(this.format("[%s|Faction+%i]", ::Reforged.Mod.Tooltips.removeAllFromString(__original()), this.getID())) : __original();
			}

		}.getName;
	};
	q.spawnEntity = function ( __original )
	{
		return {
			function spawnEntity( _tile, _name, _uniqueName, _template, _resources, _minibossify = 0 )
			{
				if (::Reforged.NestedTooltips.isApplyingNestingForEvents())
				{
					_name = ::Reforged.Mod.Tooltips.removeAllFromString(_name);
				}

				return __original(_tile, _name, _uniqueName, _template, _resources, _minibossify);
			}

		}.spawnEntity;
	};

	if (q.contains("getNameOnly"))
	{
		q.getNameOnly = function ( __original )
		{
			return {
				function getNameOnly()
				{
					return ::Reforged.NestedTooltips.isApplyingNestingForEvents() ? ::Reforged.Mod.Tooltips.parseString(this.format("[%s|Faction+%i]", ::Reforged.Mod.Tooltips.removeAllFromString(__original()), this.getID())) : __original();
				}

			}.getNameOnly;
		};
	}
});
::Reforged.HooksMod.hookTree("scripts/entity/world/world_entity", function ( q )
{
	q.getName = function ( __original )
	{
		return {
			function getName()
			{
				return ::Reforged.NestedTooltips.isApplyingNestingForEvents() ? ::Reforged.Mod.Tooltips.parseString(this.format("[%s|WorldEntity+%i]", ::Reforged.Mod.Tooltips.removeAllFromString(__original()), this.getID())) : __original();
			}

		}.getName;
	};
});
::Reforged.HooksMod.hookTree("scripts/entity/world/attached_location", function ( q )
{
	q.getRealName = function ( __original )
	{
		return {
			function getRealName()
			{
				return ::Reforged.NestedTooltips.isApplyingNestingForEvents() ? ::Reforged.Mod.Tooltips.parseString(this.format("[%s|WorldEntity+%i]", ::Reforged.Mod.Tooltips.removeAllFromString(__original()), this.getID())) : __original();
			}

		}.getRealName;
	};
});
::Reforged.NestedTooltips <- {
	__IsApplyingNestingForEvents = 0,
	Tooltips = {
		Concept = {}
	},
	AutoConcepts = [
		"character-stats.ActionPoints",
		"character-stats.Hitpoints",
		"character-stats.Morale",
		"character-stats.Fatigue",
		"character-stats.MaximumFatigue",
		"character-stats.ArmorHead",
		"character-stats.ArmorBody",
		"character-stats.MeleeSkill",
		"character-stats.RangeSkill",
		"character-stats.MeleeDefense",
		"character-stats.RangeDefense",
		"character-stats.SightDistance",
		"character-stats.RegularDamage",
		"character-stats.CrushingDamage",
		"character-stats.ChanceToHitHead",
		"character-stats.Initiative",
		"character-stats.Bravery",
		"character-stats.Talent",
		"character-stats.SightDistance",
		"character-screen.left-panel-header-module.Experience",
		"character-screen.left-panel-header-module.Level",
		"assets.BusinessReputation",
		"assets.MoralReputation"
	],
	function setApplyNestingForEvents( _apply )
	{
		if (_apply)
		{
			this.__IsApplyingNestingForEvents += 1;
		}
		else if (this.__IsApplyingNestingForEvents > 0)
		{
			this.__IsApplyingNestingForEvents -= 1;
		}
	}

	function isApplyingNestingForEvents()
	{
		return this.__IsApplyingNestingForEvents != 0;
	}

	function getNestedPerkName( _obj, _extraData = null )
	{
		local perkDef = ::Const.Perks.findById(_obj.getID());
		return this.format("[%s|Perk+%s%s]", perkDef != null ? perkDef.Name : _obj.m.Name, _obj.ClassName, _extraData == null ? "" : "," + _extraData);
	}

	function getNestedPerkImage( _obj, _extraData = null )
	{
		local perkDef = ::Const.Perks.findById(_obj.getID());
		return this.format("[Img/gfx/%s|Perk+%s%s,cssClass:rf-nested-skill-image]", perkDef != null ? perkDef.Icon : _obj.getIcon(), _obj.ClassName, _extraData == null ? "" : "," + _extraData);
	}

	function getNestedSkillName( _obj, _extraData = null, _getName = false )
	{
		return this.format("[%s|Skill+%s%s]", _getName ? _obj.getName() : _obj.m.Name, _obj.ClassName, _extraData == null ? "" : "," + _extraData);
	}

	function getNestedSkillImage( _obj, _extraData = null, _checkUsability = false )
	{
		local icon = !_checkUsability || _obj.isUsable() && _obj.isAffordable() ? _obj.getIconColored() : _obj.getIconDisabled();
		return this.format("[Img/gfx/%s|Skill+%s%s,cssClass:rf-nested-skill-image]", icon, _obj.ClassName, _extraData == null ? "" : "," + _extraData);
	}

	function getNestedItemName( _obj, _extraData = null )
	{
		return this.format("[%s|Item+%s%s]", _obj.getName(), _obj.ClassName, _extraData == null ? "" : "," + _extraData);
	}

	function getNestedItemImage( _obj, _extraData = null )
	{
		return this.format("[Img/gfx/ui/items/%s|Item+%s%s]", _obj.getIcon(), _obj.ClassName, _extraData == null ? "" : "," + _extraData);
	}

	function getNestedEntityImage( _obj, _extraData = null )
	{
		return this.format("[Img/gfx/ui/orientation/%s.png|Entity+%i%s,cssClass:rf-nested-skill-image]", _obj.getOverlayImage(), _obj.getID(), _extraData == null ? "" : "," + _extraData);
	}

	function getNestedEntityName( _obj, _extraData = null )
	{
		return this.format("[%s|Entity+%i%s]", _obj.getName(), _obj.getID(), _extraData == null ? "" : "," + _extraData);
	}

	function getNestedWorldEntityName( _obj, _extraData = null )
	{
		return this.format("[%s|WorldEntity+%i%s]", _obj.getName(), _obj.getID(), _extraData == null ? "" : "," + _extraData);
	}

	function getNestedFactionName( _obj, _extraData = null )
	{
		return this.format("[%s|Faction+%i%s]", _obj.getName(), _obj.getID(), _extraData == null ? "" : "," + _extraData);
	}

	function getNestedObjectName( _obj, _extraData = null )
	{
		return this.format("[%s|Obj+%s%s]", _obj.getName(), ::Reforged.Mod.Tooltips.parseObject(_obj), _extraData == null ? "" : "," + _extraData);
	}

};
::Reforged.QueueBucket.FirstWorldInit.push(function ()
{
	foreach( concept in ::Reforged.NestedTooltips.AutoConcepts )
	{
		local c = concept;
		::Reforged.NestedTooltips.Tooltips.Concept[this.split(concept, ".").top()] <- ::MSU.Class.CustomTooltip(function ( _ )
		{
			return ::TooltipScreen.m.TooltipEvents.general_queryUIElementTooltipData(::MSU.getDummyPlayer().getID(), c, null);
		});
		  // [026]  OP_CLOSE          0      5    0    0
	}

	::MSU.Table.merge(::Reforged.NestedTooltips.Tooltips.Concept, {
		Disabled = ::MSU.Class.BasicTooltip("失能", ::Reforged.Mod.Tooltips.parseString("失能的角色不能行动，而是会跳过[回合|Concept.Turn]。\n\n能造成失能的[效果|Concept.StatusEffect]包括[$ $|Skill+stunned_effect]和[$ $|Skill+sleeping_effect]等。")),
		Rooted = ::MSU.Class.BasicTooltip("定身", ::Reforged.Mod.Tooltips.parseString("被定身的角色被固定在原地，―― 不能主动或被动移动。\n\n能造成定身的[效果|Concept.StatusEffect]包括[$ $|Skill+net_effect]和[$ $|Skill+web_effect]等。")),
		Wait = ::MSU.Class.BasicTooltip("等待", ::Reforged.Mod.Tooltips.parseString($[stack offset 0].format("在某[轮|Concept.Round]行动中，如果你不是[回合排序|Concept.Turn]中的最后一位，便可以采取等待行动。这会将你移动到当前[回合排序|Concept.Turn]的末尾，使你能在该[轮|Concept.Round]结束之前再次行动。\n\n每[回合|Concept.Turn]中，你只能等待一次。%s", ::Const.CharacterProperties.InitiativeAfterWaitMult == 1.0 ? "" : "\n\n采取等待行动会使你在计算下[轮|Concept.Round]的[回合排序|Concept.Turn]时，[主动值|Concept.Initiative]" + ::MSU.Text.colorizeMult(::Const.CharacterProperties.InitiativeAfterWaitMult) + " " + (::Const.CharacterProperties.InitiativeAfterWaitMult > 1.0 ? "减少" : "less") + " [Initiative|Concept.Initiative]."))),
		Perk = ::MSU.Class.BasicTooltip("特技", ::Reforged.Mod.Tooltips.parseString("随着角色等级提高，他们会获得用于解锁强力特技的特技点数。特技会给予角色永久加成或是解锁新的技能。每花费1点特技点数，角色的[特技层级|Concept.PerkTier]就会提高1级。")),
		StatusEffect = ::MSU.Class.BasicTooltip("状态效果", ::Reforged.Mod.Tooltips.parseString("状态效果时角色身上的正面或负面影响，大多数都是暂时的。状态效果的影响各有不同，既包括增减角色[属性|Concept.CharacterAttribute]，也可以解锁新的能力。")),
		Injury = ::MSU.Class.BasicTooltip("创伤", ::Reforged.Mod.Tooltips.parseString("在战斗中，如果对角色[生命值|Concept.Hitpoints]造成了足够的伤害，就会对角色造成创伤。创伤是一种会带来各种减益的[状态效果|Concept.StatusEffect]。\n\n战斗中受到的创伤是[临时的，|Concept.InjuryTemporary]会随时间流逝愈合。这种创伤可以在神庙中治疗，加快其愈合速度。\n\n而如果角色在战斗中被杀，他们有一定概率被击倒而非杀死，带着[永久创伤|Concept.InjuryPermanent]幸存下来。")),
		InjuryTemporary = ::MSU.Class.BasicTooltip("临时创伤", ::Reforged.Mod.Tooltips.parseString("临时创伤是角色受到的[生命值|Concept.Hitpoints]伤害超过创伤阈值时受到的创伤。这些创伤会随时间自愈，也可以在神庙中接受治疗加速痊愈。")),
		InjuryPermanent = ::MSU.Class.BasicTooltip("永久创伤", ::Reforged.Mod.Tooltips.parseString("永久创伤是角色在战斗中被“击倒”而免于死亡时会受到的创伤。这些创伤以及其减益会永远持续下去。")),
		InjuryThreshold = ::MSU.Class.BasicTooltip("创伤阈值", ::Reforged.Mod.Tooltips.parseString("如果受到的[生命值|Concept.Hitpoints]伤害不少于" + ::MSU.Text.colorNegative(::Const.Combat.InjuryMinDamage) + "点，且超过了当前[生命值|Concept.Hitpoints]一定比例，角色就会受到[创伤。|Concept.InjuryTemporary]这一百分比会同时受到攻击者和目标的[特技|Concept.Perk]和特性调整。\n\n特定[创伤|Concept.InjuryTemporary]要在该百分比超过一定范围后才能造成，越重的[创伤|Concept.InjuryTemporary]需要的百分比越高。\n\n例如，[手臂割伤|Skill+cut_arm_injury]的阈值为" + ::MSU.Text.colorNegative(getThresholdForInjury("injury/cut_arm_injury") + "%") + "，而[手劈裂|Skill+split_hand_injury]的阈值则为" + ::MSU.Text.colorNegative(getThresholdForInjury("injury/split_hand_injury") + "%") + ".")),
		Reach = ::MSU.Class.CustomTooltip(function ( _data )
		{
			local ret = [
				{
					id = 1,
					type = "title",
					text = "触及距离"
				},
				{
					id = 2,
					type = "description",
					text = ::Reforged.Mod.Tooltips.parseString("触及距离是对角色攻击范围的具象化，使近战对抗触及距离短的目标更有优势。\n\n攻击触及距离短的目标时，[近战技能|Concept.MeleeSkill]会增加，反之则会降低。触及的收益随着触及距离差值增加而递减，初始为" + ::Reforged.Reach.BonusPerReach + "点，每差1降低1点，最低降至1点。这一命中修正只在攻击相邻目标或两格距离上不受阻挡的目标时生效。\n\n成功命中之后，直到攻击者等待或结束回合为止，目标的[触及优势|Concept.ReachAdvantage]失效。\n\n盾牌可以抵消目标的部分或全部[触及优势|Concept.ReachAdvantage]。被定身的角色触及距离减半。没有近战攻击能力的角色没有触及距离。")
				}
			];

			if (("entityId" in _data) && "TooltipEvents" in this.getroottable())
			{
				ret.extend(::TooltipEvents.getBaseAttributesTooltip(_data.entityId, _data.elementId, null));
			}

			return ret;
		}),
		ReachIgnoreOffensive = ::MSU.Class.BasicTooltip("进攻触及无视", ::Reforged.Mod.Tooltips.parseString("代表角色进攻[触及距离|Concept.Reach]较高的角色时可以无视的[触及劣势的值|Concept.ReachDisadvantage]")),
		ReachIgnoreDefensive = ::MSU.Class.BasicTooltip("防御触及无视", ::Reforged.Mod.Tooltips.parseString("代表角色防御[触及距离|Concept.Reach]较高的角色进攻时可以无视的[触及劣势的值|Concept.ReachDisadvantage]")),
		ReachAdvantage = ::MSU.Class.BasicTooltip("触及优势", ::Reforged.Mod.Tooltips.parseString("在一次攻击当中，当一名角色的[触及距离|Concept.Reach]高过其他角色时，他便被认为拥有触及优势。这种情况下，触及优势指代两角色间[触及距离|Concept.Reach]的差值。\n\n如果一名角色装备了盾牌，盾牌可以帮助抵消攻击者的触及优势，拥有[决斗者|Perk+perk_duelist]特技后，还可以抵消攻击目标的触及优势。")),
		ReachDisadvantage = ::MSU.Class.BasicTooltip("触及劣势", ::Reforged.Mod.Tooltips.parseString("在一次攻击当中，当一名角色的[触及距离|Concept.Reach]低于其他角色时，他便被认为拥有触及优势。这种情况下，触及优势指代两角色间[触及距离|Concept.Reach]的差值。")),
		PerkTier = ::MSU.Class.BasicTooltip("特技层级", ::Reforged.Mod.Tooltips.parseString("[特技|Concept.Perk]分布在角色特技树的7行之中，称为不同的特技层级。角色必须至少花费过特技层级-1的特技点数才能学习特定层级的特技。")),
		StackMultiplicatively = ::MSU.Class.BasicTooltip("乘法叠加", ::Reforged.Mod.Tooltips.parseString("数值叠加有两种形式，即乘法叠加和[加法叠加|Concept.StackAdditively]。\n\n例如，假设某值为100。两个分别提升40%的技能，若叠乘会提升该数值到1.4x1.4=1.96倍，即100x1.96=196。两个分别降低40%的技能，若叠乘会降低该数值到(1.0-0.4)x(1.0-0.4)=0.36倍，即100x0.36=36。\n\n通常来说，[加法叠加|Concept.StackAdditively]在数值减小或数值较小时影响更大，而乘法叠加在数值增大或数值较大时影响更大。")),
		StackAdditively = ::MSU.Class.BasicTooltip("加法叠加", ::Reforged.Mod.Tooltips.parseString("数值叠加有两种形式，即[乘法叠加|Concept.StackMultiplicatively]和加法叠加。\n\n例如，假设某值为100。两个分别提升40%的技能，若叠加会提升该数值到1.0+0.4+0.4=1.8倍，即100x1.80=180。两个分别降低40%的技能，若叠加会降低该数值到1.0-0.4-0.4=0.2倍，即100x0.20=20。\n\n通常来说，加法叠加在数值减小或数值较小时影响更大，而[乘法叠加|Concept.StackMultiplicatively]在数值增大或数值较大时影响更大。")),
		CharacterAttribute = ::MSU.Class.BasicTooltip("角色属性", ::Reforged.Mod.Tooltips.parseString("战场兄弟中的角色拥有各种属性，代表了其技能和/或在特定领域中的才干。属性包括：[生命值、|Concept.Hitpoints][疲劳值、|Concept.Fatigue][决心、|Concept.Bravery][主动值、|Concept.Initiative][近战技能、|Concept.MeleeSkill][近战防御|Concept.MeleeDefense][远程技能|Concept.RangeSkill]和[远程防御。|Concept.RangeDefense]\n\n当角色获得[经验|Concept.Experience]、提升[等级|Concept.Level]时，他们会增长属性并解锁[特技。|Concept.Perk]")),
		BaseAttribute = ::MSU.Class.BasicTooltip("基础属性", ::Reforged.Mod.Tooltips.parseString("一名角色的[属性|Concept.CharacterAttribute]会被多种因素调整，如特技、特性、状态效果和装备等。基础属性即未受这些因素调整的属性。另参见：[当前属性|Concept.CurrentAttribute]。")),
		CurrentAttribute = ::MSU.Class.BasicTooltip("当前属性", ::Reforged.Mod.Tooltips.parseString("一名角色的[属性|Concept.CharacterAttribute]会被多种因素调整，如特技、特性、状态效果和装备等。当前属性即受这些因素调整之后的属性。另参见：[基础属性|Concept.BaseAttribute]。")),
		Surrounding = ::MSU.Class.BasicTooltip("围攻", ::Reforged.Mod.Tooltips.parseString("当一名角色同时位于多名敌对角色的控制区时，他就算作进入了被围攻状态。角色近战攻击被围攻的目标时会获得额外命中率。个别特技如[$ $|Perk+perk_underdog]、[$ $|Perk+perk_backstabber]和[$ $|Perk+perk_rf_long_reach]会和围攻机制产生作用，提高或降低其效力。")),
		FatigueRecovery = ::MSU.Class.BasicTooltip("疲劳恢复", ::Reforged.Mod.Tooltips.parseString("每个回合开始时，角色的[疲劳值|Concept.Fatigue]会减少一个特定值，这被称为疲劳恢复。\n\n默认情况下，玩家角色的疲劳恢复为15。敌人根据其类型不同，可能会有更高的疲劳恢复。\n\n疲劳恢复会被[特技|Concept.Perk]、[特性|Concept.Trait]、[状态效果|Concept.StatusEffect]和[创伤|Concept.Injury]影响。")),
		AOE = ::MSU.Class.BasicTooltip("范围效果", ::Reforged.Mod.Tooltips.parseString("范围效果(AOE)技能以多个地格而非单个地格为目标。")),
		Fatality = ::MSU.Class.BasicTooltip("残杀", ::Reforged.Mod.Tooltips.parseString("残杀是一种呈现了超常惨状的特殊死亡形式。残杀包括：\n- 斩首 - 砍掉目标的头。\n- 开膛 - 将目标开膛破肚。\n- 粉碎 - 将目标的头砸成碎片。")),
		Turn = ::MSU.Class.BasicTooltip("回合", ::Reforged.Mod.Tooltips.parseString("战场兄弟的战斗基于回合进行。而每场战斗都由若干[轮|Concept.Round]组成。每个战斗轮中，各角色轮流进行自己的[回合|Concept.Turn]。某个角色回合进行的先后顺序由其[主动值|Concept.Initiative]和其他角色的相对关系决定。\n\n持续若干回合的[状态效果|Concept.StatusEffect]会在角色开始或结束相应数量的回合后失效，具体取决于效果本身。")),
		Round = ::MSU.Class.BasicTooltip("轮", ::Reforged.Mod.Tooltips.parseString("战场兄弟的战斗基于回合进行。而每场战斗都由若干轮组成。每个战斗轮中，各角色轮流进行自己的[回合|Concept.Turn]，所有角色都结束[回合|Concept.Turn]时，这个战斗轮便宣告结束。")),
		ZoneOfControl = ::MSU.Class.BasicTooltip("控制区", ::Reforged.Mod.Tooltips.parseString("大多数近战角色都会对周边地格施加控制区。每次试图离开控制区中的地格时，会触发所有控制该地格敌人的一次免费借机攻击，直到有攻击命中或者全部未命中为止。只要命中一次，这次移动就会被取消。")),
		BagSlots = ::MSU.Class.BasicTooltip("背包槽位", ::Reforged.Mod.Tooltips.parseString("背包槽位用于存放额外武器和其他在战斗中使用的实用物品。默认情况下，每名角色有" + ::new("scripts/items/item_container").getUnlockedBagSlots() + "个背包槽位，最多可以有" + ::Const.ItemSlotSpaces[::Const.ItemSlot.Bag] + ".")),
		HybridWeapon = ::MSU.Class.BasicTooltip("混种武器", ::Reforged.Mod.Tooltips.parseString("混种武器是拥有两个武器类型的武器。非混种武器只有一个武器类型。")),
		Trait = ::MSU.Class.BasicTooltip("特性", ::Reforged.Mod.Tooltips.parseString("角色可以有多个特性，这些特性是半永久的，代表了角色异于常人的方面。特性和[特技|Concept.Perk]不同，不会因获得[经验|Concept.Experience]或[升级|Concept.Level]而习得。特性会带来多种增益或减益，例如：[$ $|Skill+huge_trait]和[$ $|Skill+tiny_trait]。"))
	});
	::Reforged.Mod.Tooltips.setTooltips(::Reforged.NestedTooltips.Tooltips);
});
