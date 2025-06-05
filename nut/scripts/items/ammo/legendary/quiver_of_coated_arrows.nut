this.quiver_of_coated_arrows <- this.inherit("scripts/items/ammo/ammo", {
	m = {
		BleedDamage = 10,
		BleedSounds = [
			"sounds/combat/cleave_hit_hitpoints_01.wav",
			"sounds/combat/cleave_hit_hitpoints_02.wav",
			"sounds/combat/cleave_hit_hitpoints_03.wav"
		]
	},
	function create()
	{
		this.ammo.create();
		this.m.ID = "ammo.arrows";
		this.m.Name = "放血者之触";
		this.m.Description = "这件奇异的箭筒不需要特制的箭，因而可以搭配各种弓使用。其底部藏着某种机关，会从隔舱里释放出某种奇异物质，将箭头浸润，使之能造成特别严重的撕裂伤。反复调查也没能发现涂层来源的明显解释，更找不到完全拆开箭筒以外的提取涂层的方法。弹药充足时，会在战斗后自动补充。";
		this.m.Icon = "ammo/quiver_05.png";
		this.m.IconEmpty = "ammo/quiver_05_empty.png";
		this.m.SlotType = this.Const.ItemSlot.Ammo;
		this.m.ItemType = this.Const.Items.ItemType.Ammo | this.Const.Items.ItemType.Legendary;
		this.m.AmmoType = this.Const.Items.AmmoType.Arrows;
		this.m.ShowOnCharacter = true;
		this.m.ShowQuiver = true;
		this.m.Sprite = "bust_quiver_02";
		this.m.Value = 700;
		this.m.Ammo = 10;
		this.m.AmmoMax = 10;
		this.m.IsDroppedAsLoot = true;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.m.Ammo != 0)
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "装有[color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Ammo + "[/color]支箭"
			});
		}
		else
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]空空如也，毫无用处[/color]"
			});
		}

		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "每回合额外造成[color=" + this.Const.UI.Color.DamageValue + "]" + this.m.BleedDamage + "[/color]点流血伤害，可以叠加，持续2回合"
		});
		return result;
	}

	function onDamageDealt( _target, _skill, _hitInfo )
	{
		if (_skill.getID() != "actives.aimed_shot" && _skill.getID() != "actives.quick_shot")
		{
			return;
		}

		if (!_target.isAlive() || _target.isDying())
		{
			if (this.isKindOf(_target, "lindwurm_tail") || !_target.getCurrentProperties().IsImmuneToBleeding)
			{
				this.Sound.play(this.m.BleedSounds[this.Math.rand(0, this.m.BleedSounds.len() - 1)], this.Const.Sound.Volume.Skill, this.getContainer().getActor().getPos());
			}
		}
		else if (!_target.getCurrentProperties().IsImmuneToBleeding && _hitInfo.DamageInflictedHitpoints >= this.Const.Combat.MinDamageToApplyBleeding)
		{
			local effect = this.new("scripts/skills/effects/bleeding_effect");
			effect.setDamage(this.m.BleedDamage);
			_target.getSkills().add(effect);
			this.Sound.play(this.m.BleedSounds[this.Math.rand(0, this.m.BleedSounds.len() - 1)], this.Const.Sound.Volume.Skill, this.getContainer().getActor().getPos());
		}
	}

});
