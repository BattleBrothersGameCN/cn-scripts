this.rf_polearm_adjacency <- ::inherit("scripts/skills/skill", {
	m = {
		MeleeSkillModifierPerEnemy = -10,
		MeleeSkillModifierPerAlly = 0,
		NumEnemiesToIgnore = 0,
		NumAlliesToIgnore = 0,
		__MeleeSkillModifier = 0
	},
	function create()
	{
		this.m.ID = "special.rf_polearm_adjacency";
		this.m.Name = "难以施展";
		this.m.Description = "长近战武器难以在拥挤环境下使用。使用这类武器时，所有2格或以上攻击距离的攻击技能命中都会因此降低。";
		this.m.Type = ::Const.SkillType.Special;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function softReset()
	{
		this.skill.softReset();

		foreach( k, _ in this.m )
		{
			this.resetField(k);
		}
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.MeleeSkillModifierPerEnemy != 0 && this.m.NumEnemiesToIgnore < 6)
		{
			local numIgnoreString = this.m.NumEnemiesToIgnore == 0 ? "" : "前" + this.m.NumEnemiesToIgnore + "名敌人除外";
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = ::Reforged.Mod.Tooltips.parseString(this.format("每有一名接邻的[触及|Concept.Reach]低于你的敌人，命中率%s，%s", ::MSU.Text.colorizeValue(this.m.MeleeSkillModifierPerEnemy, {
					AddSign = true,
					AddPercent = true
				}), numIgnoreString))
			});
		}

		if (this.m.MeleeSkillModifierPerAlly != 0 && this.m.NumAlliesToIgnore < 6)
		{
			local numIgnoreString = this.m.NumAlliesToIgnore == 0 ? "" : "前" + this.m.NumAlliesToIgnore + "名友军除外";
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = ::Reforged.Mod.Tooltips.parseString(this.format("每有一名接邻盟友，命中率%s，%s", ::MSU.Text.colorizeValue(this.m.MeleeSkillModifierPerAlly, {
					AddSign = true,
					AddPercent = true
				}), numIgnoreString))
			});
		}

		return ret;
	}

	function isEnabledForSkill( _skill )
	{
		return _skill.getMaxRange() > 1 && _skill.isUsingHitchance() && _skill.isAttack() && !_skill.isRanged() && _skill.m.IsWeaponSkill;
	}

	function onBeforeAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		this.m.__MeleeSkillModifier = this.getModifierForSkill(_skill);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		_properties.MeleeSkill += this.m.__MeleeSkillModifier;
	}

	function onAnySkillExecutedFully( _skill, _targetTile, _targetEntity, _forFree )
	{
		this.m.__MeleeSkillModifier = 0;
	}

	function getModifierForSkill( _skill )
	{
		if (!this.isEnabledForSkill(_skill))
		{
			return 0;
		}

		local user = this.getContainer().getActor();

		if (!user.isPlacedOnMap())
		{
			return 0;
		}

		local numAllies = 0;
		local numEnemies = 0;
		local myTile = user.getTile();
		local myReach = user.getCurrentProperties().getReach();

		for( local i = 0; i < 6; i++ )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = myTile.getNextTile(i);

				if (!nextTile.IsOccupiedByActor)
				{
				}
				else if (::Math.abs(myTile.Level - nextTile.Level) > 1)
				{
				}
				else
				{
					local nextEntity = nextTile.getEntity();

					if (nextEntity.isAlliedWith(user))
					{
						numAllies++;
					}
					else if (nextEntity.getCurrentProperties().getReach() < myReach)
					{
						numEnemies++;
					}
				}
			}
		}

		return this.m.MeleeSkillModifierPerAlly * ::Math.max(0, numAllies - this.m.NumAlliesToIgnore) + this.m.MeleeSkillModifierPerEnemy * ::Math.max(0, numEnemies - this.m.NumEnemiesToIgnore);
	}

	function onGetHitFactors( _skill, _targetTile, _tooltip )
	{
		local modifier = this.getModifierForSkill(_skill);

		if (modifier < 0)
		{
			_tooltip.push({
				icon = "ui/tooltips/negative.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(modifier, {
					AddPercent = true
				}) + " " + ::Reforged.NestedTooltips.getNestedSkillName(this))
			});
		}
	}

	function onQueryTooltip( _skill, _tooltip )
	{
		if (this.isEnabledForSkill(_skill))
		{
			_tooltip.push({
				id = 10,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = ::Reforged.Mod.Tooltips.parseString("Can be affected by " + ::Reforged.NestedTooltips.getNestedSkillName(this))
			});
		}
	}

});
