this.rf_trip_artist_effect <- ::inherit("scripts/skills/skill", {
	m = {
		IsSpent = true
	},
	function create()
	{
		this.m.ID = "effects.rf_trip_artist";
		this.m.Name = "陷绊艺术";
		this.m.Description = "该角色是副手持网战斗的大师。";
		this.m.Icon = "ui/perks/perk_rf_trip_artist.png";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
	}

	function isEnabled()
	{
		return this.getContainer().hasSkill("actives.throw_net");
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("每[回合|Concept.Turn]首次近战攻击接邻对手时，若攻击命中，对其施加[趔趄|Skill+staggered_effect]效果")
			});
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("持有武器的[触及距离|Concept.Reach]少于4时，" + ::MSU.Text.colorPositive("获得") + "与4的差值的[触及距离|Concept.Reach]，最多获得4点")
			});
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "需要装备网"
			});
		}
		else if (!this.isEnabled())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("需要装备网")
			});
		}
		else
		{
			if (!this.m.IsSpent || !::Tactical.isActive())
			{
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("下次近战攻击接邻对手时，会在命中后对目标施加[趔趄|Skill+staggered_effect]效果")
				});
			}

			local weapon = this.getContainer().getActor().getMainhandItem();

			if (weapon != null && weapon.getReach() < 4)
			{
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(4 - weapon.getReach(), {
						AddSign = true
					}) + "[触及距离|Concept.Reach]")
				});
			}
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		if (!this.isEnabled())
		{
			return;
		}

		local weapon = this.getContainer().getActor().getMainhandItem();

		if (weapon != null && weapon.getReach() < 4)
		{
			_properties.Reach += 4 - weapon.getReach();
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (this.m.IsSpent || !_skill.isAttack() || _skill.isRanged() || !_targetEntity.isAlive() || !this.isEnabled() || _targetEntity.getTile().getDistanceTo(this.getContainer().getActor().getTile()) > 1)
		{
			return;
		}

		this.m.IsSpent = true;
		_targetEntity.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
		::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "趔趄了" + ::Const.UI.getColorizedEntityName(_targetEntity));
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsSpent = true;
	}

});
