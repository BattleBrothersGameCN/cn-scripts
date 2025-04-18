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
		this.m.Name = "血刃者之径";
		this.m.Description = "这个奇异的箭筒内装有普通的箭矢，适用于各类弓弩。其底部隐藏着一套机制，能够从秘密储存处释放出一种奇特物质，将箭头包裹起来，使箭矢在命中时造成特别严重的撕裂伤。经过调查，人们发现这种涂层的来源无从解释，而且若不彻底拆解箭筒，便无法提取这种物质。若你备有足够的箭矢，每场战斗后，箭筒都会自动重新填满。";
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
				text = "装有[color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Ammo + "箭头"
			});
		}
		else
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]是空洞且无用的[/color]"
			});
		}

		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "每回合额外造成可叠加的[color=" + this.Const.UI.Color.DamageValue + "]" + this.m.BleedDamage + "[/color] 流血伤害，持续2回合"
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
