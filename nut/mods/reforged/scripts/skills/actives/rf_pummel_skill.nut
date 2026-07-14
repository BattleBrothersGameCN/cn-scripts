this.rf_pummel_skill <- ::inherit("scripts/skills/actives/line_breaker", {
	m = {
		RequireTileToKnockBackTo = false
	},
	function create()
	{
		this.line_breaker.create();
		this.m.ID = "actives.rf_pummel";
		this.m.Name = "重锤";
		this.m.Description = "使出一记重击，一次行动中，同时击退目标并占据其位置。";
		this.m.KilledString = "被砸扁";
		this.m.Icon = "skills/rf_pummel_skill.png";
		this.m.IconDisabled = "skills/rf_pummel_skill_sw.png";
		this.m.Overlay = "rf_pummel_skill";
		this.m.SoundOnUse = [
			"sounds/combat/indomitable_01.wav",
			"sounds/combat/indomitable_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/smash_hit_01.wav",
			"sounds/combat/smash_hit_02.wav",
			"sounds/combat/smash_hit_03.wav"
		];
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted;
		this.m.IsWeaponSkill = true;
		this.m.IsUsingHitchance = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.DirectDamageMult = 0.5;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.LineBreaker;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("若攻击成功，使目标[趔趄|Skill+staggered_effect]")
		});
		local line_breaker = ::new("scripts/skills/actives/line_breaker");
		line_breaker.m.Container = this.getContainer();
		ret.extend(line_breaker.getTooltip().slice(3));
		line_breaker.m.Container = null;

		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("被定身时无法使用")
			});
		}

		return ret;
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local tile = this.line_breaker.findTileToKnockBackTo(_userTile, _targetTile);

		if (tile != null)
		{
			return tile;
		}

		return this.m.RequireTileToKnockBackTo ? null : _targetTile;
	}

	function isUsable()
	{
		return this.line_breaker.isUsable() && !this.getContainer().getActor().getCurrentProperties().IsRooted;
	}

	function onAfterUpdate( _properties )
	{
		if (_properties.IsSpecializedInHammers)
		{
			this.m.FatigueCostMult *= ::Const.Combat.WeaponSpecFatigueMult;
		}
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectBash);
		local success = this.attackEntity(_user, _targetTile.getEntity());

		if (success)
		{
			if (target.isAlive() && !target.isNonCombatant())
			{
				local stagger = this.new("scripts/skills/effects/staggered_effect");
				target.getSkills().add(stagger);

				if (_user.isAlive() && !_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				{
					::Tactical.EventLog.log(stagger.getLogEntryOnAdded(::Const.UI.getColorizedEntityName(_user), ::Const.UI.getColorizedEntityName(target)));
				}
			}

			local tag = {
				User = _user,
				TargetTile = _targetTile
			};
			::Time.scheduleEvent(::TimeUnit.Virtual, 1, this.onPummel.bindenv(this), tag);
		}

		return success;
	}

	function onPummel( _tag )
	{
		this.m.RequireTileToKnockBackTo = true;

		if (this.line_breaker.onVerifyTarget(_tag.User.getTile(), _tag.TargetTile))
		{
			this.line_breaker.onUse(_tag.User, _tag.TargetTile);
		}
		else
		{
			::Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, null, null, false);
		}

		this.m.RequireTileToKnockBackTo = false;
	}

});
