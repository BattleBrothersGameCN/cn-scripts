this.rf_swordmaster_stance_half_swording_skill <- ::inherit("scripts/skills/actives/rf_swordmaster_stance_abstract_skill", {
	m = {},
	function create()
	{
		this.rf_swordmaster_stance_abstract_skill.create();
		this.m.ID = "actives.rf_swordmaster_stance_half_swording";
		this.m.Name = "姿态：半剑术";
		this.m.Description = "切换到半剑握法，使你可以进行精准的刺击，刺穿目标盔甲。";
		this.m.Icon = "skills/rf_swordmaster_stance_half_swording_skill.png";
		this.m.IconDisabled = "skills/rf_swordmaster_stance_half_swording_skill_sw.png";
		this.m.Overlay = "rf_swordmaster_stance_half_swording_skill";
		this.m.SoundOnUse = [
			"sounds/combat/riposte_01.wav",
			"sounds/combat/riposte_02.wav",
			"sounds/combat/riposte_03.wav"
		];
	}

	function getTooltip()
	{
		local ret = this.rf_swordmaster_stance_abstract_skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("移除") + "当前装备剑的所有技能，添加[刺击|Skill+stab]和[穿刺|Skill+puncture]技能。刺击技能造成的伤害降低" + ::MSU.Text.colorNegative("50%") + " reduced damage")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/rf_reach.png",
			text = ::Reforged.Mod.Tooltips.parseString("武器[触及|Concept.Reach]" + ::MSU.Text.colorNegative("减半") + " of your weapon\'s [Reach|Concept.Reach]")
		});

		if (!this.getContainer().getActor().isArmedWithTwoHandedWeapon() && !this.getContainer().getActor().getItems().hasEmptySlot(::Const.ItemSlot.Offhand))
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("需要双手剑或双手持握的单手剑")
			});
		}

		this.addEnabledTooltip(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		if (!this.m.IsOn)
		{
			return;
		}

		local weapon = this.getContainer().getActor().getMainhandItem();

		if (weapon != null)
		{
			_properties.Reach -= ::Math.floor(weapon.getReach() * 0.5);
		}
	}

	function isUsable()
	{
		return this.rf_swordmaster_stance_abstract_skill.isUsable() && (this.getContainer().getActor().isArmedWithTwoHandedWeapon() || this.getContainer().getActor().getItems().hasEmptySlot(::Const.ItemSlot.Offhand));
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.m.IsOn && _skill.getID() == "actives.stab")
		{
			_properties.DamageTotalMult *= 0.5;
		}
	}

	function onUnequip( _item )
	{
		if (this.m.IsOn && _item.getSlotType() == ::Const.ItemSlot.Mainhand)
		{
			this.toggleOff();
		}
	}

	function toggleOn()
	{
		if (this.m.IsOn)
		{
			return;
		}

		this.rf_swordmaster_stance_abstract_skill.toggleOn();
		local weapon = this.getContainer().getActor().getMainhandItem();
		local skills = [];

		foreach( s in weapon.getSkills() )
		{
			if (!s.isActive())
			{
				continue;
			}

			if (!s.isAttack())
			{
				skills.push(s);
			}

			weapon.removeSkill(s);
		}

		skills.push(::Reforged.new("scripts/skills/actives/stab", function ( o )
		{
			o.m.DirectDamageMult = weapon.m.DirectDamageMult;
		}));
		skills.push(::Reforged.new("scripts/skills/actives/puncture", function ( o )
		{
			o.m.Order += 1;
		}));
		skills.sort(function ( _a, _b )
		{
			return _a.getOrder()  _b.getOrder();
		});

		foreach( s in skills )
		{
			weapon.addSkill(s);
		}
	}

	function onCombatFinished()
	{
		this.rf_swordmaster_stance_abstract_skill.onCombatFinished();
		this.toggleOff();
	}

});
