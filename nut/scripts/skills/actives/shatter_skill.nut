this.shatter_skill <- this.inherit("scripts/skills/skill", {
	m = {
		TilesUsed = []
	},
	function create()
	{
		this.m.ID = "actives.shatter";
		this.m.Name = "震碎";
		this.m.Description = "大弧度挥动武器，以逆时针顺序攻击三个相邻的格子。被击中的目标可能会被打击的力道击退或者趔趄。除非你想减少薪酬支出，否则注意周围的自己人！";
		this.m.KilledString = "粉碎";
		this.m.Icon = "skills/active_90.png";
		this.m.IconDisabled = "skills/active_90_sw.png";
		this.m.Overlay = "active_90";
		this.m.SoundOnUse = [
			"sounds/combat/shatter_01.wav",
			"sounds/combat/shatter_02.wav",
			"sounds/combat/shatter_03.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/combat/shatter_hit_01.wav",
			"sounds/combat/shatter_hit_02.wav",
			"sounds/combat/shatter_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.HitChanceBonus = -10;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 66;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInHammers)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "有 [color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] 命中惩罚"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "有 [color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] 命中惩罚"
			});
		}

		ret.extend([
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "有 [color=" + this.Const.UI.Color.PositiveValue + "]33%[/color] 几率在命中时造成趔趄"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "有 [color=" + this.Const.UI.Color.PositiveValue + "]33%[/color] 几率在命中时击退目标"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "最多可以击中 3 个目标"
			}
		]);
		return ret;
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		local altdir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		altdir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		return null;
	}

	function applyEffectToTarget( _user, _target, _targetTile )
	{
		local applyEffect = this.Math.rand(1, 3);

		if (applyEffect == 1)
		{
			return;
		}
		else if (applyEffect == 2)
		{
			if (_target.getCurrentProperties().IsImmuneToKnockBackAndGrab || _target.getCurrentProperties().IsRooted)
			{
				return;
			}

			local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

			if (knockToTile == null)
			{
				return;
			}

			this.m.TilesUsed.push(knockToTile.ID);

			if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + "击退了" + this.Const.UI.getColorizedEntityName(_target));
			}

			local skills = _target.getSkills();
			skills.removeByID("effects.shieldwall");
			skills.removeByID("effects.spearwall");
			skills.removeByID("effects.riposte");
			_target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
			local damage = this.Math.max(0, this.Math.abs(knockToTile.Level - _targetTile.Level) - 1) * this.Const.Combat.FallingDamage;

			if (damage == 0)
			{
				this.Tactical.getNavigator().teleport(_target, knockToTile, null, null, true);
			}
			else
			{
				local p = this.getContainer().getActor().getCurrentProperties();
				local tag = {
					Attacker = _user,
					Skill = this,
					HitInfo = clone this.Const.Tactical.HitInfo
				};
				tag.HitInfo.DamageRegular = damage;
				tag.HitInfo.DamageDirect = 1.0;
				tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
				tag.HitInfo.BodyDamageMult = 1.0;
				tag.HitInfo.FatalityChanceMult = 1.0;
				this.Tactical.getNavigator().teleport(_target, knockToTile, this.onKnockedDown, tag, true);
			}
		}
		else
		{
			if (_target.isNonCombatant())
			{
				return;
			}

			_target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + "趔趄了" + this.Const.UI.getColorizedEntityName(_target) + "，持续 1 回合");
			}
		}
	}

	function onKnockedDown( _entity, _tag )
	{
		if (_tag.HitInfo.DamageRegular != 0)
		{
			_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
		}
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInHammers ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.m.TilesUsed = [];
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
		local ret = false;
		local ownTile = _user.getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		ret = this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return ret;
		}

		if (ret && _targetTile.IsOccupiedByActor && _targetTile.getEntity().isAlive() && !_targetTile.getEntity().isDying())
		{
			this.applyEffectToTarget(_user, _targetTile.getEntity(), _targetTile);
		}

		local nextDir = dir - 1 >= 0 ? dir - 1 : this.Const.Direction.COUNT - 1;

		if (ownTile.hasNextTile(nextDir))
		{
			local nextTile = ownTile.getNextTile(nextDir);
			local success = false;

			if (nextTile.IsOccupiedByActor && nextTile.getEntity().isAttackable() && this.Math.abs(nextTile.Level - ownTile.Level) <= 1)
			{
				success = this.attackEntity(_user, nextTile.getEntity());
			}

			if (!_user.isAlive() || _user.isDying())
			{
				return success;
			}

			if (success && nextTile.IsOccupiedByActor && nextTile.getEntity().isAlive() && !nextTile.getEntity().isDying())
			{
				this.applyEffectToTarget(_user, nextTile.getEntity(), nextTile);
			}

			ret = success || ret;
		}

		nextDir = nextDir - 1 >= 0 ? nextDir - 1 : this.Const.Direction.COUNT - 1;

		if (ownTile.hasNextTile(nextDir))
		{
			local nextTile = ownTile.getNextTile(nextDir);
			local success = false;

			if (nextTile.IsOccupiedByActor && nextTile.getEntity().isAttackable() && this.Math.abs(nextTile.Level - ownTile.Level) <= 1)
			{
				success = this.attackEntity(_user, nextTile.getEntity());
			}

			if (!_user.isAlive() || _user.isDying())
			{
				return success;
			}

			if (success && nextTile.IsOccupiedByActor && nextTile.getEntity().isAlive() && !nextTile.getEntity().isDying())
			{
				this.applyEffectToTarget(_user, nextTile.getEntity(), nextTile);
			}

			ret = success || ret;
		}

		this.m.TilesUsed = [];
		return ret;
	}

	function onTargetSelected( _targetTile )
	{
		local ownTile = this.m.Container.getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		local nextDir = dir - 1 >= 0 ? dir - 1 : this.Const.Direction.COUNT - 1;

		if (ownTile.hasNextTile(nextDir))
		{
			local nextTile = ownTile.getNextTile(nextDir);

			if (this.Math.abs(nextTile.Level - ownTile.Level) <= 1)
			{
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);
			}
		}

		nextDir = nextDir - 1 >= 0 ? nextDir - 1 : this.Const.Direction.COUNT - 1;

		if (ownTile.hasNextTile(nextDir))
		{
			local nextTile = ownTile.getNextTile(nextDir);

			if (this.Math.abs(nextTile.Level - ownTile.Level) <= 1)
			{
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInHammers)
			{
				_properties.MeleeSkill -= 10;
			}
			else
			{
				_properties.MeleeSkill -= 5;
			}
		}
	}

});
