this.rf_net_pull_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rf_net_pull";
		this.m.Name = "拖网";
		this.m.Description = "用你的网将目标拉近并将其套住。";
		this.m.Icon = "skills/rf_net_pull_skill.png";
		this.m.IconDisabled = "skills/rf_net_pull_skill_sw.png";
		this.m.Overlay = "rf_net_pull_skill";
		this.m.SoundOnUse = [
			"sounds/combat/hook_01.wav",
			"sounds/combat/hook_02.wav",
			"sounds/combat/hook_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/hook_hit_01.wav",
			"sounds/combat/hook_hit_02.wav",
			"sounds/combat/hook_hit_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsAttack = true;
		this.m.IsOffensiveToolSkill = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.MinRange = 2;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 1;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.KnockBack;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "技能范围为" + ::MSU.Text.colorPositive(this.getMaxRange()) + "格"
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("有" + ::MSU.Text.colorPositive("100%") + "概率使对手[趔趄|Skill+staggered_effect]并[被困网中|Skill+net_effect]")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("目标会失去[盾墙、|Skill+shieldwall_effect][矛墙|Skill+spearwall_effect]和[还击|Skill+riposte_effect]效果")
		});
		ret.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "将消耗手中的网"
		});
		return ret;
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		return this.getPulledToTile(_userTile, _targetTile);
	}

	function getPulledToTile( _userTile, _targetTile )
	{
		local dir = _targetTile.getDirectionTo(_userTile);

		if (_targetTile.hasNextTile(dir))
		{
			local tile = _targetTile.getNextTile(dir);

			if (tile.Level <= _userTile.Level && tile.IsEmpty)
			{
				return tile;
			}
		}

		dir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_targetTile.hasNextTile(dir))
		{
			local tile = _targetTile.getNextTile(dir);

			if (tile.getDistanceTo(_userTile) == 1 && tile.Level <= _userTile.Level && tile.IsEmpty)
			{
				return tile;
			}
		}

		dir = _targetTile.getDirectionTo(_userTile);
		dir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_targetTile.hasNextTile(dir))
		{
			local tile = _targetTile.getNextTile(dir);

			if (tile.getDistanceTo(_userTile) == 1 && tile.Level <= _userTile.Level && tile.IsEmpty)
			{
				return tile;
			}
		}

		return null;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local targetProperties = _targetTile.getEntity().getCurrentProperties();
		return !targetProperties.IsRooted && !targetProperties.IsImmuneToKnockBackAndGrab && !targetProperties.IsImmuneToRoot && this.getPulledToTile(_originTile, _targetTile) != null;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local pullToTile = this.getPulledToTile(_user.getTile(), _targetTile);

		if (pullToTile == null || target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			return false;
		}

		if (!_user.isHiddenToPlayer() && pullToTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " pulls and nets " + ::Const.UI.getColorizedEntityName(_targetTile.getEntity()));
		}

		local skills = _targetTile.getEntity().getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");

		if (this.m.SoundOnHit.len() != 0)
		{
			::Sound.play(this.m.SoundOnHit[::Math.rand(0, this.m.SoundOnHit.len() - 1)], ::Const.Sound.Volume.Skill, _user.getPos());
		}

		::Tactical.State.handleInvoluntaryMovement(target, _user, _targetTile, pullToTile, this, this.onPulledDown, this.onHookingComplete);
		return true;
	}

	function onPulledDown( _entity, _tag )
	{
		_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);

		if (_entity.isAlive())
		{
			_tag.Attacker.getSkills().getSkillByID("actives.throw_net").useForFree(_tag.TargetTile);
			_entity.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
		}
	}

	function onHookingComplete( _entity, _tag )
	{
		_tag.Attacker.getSkills().getSkillByID("actives.throw_net").useForFree(_tag.TargetTile);
		_entity.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
		_tag.Attacker.setDirty(true);
	}

});
