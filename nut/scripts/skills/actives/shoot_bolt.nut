this.shoot_bolt <- this.inherit("scripts/skills/skill", {
	m = {
		AdditionalAccuracy = 0,
		AdditionalHitChance = 0
	},
	function onItemSet()
	{
		this.m.MaxRange = this.m.Item.getRangeMax();
	}

	function create()
	{
		this.m.ID = "actives.shoot_bolt";
		this.m.Name = "发射弩矢";
		this.m.Description = "快速拉动扳机以发射弩矢。每次射击后必须重新装填才能再次射击。";
		this.m.KilledString = "射杀";
		this.m.Icon = "skills/active_17.png";
		this.m.IconDisabled = "skills/active_17_sw.png";
		this.m.Overlay = "active_17";
		this.m.SoundOnUse = [
			"sounds/combat/bolt_shot_01.wav",
			"sounds/combat/bolt_shot_02.wav",
			"sounds/combat/bolt_shot_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/bolt_shot_hit_01.wav",
			"sounds/combat/bolt_shot_hit_02.wav",
			"sounds/combat/bolt_shot_hit_03.wav"
		];
		this.m.SoundOnHitShield = [
			"sounds/combat/shield_hit_arrow_01.wav",
			"sounds/combat/shield_hit_arrow_02.wav",
			"sounds/combat/shield_hit_arrow_03.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/combat/bolt_shot_miss_01.wav",
			"sounds/combat/bolt_shot_miss_02.wav",
			"sounds/combat/bolt_shot_miss_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 100;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsWeaponSkill = true;
		this.m.IsDoingForwardMove = false;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.450000;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 4;
		this.m.ProjectileType = this.Const.ProjectileType.Arrow;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "攻击范围为 [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] 格(在平坦地面上), 如果向低处射击会更远。"
			}
		]);

		if (15 + this.m.AdditionalAccuracy >= 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "有 [color=" + this.Const.UI.Color.PositiveValue + "]+" + (15 + this.m.AdditionalAccuracy) + "%[/color] 额外命中，同时每格距离有 [color=" + this.Const.UI.Color.NegativeValue + "]" + (-3 + this.m.AdditionalHitChance) + "%[/color] 命中惩罚"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "有 [color=" + this.Const.UI.Color.NegativeValue + "]" + (15 + this.m.AdditionalAccuracy) + "%[/color] 额外命中，同时每格距离有 [color=" + this.Const.UI.Color.NegativeValue + "]" + (-3 + this.m.AdditionalHitChance) + "%[/color] 命中惩罚"
			});
		}

		local ammo = this.getAmmo();

		if (ammo > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "有 [color=" + this.Const.UI.Color.PositiveValue + "]" + ammo + "[/color] 弩矢剩余"
			});
		}
		else
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]需要装备非空弩失袋[/color]"
			});
		}

		if (!this.getItem().isLoaded())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]必须重新装填才能再次发射[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.getItem().isLoaded();
	}

	function getAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);

		if (item == null)
		{
			return 0;
		}

		if (item.getAmmoType() == this.Const.Items.AmmoType.Bolts)
		{
			return item.getAmmo();
		}
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInCrossbows ? this.Const.Combat.WeaponSpecFatigueMult : 1.000000;
		this.m.DirectDamageMult = _properties.IsSpecializedInCrossbows ? 0.700000 : 0.500000;
		this.m.AdditionalAccuracy = this.m.Item.getAdditionalAccuracy();
	}

	function onUse( _user, _targetTile )
	{
		local ret = this.attackEntity(_user, _targetTile.getEntity());
		this.getItem().setLoaded(false);
		local skillToAdd = this.new("scripts/skills/actives/reload_bolt");
		skillToAdd.setItem(this.getItem());
		skillToAdd.setFatigueCost(this.Math.max(0, skillToAdd.getFatigueCostRaw() + this.getItem().m.FatigueOnSkillUse));
		this.getContainer().add(skillToAdd);
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += 15 + this.m.AdditionalAccuracy;
			_properties.HitChanceAdditionalWithEachTile -= 3 + this.m.AdditionalHitChance;

			if (_properties.IsSharpshooter)
			{
				_properties.DamageDirectMult += 0.050000;
			}
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.reload_bolt");
	}

});
