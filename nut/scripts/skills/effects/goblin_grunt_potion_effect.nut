this.goblin_grunt_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.goblin_grunt_potion";
		this.m.Name = "反应性腿部肌肉(Reactive Leg Muscles)";
		this.m.Icon = "skills/status_effect_124.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_124";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "这个角色的腿部基因发生了突变，允许他们进行更为流畅和快速的迅猛动作。在休息时，肌肉可以偶尔在皮肤下看到微微的抽动。";
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "换位和步法技能的行动点消耗降低至  [color=" + this.Const.UI.Color.PositiveValue + "]2[/color]"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "换位和步法技能的疲劳值产生量降低  [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color]"
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "下次喝下突变药剂时会导致更长时间的疾病"
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.IsFleetfooted = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isGoblinGruntPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGoblinGruntPotionAcquired", false);
	}

});
