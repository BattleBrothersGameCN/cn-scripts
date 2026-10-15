this.perk_rf_rebuke <- ::inherit("scripts/skills/skill", {
	m = {
		BaseChance = 25,
		ChanceBonusShield = 15,
		BuildsFatigue = true,
		__ChanceBonus = 0,
		__RiposteSkillCounter = 0
	},
	function create()
	{
		this.m.ID = "perk.rf_rebuke";
		this.m.Name = ::Const.Strings.PerkName.RF_Rebuke;
		this.m.Description = "该角色有几率用一次免费攻击对相邻攻击者的未命中近战攻击进行还击。";
		this.m.Icon = "ui/perks/perk_rf_rebuke.png";
		this.m.IconMini = "perk_rf_rebuke_mini";
		this.m.Overlay = "perk_rf_rebuke";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function softReset()
	{
		this.skill.softReset();
		this.resetField("BaseChance");
		this.resetField("ChanceBonusShield");
		this.resetField("BuildsFatigue");
		this.resetField("__ChanceBonus");
	}

	function isHidden()
	{
		return this.getChance() == 0;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::MSU.Text.colorizeValue(this.getChance(), {
				AddPercent = true
			}) + " chance to perform a free attack against characters who miss a melee attack against this character"
		});

		if (this.m.BuildsFatigue)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "若未能通过[士气检定|Concept.Morale]，攻击会积累[疲劳值|Concept.Fatigue]。"
			});
		}

		if (this.getContainer().getAttackOfOpportunity() == null)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("需要能施加[控制区|Concept.ZoneOfControl]的近战攻击"))
			});
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().isArmedWithShield())
		{
			this.m.BuildsFatigue = false;
			this.m.__ChanceBonus += this.m.ChanceBonusShield;
		}
	}

	function getQueryTargetValueMult( _entity, _target, _skill )
	{
		return this.getChance() == 0 || !this.canProc(_entity, _skill) ? 1.0 : _entity.getAIAgent().getProperties().TargetPriorityCounterSkillsMult;
	}

	function canProc( _attacker, _skill )
	{
		if (_skill == null || _skill.isRanged() || _skill.isIgnoringRiposte() || !_attacker.isAlive())
		{
			return false;
		}

		local actor = this.getContainer().getActor();

		if (_attacker.getTile().getDistanceTo(actor.getTile()) > 1 || ::Tactical.TurnSequenceBar.isActiveEntity(actor) || actor.getCurrentProperties().IsRiposting || !actor.hasZoneOfControl())
		{
			return false;
		}

		if (this.m.BuildsFatigue && !actor.isArmedWithShield() && actor.getFatigueMax() - actor.getFatigue() < this.getContainer().getAttackOfOpportunity().getFatigueCost())
		{
			return false;
		}

		return true;
	}

	function onMissed( _attacker, _skill )
	{
		if (!this.canProc(_attacker, _skill) || ::Math.rand(1, 100) > this.getChance())
		{
			return;
		}

		local info = {
			User = this.getContainer().getActor(),
			Skill = this.getContainer().getAttackOfOpportunity(),
			TargetTile = _attacker.getTile()
		};
		::Time.scheduleEvent(::TimeUnit.Virtual, ::Const.Combat.RiposteDelay, this.onRiposte.bindenv(this), info);
	}

	function getChance()
	{
		return ::Math.max(0, this.m.BaseChance + this.m.__ChanceBonus);
	}

	function onRiposte( _info )
	{
		if (!this.getContainer().getActor().isAlive() || this.m.__RiposteSkillCounter == ::Const.SkillCounter)
		{
			return;
		}

		if (!_info.User.getTile().hasLineOfSightTo(_info.TargetTile, _info.User.getCurrentProperties().getVision()))
		{
			return;
		}

		if (!_info.Skill.verifyTargetAndRange(_info.TargetTile, _info.User.getTile()))
		{
			return;
		}

		this.m.__RiposteSkillCounter = ::Const.SkillCounter;

		if (this.m.BuildsFatigue && !_info.User.checkMorale(0, 0))
		{
			_info.User.setFatigue(::Math.min(_info.User.getFatigueMax(), _info.User.getFatigue() + _info.Skill.getFatigueCost()));
		}

		_info.Skill.useForFree(_info.TargetTile);
	}

});
