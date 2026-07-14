this.rf_swordmaster_stance_meisterhau_skill <- ::inherit("scripts/skills/actives/rf_swordmaster_stance_abstract_skill", {
	m = {
		RemovedSkills = []
	},
	function create()
	{
		this.rf_swordmaster_stance_abstract_skill.create();
		this.m.ID = "actives.rf_swordmaster_stance_meisterhau";
		this.m.Name = "姿态：大师击";
		this.m.Description = "准备使用以Meisterhäu闻名的大师击，同时完成攻击和防御。";
		this.m.Icon = "skills/rf_swordmaster_stance_meisterhau_skill.png";
		this.m.IconDisabled = "skills/rf_swordmaster_stance_meisterhau_skill_sw.png";
		this.m.Overlay = "rf_swordmaster_stance_meisterhau_skill";
		this.m.SoundOnUse = [
			"sounds/combat/riposte_01.wav",
			"sounds/combat/riposte_02.wav",
			"sounds/combat/riposte_03.wav"
		];
	}

	function onAdded()
	{
		this.toggleOn();
	}

	function getTooltip()
	{
		local ret = this.rf_swordmaster_stance_abstract_skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("触发[接战势|Skill+perk_rf_en_garde]不再需要剩余[疲劳|Concept.Fatigue]")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("获得[踢击|Skill+rf_swordmaster_kick_skill]、[擒抱|Skill+rf_swordmaster_tackle_skill]和[推搡|Skill+rf_swordmaster_push_through_skill]技能")
		});
		this.addEnabledTooltip(ret);
		return ret;
	}

	function toggleOn()
	{
		if (this.m.IsOn)
		{
			return;
		}

		this.rf_swordmaster_stance_abstract_skill.toggleOn();
		this.getContainer().add(::new("scripts/skills/actives/rf_swordmaster_tackle_skill"));
		this.getContainer().add(::new("scripts/skills/actives/rf_swordmaster_kick_skill"));
		this.getContainer().add(::new("scripts/skills/actives/rf_swordmaster_push_through_skill"));
		local weapon = this.getContainer().getActor().getMainhandItem();

		if (weapon != null)
		{
			this.getContainer().getActor().getItems().unequip(weapon);
			this.getContainer().getActor().getItems().equip(weapon);
		}
	}

	function onEquip( _item )
	{
		if (_item.getSlotType() == ::Const.ItemSlot.Mainhand)
		{
			this.toggleOn();
		}
	}

	function toggleOff()
	{
		if (!this.m.IsOn)
		{
			return;
		}

		this.rf_swordmaster_stance_abstract_skill.toggleOff();
		this.getContainer().removeByID("actives.rf_swordmaster_tackle");
		this.getContainer().removeByID("actives.rf_swordmaster_kick");
		this.getContainer().removeByID("actives.rf_swordmaster_push_through");
	}

	function onRemoved()
	{
		this.rf_swordmaster_stance_abstract_skill.onRemoved();
		this.getContainer().removeByID("actives.rf_swordmaster_tackle");
		this.getContainer().removeByID("actives.rf_swordmaster_kick");
		this.getContainer().removeByID("actives.rf_swordmaster_push_through");
	}

	function onCombatStarted()
	{
		this.rf_swordmaster_stance_abstract_skill.onCombatStarted();
		this.toggleOn();
	}

	function onCombatFinished()
	{
		this.rf_swordmaster_stance_abstract_skill.onCombatFinished();
		this.toggleOn();
	}

});
