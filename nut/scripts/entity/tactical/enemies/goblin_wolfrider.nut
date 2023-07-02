this.goblin_wolfrider <- this.inherit("scripts/entity/tactical/goblin", {
	m = {
		Variant = 1,
		LastBodyPartHit = this.Const.BodyPart.Body,
		Info = null
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.GoblinWolfrider;
		this.m.XP = this.Const.Tactical.Actor.GoblinWolfrider.XP;
		this.goblin.create();
		this.m.ShakeLayers = [
			[
				"wolf",
				"wolf_head",
				"wolf_injury"
			],
			[
				"body",
				"head",
				"injury",
				"helmet",
				"helmet_damage"
			]
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/wolf_hurt_00.wav",
			"sounds/enemies/wolf_hurt_01.wav",
			"sounds/enemies/wolf_hurt_02.wav",
			"sounds/enemies/wolf_hurt_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other2] = [
			"sounds/enemies/wolf_death_00.wav",
			"sounds/enemies/wolf_death_01.wav",
			"sounds/enemies/wolf_death_02.wav",
			"sounds/enemies/wolf_death_03.wav",
			"sounds/enemies/wolf_death_04.wav",
			"sounds/enemies/wolf_death_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/wolf_idle_00.wav",
			"sounds/enemies/wolf_idle_01.wav",
			"sounds/enemies/wolf_idle_02.wav",
			"sounds/enemies/wolf_idle_03.wav",
			"sounds/enemies/wolf_idle_04.wav",
			"sounds/enemies/wolf_idle_06.wav",
			"sounds/enemies/wolf_idle_07.wav",
			"sounds/enemies/wolf_idle_08.wav",
			"sounds/enemies/wolf_idle_09.wav"
		];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 0.600000;
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = [
			"sounds/enemies/goblin_wolfrider_move_00.wav",
			"sounds/enemies/goblin_wolfrider_move_01.wav",
			"sounds/enemies/goblin_wolfrider_move_02.wav",
			"sounds/enemies/goblin_wolfrider_move_03.wav",
			"sounds/enemies/goblin_wolfrider_move_04.wav",
			"sounds/enemies/goblin_wolfrider_move_05.wav",
			"sounds/enemies/goblin_wolfrider_move_06.wav",
			"sounds/enemies/goblin_wolfrider_move_07.wav",
			"sounds/enemies/goblin_wolfrider_move_08.wav",
			"sounds/enemies/goblin_wolfrider_move_09.wav",
			"sounds/enemies/goblin_wolfrider_move_10.wav",
			"sounds/enemies/goblin_wolfrider_move_11.wav",
			"sounds/enemies/goblin_wolfrider_move_12.wav",
			"sounds/enemies/goblin_wolfrider_move_13.wav"
		];
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/goblin_wolfrider_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.goblin.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.GoblinWolfrider);
		b.AdditionalActionPointCost = 1;
		b.DamageDirectMult = 1.250000;
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInSpears = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.getSprite("head").setBrush("bust_goblin_01_head_0" + this.Math.rand(1, 3));
		this.setAlwaysApplySpriteOffset(true);
		local offset = this.createVec(8, 14);
		this.setSpriteOffset("body", offset);
		this.setSpriteOffset("armor", offset);
		this.setSpriteOffset("head", offset);
		this.setSpriteOffset("injury", offset);
		this.setSpriteOffset("helmet", offset);
		this.setSpriteOffset("helmet_damage", offset);
		this.setSpriteOffset("body_blood", offset);
		local variant = this.Math.rand(1, 2);
		local wolf = this.addSprite("wolf");
		wolf.setBrush("bust_wolf_0" + variant + "_body");
		wolf.varySaturation(0.150000);
		wolf.varyColor(0.070000, 0.070000, 0.070000);
		local wolf = this.addSprite("wolf_head");
		wolf.setBrush("bust_wolf_0" + variant + "_head");
		wolf.Saturation = wolf.Saturation;
		wolf.Color = wolf.Color;
		this.removeSprite("injury_body");
		local wolf_injury = this.addSprite("injury_body");
		wolf_injury.setBrush("bust_wolf_01_injured");
		wolf_injury.Visible = false;
		local wolf_armor = this.addSprite("wolf_armor");
		wolf_armor.setBrush("bust_wolf_02_armor_01");
		offset = this.createVec(0, -20);
		this.setSpriteOffset("wolf", offset);
		this.setSpriteOffset("wolf_head", offset);
		this.setSpriteOffset("wolf_armor", offset);
		this.setSpriteOffset("injury_body", offset);
		this.addDefaultStatusSprites();
		this.setSpriteOffset("arms_icon", this.createVec(15, 15));
		this.getSprite("arms_icon").Rotation = 13.000000;
		local wolf_bite = this.new("scripts/skills/actives/wolf_bite");
		wolf_bite.setRestrained(true);
		wolf_bite.m.ActionPointCost = 0;
		this.m.Skills.add(wolf_bite);
		this.m.Skills.add(this.new("scripts/skills/perks/perk_backstabber"));
	}

	function onAfterInit()
	{
		this.getSprite("status_rooted").Scale = 0.570000;
		this.setSpriteOffset("status_rooted", this.createVec(-2, -3));
		this.actor.onAfterInit();
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		this.m.LastBodyPartHit = _hitInfo.BodyPart;
		this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.m.Info = {
			Tile = this.getTile(),
			Faction = this.getFaction(),
			Body = this.getSprite("body").getBrush().Name,
			Head = this.getSprite("head").getBrush().Name,
			Color = this.getSprite("body").Color,
			Saturation = this.getSprite("body").Saturation,
			WolfColor = this.getSprite("wolf").Color,
			WolfSaturation = this.getSprite("wolf").Saturation,
			Morale = this.Math.max(this.Const.MoraleState.Breaking, this.getMoraleState())
		};

		if (this.m.LastBodyPartHit == this.Const.BodyPart.Body)
		{
			this.spawnDeadWolf(_killer, _skill, _tile, _fatalityType);
		}
		else
		{
			this.goblin.onDeath(_killer, _skill, _tile, _fatalityType);
		}
	}

	function onAfterDeath( _tile )
	{
		if (this.Tactical.Entities.getHostilesNum() == 0)
		{
			return;
		}

		if (!this.m.Info.Tile.IsEmpty)
		{
			local changed = false;

			for( local i = 0; i != 6; i = ++i )
			{
				if (!this.m.Info.Tile.hasNextTile(i))
				{
				}
				else
				{
					local tile = this.m.Info.Tile.getNextTile(i);

					if (tile.IsEmpty && this.Math.abs(tile.Level - this.m.Info.Tile.Level) <= 1)
					{
						this.m.Info.Tile = tile;
						changed = true;
						break;
					}
				}
			}

			if (!changed)
			{
				return;
			}
		}

		if (this.m.LastBodyPartHit == this.Const.BodyPart.Body)
		{
			this.spawnGoblin(this.m.Info);
		}
		else
		{
			this.spawnWolf(this.m.Info);
		}
	}

	function spawnDeadWolf( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile == null)
		{
			return;
		}

		local flip = this.Math.rand(0, 100) < 50;
		local decal;
		this.m.IsCorpseFlipped = flip;
		decal = _tile.spawnDetail(this.getSprite("wolf").getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
		decal.setBrightness(0.900000);
		decal.Scale = 0.950000;
		decal = _tile.spawnDetail("bust_wolf_02_armor_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
		decal.setBrightness(0.900000);
		decal.Scale = 0.950000;

		if (_fatalityType != this.Const.FatalityType.Decapitated)
		{
			decal = _tile.spawnDetail(this.getSprite("wolf_head").getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.setBrightness(0.900000);
			decal.Scale = 0.950000;
		}
		else if (_fatalityType == this.Const.FatalityType.Decapitated)
		{
			local layers = [
				this.getSprite("wolf_head").getBrush().Name + "_dead"
			];
			local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-20, 15), 0.000000, "bust_wolf_head_bloodpool");
			decap[0].setBrightness(0.900000);
			decap[0].Scale = 0.950000;
		}
		else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
		{
			decal = _tile.spawnDetail(this.getSprite("wolf").getBrush().Name + "_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Scale = 0.950000;
		}
		else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
		{
			decal = _tile.spawnDetail(this.getSprite("wolf").getBrush().Name + "_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Scale = 0.950000;
		}

		this.spawnTerrainDropdownEffect(_tile);
		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = "一只狼";
		corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
		corpse.IsResurrectable = false;
		_tile.Properties.set("Corpse", corpse);
		this.Tactical.Entities.addCorpse(_tile);
	}

	function spawnWolf( _info )
	{
		this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived].len() - 1)], this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1], _info.Tile.Pos, 1.000000);
		local entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/wolf", _info.Tile.Coords.X, _info.Tile.Coords.Y);

		if (entity != null)
		{
			entity.setVariant(this.m.Variant, _info.WolfColor, _info.WolfSaturation, 0.450000);
			entity.setFaction(_info.Faction);
			entity.setMoraleState(_info.Morale);
		}
	}

	function spawnGoblin( _info )
	{
		this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Other1][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Other1].len() - 1)], this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1], _info.Tile.Pos, 1.000000);
		local entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/goblin_fighter", _info.Tile.Coords.X, _info.Tile.Coords.Y);

		if (entity != null)
		{
			local newBody = entity.getSprite("body");
			newBody.setBrush(_info.Body);
			newBody.Color = _info.Color;
			newBody.Saturation = _info.Saturation;
			local newHead = entity.getSprite("head");
			newHead.setBrush(_info.Head);
			newHead.Color = _info.Color;
			newHead.Saturation = _info.Saturation;
			entity.setFaction(_info.Faction);
			entity.getItems().clear();
			this.m.Items.transferTo(entity.getItems());
			entity.setMoraleState(_info.Morale);
			entity.setHitpoints(entity.getHitpointsMax() * 0.450000);
			entity.onUpdateInjuryLayer();
		}
	}

	function playSound( _type, _volume, _pitch = 1.000000 )
	{
		if (_type == this.Const.Sound.ActorEvent.DamageReceived && this.m.LastBodyPartHit == this.Const.BodyPart.Body)
		{
			_type = this.Const.Sound.ActorEvent.Other1;
		}
		else if (_type == this.Const.Sound.ActorEvent.Death && this.m.LastBodyPartHit == this.Const.BodyPart.Body)
		{
			_type = this.Const.Sound.ActorEvent.Other2;
			this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 0.700000;
		}

		this.actor.playSound(_type, _volume, _pitch);
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 1.000000;
	}

	function assignRandomEquipment()
	{
		local r;
		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_spear"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_falchion"));
		}

		if (this.Math.rand(1, 100) <= 75)
		{
			this.m.Items.equip(this.new("scripts/items/armor/greenskins/goblin_medium_armor"));
		}
		else
		{
			this.m.Items.equip(this.new("scripts/items/armor/greenskins/goblin_heavy_armor"));
		}

		if (this.Math.rand(1, 100) <= 75)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/greenskins/goblin_light_helmet"));
		}
		else
		{
			this.m.Items.equip(this.new("scripts/items/helmets/greenskins/goblin_heavy_helmet"));
		}
	}

});
