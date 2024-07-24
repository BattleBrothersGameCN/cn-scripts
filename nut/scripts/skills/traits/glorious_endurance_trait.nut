this.glorious_endurance_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		DamageReduction = 0.0
	},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.glorious";
		this.m.Name = "忍耐之誉";
		this.m.Icon = "ui/traits/trait_icon_70.png";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
	}

	function getDescription()
	{
		return "这个角色在南方的竞技场上经历过许多战斗的锻炼，每一次打击只会增强他不屈不挠的意志和耐力。他奢靡的生活需要高薪来维持，但他永远不会抛弃你，也不能被解雇。如果三个初始成员都死了，你的战役就结束了。";
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
			}
		];

		if (this.m.DamageReduction > 0.0)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "仅受到所有伤害的 [color=" + this.Const.UI.Color.PositiveValue + "]" + (1.0 - this.m.DamageReduction) * 100 + "%[/color]"
			});
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "每次被击中获得5%的伤害减免，上限为25%"
		});
		return ret;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_attacker != null && _attacker.getID() != this.getContainer().getActor().getID())
		{
			this.m.DamageReduction = this.Math.minf(0.25, this.m.DamageReduction + 0.05);
			this.m.Type = this.Const.SkillType.Trait | this.Const.SkillType.StatusEffect;
		}
	}

	function onCombatStarted()
	{
		this.m.DamageReduction = 0.0;
		this.m.Type = this.Const.SkillType.Trait;
	}

	function onCombatFinished()
	{
		this.m.DamageReduction = 0.0;
		this.m.Type = this.Const.SkillType.Trait;
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedTotalMult *= 1.0 - this.m.DamageReduction;
	}

});
