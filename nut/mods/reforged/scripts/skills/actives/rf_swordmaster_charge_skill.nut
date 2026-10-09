this.rf_swordmaster_charge_skill <- ::inherit("scripts/skills/actives/rf_swordmaster_active_abstract", {
	m = {
		IsCharging = false,
		DamageMultBonus = 0.5
	},
	function create()
	{
		this.m.ID = "actives.rf_swordmaster_charge";
		this.m.Name = "巨力冲刺";
		this.m.Description = "释放无当之力！立即冲向对手，迅速缩小距离，实施毁灭打击。";
		this.m.Icon = "skills/rf_swordmaster_charge_skill.png";
		this.m.IconDisabled = "skills/rf_swordmaster_charge_skill_sw.png";
		this.m.Overlay = "rf_swordmaster_charge_skill";
		this.m.SoundOnUse = [
			"sounds/combat/indomitable_01.wav",
			"sounds/combat/indomitable_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/knockback_hit_01.wav",
			"sounds/combat/knockback_hit_02.wav",
			"sounds/combat/knockback_hit_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingActorPitch = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("立即获得[不屈|Skill+indomitable_effect]效果")
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "会移动到目标地格并随机攻击一名接邻敌人，造成的伤害提高" + ::MSU.Text.colorPositive(this.m.DamageMultBonus * 100 + "%") + " more damage"
		});
		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("会[趔趄|Skill+staggered_effect]目标地格周围的所有敌人")
		});
		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "技能范围为" + ::MSU.Text.colorPositive(this.getMaxRange()) + "格"
		});

		if (!this.isEnabled())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("需要装备双手非刺剑剑类武器")
			});
		}

		this.addEnabledTooltip(ret);

		if (this.getContainer().getActor().isEngagedInMelee() || ::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("[陷入近战|Concept.ZoneOfControl]时无法使用"))
			});
		}

		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 22,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("被定身时无法使用"))
			});
		}

		return ret;
	}

	function isEnabled()
	{
		if (!this.rf_swordmaster_active_abstract.isEnabled())
		{
			return false;
		}

		local weapon = this.getContainer().getActor().getMainhandItem();

		if (weapon.isWeaponType(::Const.Items.ItemType.RF_Fencing) || !weapon.isItemType(::Const.Items.ItemType.TwoHanded))
		{
			return false;
		}

		return true;
	}

	function isUsable()
	{
		return this.rf_swordmaster_active_abstract.isUsable() && this.isEnabled() && !this.getContainer().getActor().getCurrentProperties().IsRooted && !this.getContainer().getActor().isEngagedInMelee();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsEmpty)
		{
			return false;
		}

		if (::Math.abs(_targetTile.Level - _originTile.Level) > this.m.MaxLevelDifference)
		{
			return false;
		}

		local myPos = _originTile.Pos;
		local targetPos = _targetTile.Pos;
		local distance = _originTile.getDistanceTo(_targetTile);
		local Dx = (targetPos.X - myPos.X) / distance;
		local Dy = (targetPos.Y - myPos.Y) / distance;

		for( local i = 0; i < distance; i = i )
		{
			local x = myPos.X + Dx * i;
			local y = myPos.Y + Dy * i;
			local tileCoords = ::Tactical.worldToTile(this.createVec(x, y));
			local tile = ::Tactical.getTile(tileCoords);

			if (!tile.IsOccupiedByActor && !tile.IsEmpty)
			{
				return false;
			}

			if (tile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()) || ::Math.abs(tile.Level - _originTile.Level) > 1)
			{
				return false;
			}

			i = ++i;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		_user.getSkills().add(::new("scripts/skills/effects/indomitable_effect"));
		local tag = {
			Skill = this,
			User = _user,
			OldTile = _user.getTile(),
			TargetTile = _targetTile,
			OnRepelled = this.onRepelled
		};

		if (tag.OldTile.IsVisibleForPlayer || _targetTile.IsVisibleForPlayer)
		{
			local myPos = _user.getPos();
			local targetPos = _targetTile.Pos;
			local distance = tag.OldTile.getDistanceTo(_targetTile);
			local Dx = (targetPos.X - myPos.X) / distance;
			local Dy = (targetPos.Y - myPos.Y) / distance;

			for( local i = 0; i < distance; i = i )
			{
				local x = myPos.X + Dx * i;
				local y = myPos.Y + Dy * i;
				local tile = ::Tactical.worldToTile(this.createVec(x, y));

				if (::Tactical.isValidTile(tile.X, tile.Y) && ::Const.Tactical.DustParticles.len() != 0)
				{
					for( local i = 0; i < ::Const.Tactical.DustParticles.len(); i = i )
					{
						::Tactical.spawnParticleEffect(false, ::Const.Tactical.DustParticles[i].Brushes, ::Tactical.getTile(tile), ::Const.Tactical.DustParticles[i].Delay, ::Const.Tactical.DustParticles[i].Quantity * 0.5, ::Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, ::Const.Tactical.DustParticles[i].SpawnRate, ::Const.Tactical.DustParticles[i].Stages);
						i = ++i;
					}
				}

				i = ++i;
			}
		}

		::Tactical.getNavigator().teleport(_user, _targetTile, this.onTeleportDone, tag, false, 2.0);
		return true;
	}

	function onRepelled( _tag )
	{
		::Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, null, null, false);
	}

	function onTeleportDone( _entity, _tag )
	{
		local attack = _entity.getSkills().getAttackOfOpportunity();
		local myTile = _entity.getTile();
		local ZOC = [];
		local dirToTarget = _tag.OldTile.getDirectionTo(myTile);

		if (attack != null)
		{
			for( local i = 0; i < 6; i = i )
			{
				if (myTile.hasNextTile(i))
				{
					local tile = myTile.getNextTile(i);

					if (tile.IsOccupiedByActor && attack.verifyTargetAndRange(tile, myTile))
					{
						local actor = tile.getEntity();

						if (!actor.isAlliedWith(_entity))
						{
							ZOC.push(actor);
						}
					}
				}

				i = ++i;
			}
		}

		foreach( actor in ZOC )
		{
			if (!actor.onMovementInZoneOfControl(_entity, true))
			{
				continue;
			}

			if (actor.onAttackOfOpportunity(_entity, true))
			{
				if (_tag.OldTile.IsVisibleForPlayer || myTile.IsVisibleForPlayer)
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_entity) + "发起冲锋但被逼退了");
				}

				if (!_entity.isAlive() || _entity.isDying())
				{
					return;
				}

				local dir = myTile.getDirectionTo(_tag.OldTile);

				if (myTile.hasNextTile(dir))
				{
					local tile = myTile.getNextTile(dir);

					if (tile.IsEmpty && ::Math.abs(tile.Level - myTile.Level) <= 1 && tile.getDistanceTo(actor.getTile()) > 1)
					{
						_tag.TargetTile = tile;
						::Time.scheduleEvent(::TimeUnit.Virtual, 50, _tag.OnRepelled, _tag);
						return;
					}
				}

				for( local i = 0; i != 6; i = i )
				{
					if (myTile.hasNextTile(i))
					{
						local tile = myTile.getNextTile(i);

						if (tile.IsEmpty && ::Math.abs(tile.Level - myTile.Level) <= 1)
						{
							if (tile.getZoneOfControlCountOtherThan(_entity.getAlliedFactions()) == 0)
							{
								_tag.TargetTile = tile;
								::Time.scheduleEvent(::TimeUnit.Virtual, 50, _tag.OnRepelled, _tag);
								return;
							}
						}
					}

					i = ++i;
				}

				_tag.TargetTile = _tag.OldTile;
				::Time.scheduleEvent(::TimeUnit.Virtual, 50, _tag.OnRepelled, _tag);
				return;
			}
		}

		if (ZOC.len() != 0)
		{
			local victim = ::MSU.Array.rand(ZOC);

			if (_tag.Skill.m.SoundOnHit.len() != 0)
			{
				::Sound.play(_tag.Skill.m.SoundOnHit[::Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], ::Const.Sound.Volume.Skill, victim.getPos());
			}

			foreach( enemy in ZOC )
			{
				if (!enemy.isHiddenToPlayer())
				{
					local layers = ::Const.ShakeCharacterLayers[::Const.BodyPart.Body];
					::Tactical.getShaker().shake(enemy, myTile, 2);
				}

				enemy.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
			}

			if (_tag.OldTile.IsVisibleForPlayer || myTile.IsVisibleForPlayer)
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_entity) + "冲锋并攻击力" + ::Const.UI.getColorizedEntityName(victim) + "并趔趄了相邻的目标");
			}

			_tag.Skill.m.IsCharging = true;
			attack.useForFree(victim.getTile());
			_tag.Skill.m.IsCharging = false;
			return;
		}

		if (_tag.OldTile.IsVisibleForPlayer || myTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_entity) + "发起了冲锋");
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.m.IsCharging)
		{
			_properties.DamageTotalMult *= 1.0 + this.m.DamageMultBonus;
		}
	}

	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (this.m.IsCharging)
		{
			this.m.IsCharging = false;
		}
	}

});
