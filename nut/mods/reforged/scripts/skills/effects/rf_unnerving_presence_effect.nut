this.rf_unnerving_presence_effect <- ::inherit("scripts/skills/skill", {
	m = {
		Difficulty = -10
	},
	function create()
	{
		this.m.ID = "effects.rf_unnerving_presence";
		this.m.Name = "慑心威压";
		this.m.Description = "该角色周身环绕着强烈的恐惧气场，任何胆敢靠近的人都会被其啃噬心智。";
		this.m.Icon = "skills/rf_unnerving_presence_effect.png";
		this.m.Overlay = "rf_unnerving_presence_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local difficultyText = this.m.Difficulty == 0 ? "" : this.format("按照%s点[决心值|Concept.Bravery]", ::MSU.Text.colorizeValue(this.m.Difficulty, {
			AddSign = true
		}));
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = ::Reforged.Mod.Tooltips.parseString(this.format("所有角色接邻你结束[回合|Concept.Turn]时%s进行一次精神[士气检定|Concept.Morale]", difficultyText))
		});
		return ret;
	}

	function onActorSpawned( _actor )
	{
		if (!::MSU.isKindOf(_actor, "rf_draugr") && !_actor.getSkills().hasSkill("special.rf_unnerving_presence_manager"))
		{
			_actor.getSkills().add(::new("scripts/skills/special/rf_unnerving_presence_manager"));
		}
	}

	function onEnemyTurnEnd( _enemy )
	{
		if (_enemy.getMoraleState() == ::Const.MoraleState.Ignore)
		{
			return;
		}

		_enemy.checkMorale(-1, this.m.Difficulty, ::Const.MoraleCheckType.MentalAttack, this.m.Overlay);
	}

});
