this.large_powder_bag <- this.inherit("scripts/items/ammo/ammo", {
	m = {},
	function create()
	{
		this.m.ID = "ammo.powder";
		this.m.Name = "大火药包";
		this.m.Description = "一大包黑火药，用来装填异国火器。如果你有足够的弹药，在每场战斗后自动重新填充。";
		this.m.Icon = "ammo/powder_bag_large.png";
		this.m.IconEmpty = "ammo/powder_bag_large_empty.png";
		this.m.SlotType = this.Const.ItemSlot.Ammo;
		this.m.ItemType = this.Const.Items.ItemType.Ammo;
		this.m.AmmoType = this.Const.Items.AmmoType.Powder;
		this.m.ShowOnCharacter = false;
		this.m.ShowQuiver = false;
		this.m.Value = 400;
		this.m.Ammo = 7;
		this.m.AmmoMax = 7;
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
				text = "含有火药 [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Ammo + "[/color] 发"
			});
		}
		else
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]已用尽，无用的[/color]"
			});
		}

		return result;
	}

});
