this.berserker_mushrooms_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Item = null
	},
	function setItem( _i )
	{
		this.m.Item = this.WeakTableRef(_i);
	}

	function create()
	{
		this.m.ID = "actives.berserker_mushrooms";
		this.m.Name = "吃下或给出怪异蘑菇";
		this.m.Description = "吃下怪异蘑菇或递给接邻盟友。吃下会让人进入一种不顾自身安危的迷幻愤怒状态。可能导致疾病。效果会用4回合慢慢消退。陷入近战后无法使用，接受物品的人需要有一个空的背包栏位。";
		this.m.Icon = "skills/active_98.png";
		this.m.IconDisabled = "skills/active_98_sw.png";
		this.m.Overlay = "active_98";
		this.m.SoundOnUse = [
			"sounds/combat/eat_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = true;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 5;
		this.m.MinRange = 0;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "赋予[color=" + this.Const.UI.Color.PositiveValue + "]+40%[/color]近战伤害"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "赋予[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color]近战防御"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "赋予[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color]远程防御"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "失去生命值时不会触发士气检查"
			}
		];

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]角色陷入近战，无法使用[/color]"
			});
		}

		return ret;
	}

	function getCursorForTile( _tile )
	{
		if (_tile.ID == this.getContainer().getActor().getTile().ID)
		{
			return this.Const.UI.Cursor.Drink;
		}
		else
		{
			return this.Const.UI.Cursor.Give;
		}
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (!this.m.Container.getActor().isAlliedWith(target))
		{
			return false;
		}

		if (target.getID() != _originTile.getEntity().getID() && !target.getItems().hasEmptySlot(this.Const.ItemSlot.Bag))
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local user = _targetTile.getEntity();

		if (_user.getID() == user.getID())
		{
			local shrooms = user.getSkills().getSkillByID("effects.berserker_mushrooms");

			if (shrooms != null)
			{
				shrooms.reset();
			}
			else
			{
				user.getSkills().add(this.new("scripts/skills/effects/berserker_mushrooms_effect"));
			}

			if (!_user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " 吃了怪异蘑菇");
			}

			if (this.m.Item != null && !this.m.Item.isNull())
			{
				this.m.Item.removeSelf();
			}

			this.Const.Tactical.Common.checkDrugEffect(user);
		}
		else
		{
			if (!_user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " 把怪异蘑菇递给了" + this.Const.UI.getColorizedEntityName(user));
			}

			this.spawnIcon("status_effect_67", _targetTile);
			this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
			local item = this.m.Item.get();
			_user.getItems().removeFromBag(item);
			user.getItems().addToBag(item);
		}

		return true;
	}

});
