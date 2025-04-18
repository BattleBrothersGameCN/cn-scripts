this.censer_castigate_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.censer_castigate";
		this.m.Name = "惩戒";
		this.m.Description = "这是一记横扫，以逆时针方向划过一段距离，击中三个相邻的格子，并在其路径上留下有害的瘴气。除非你想削减自己的兵力开支，否则在你自己的士兵周围要格外小心！";
		this.m.Icon = "skills/active_231.png";
		this.m.IconDisabled = "skills/active_231_sw.png";
		this.m.Overlay = "active_231";
		this.m.SoundOnUse = [
			"sounds/combat/pound_01.wav",
			"sounds/combat/pound_02.wav",
			"sounds/combat/pound_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/pound_hit_01.wav",
			"sounds/combat/pound_hit_02.wav",
			"sounds/combat/pound_hit_03.wav"
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
		this.m.IsTooCloseShown = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 66;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "最多可以击中3个目标"
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "攻击范围为 [color=" + this.Const.UI.Color.PositiveValue + "]2" + "[/color] 格远"
		});

		if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "武器施展不便，对近身敌人有 [color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] 命中惩罚"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "无视由盾牌提供的近战防御加成。"
			});
		}

		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "在目标区域留下一片瘴气之云。"
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInFlails ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			if (_targetEntity != null && !this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) == 1)
			{
				_properties.MeleeSkill += -15;
				this.m.HitChanceBonus = -15;
			}
			else
			{
				this.m.HitChanceBonus = 0;
			}
		}
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
		local ret = false;
		local myTile = _user.getTile();
		local myTile = this.m.Container.getActor().getTile();
		local d = myTile.getDistanceTo(_targetTile);
		local result = {
			Tiles = [],
			MyTile = myTile,
			TargetTile = _targetTile,
			Num = 0
		};
		this.Tactical.queryTilesInRange(myTile, d, d, false, [], this.onQueryTilesHit, result);
		local tiles = [];

		for( local i = 0; i != result.Tiles.len(); i = ++i )
		{
			if (result.Tiles[i].ID == _targetTile.ID)
			{
				tiles.push(result.Tiles[i]);
				local idx = i - 1;

				if (idx < 0)
				{
					idx = idx + result.Tiles.len();
				}

				tiles.push(result.Tiles[idx]);
				idx = i - 2;

				if (idx < 0)
				{
					idx = idx + result.Tiles.len();
				}

				tiles.push(result.Tiles[idx]);
				break;
			}
		}

		foreach( tile in tiles )
		{
			if (!tile.IsVisibleForEntity)
			{
				continue;
			}

			if (this.Math.abs(tile.Level - myTile.Level) > 1 || this.Math.abs(tile.Level - _targetTile.Level) > 1)
			{
				continue;
			}

			if (!tile.IsEmpty && tile.getEntity().isAttackable())
			{
				ret = this.attackEntity(_user, tile.getEntity()) || ret;
			}

			local miasma_effect = {
				Type = "miasma",
				Tooltip = "此处瘴气弥漫，对一切生灵皆有害。",
				IsPositive = false,
				IsAppliedAtRoundStart = false,
				IsAppliedAtTurnEnd = true,
				IsAppliedOnMovement = false,
				IsAppliedOnEnter = false,
				IsByPlayer = false,
				Timeout = this.Time.getRound() + 3,
				Callback = this.Const.Tactical.Common.onApplyMiasma,
				function Applicable( _a )
				{
					return !_a.getFlags().has("undead");
				}

			};

			if (tile.Properties.Effect != null && tile.Properties.Effect.Type == "miasma")
			{
				tile.Properties.Effect.Timeout = this.Time.getRound() + 3;
			}
			else
			{
				if (tile.Properties.Effect != null)
				{
					this.Tactical.Entities.removeTileEffect(tile);
				}

				tile.Properties.Effect = clone miasma_effect;
				local particles = [];

				for( local i = 0; i < this.Const.Tactical.MiasmaParticles.len(); i = ++i )
				{
					particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.MiasmaParticles[i].Brushes, tile, this.Const.Tactical.MiasmaParticles[i].Delay, this.Const.Tactical.MiasmaParticles[i].Quantity, this.Const.Tactical.MiasmaParticles[i].LifeTimeQuantity, this.Const.Tactical.MiasmaParticles[i].SpawnRate, this.Const.Tactical.MiasmaParticles[i].Stages));
				}

				this.Tactical.Entities.addTileEffect(tile, tile.Properties.Effect, particles);
			}

			if (!_user.isAlive() || _user.isDying())
			{
				break;
			}
		}

		return ret;
	}

	function onQueryTilesHit( _tile, _result )
	{
		_result.Tiles.push(_tile);
	}

	function onTargetSelected( _targetTile )
	{
		local myTile = this.m.Container.getActor().getTile();
		local d = myTile.getDistanceTo(_targetTile);
		local result = {
			Tiles = [],
			MyTile = myTile,
			TargetTile = _targetTile,
			Num = 0
		};
		this.Tactical.queryTilesInRange(myTile, d, d, false, [], this.onQueryTilesHit, result);
		local tiles = [];

		for( local i = 0; i != result.Tiles.len(); i = ++i )
		{
			if (result.Tiles[i].ID == _targetTile.ID)
			{
				tiles.push(result.Tiles[i]);
				local idx = i - 1;

				if (idx < 0)
				{
					idx = idx + result.Tiles.len();
				}

				tiles.push(result.Tiles[idx]);
				idx = i - 2;

				if (idx < 0)
				{
					idx = idx + result.Tiles.len();
				}

				tiles.push(result.Tiles[idx]);
				break;
			}
		}

		foreach( t in tiles )
		{
			if (!t.IsVisibleForEntity)
			{
				continue;
			}

			if (this.Math.abs(t.Level - myTile.Level) > 1 || this.Math.abs(t.Level - _targetTile.Level) > 1)
			{
				continue;
			}

			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
		}
	}

});
