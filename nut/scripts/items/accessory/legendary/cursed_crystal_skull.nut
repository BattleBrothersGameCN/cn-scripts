this.cursed_crystal_skull <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.cursed_crystal_skull";
		this.m.Name = "被诅咒的水晶颅骨";
		this.m.Description = "一个可怕的用大型水晶雕刻的头骨。它的表面没有划伤或其他标志。当它靠近人时，冥火会摧毁希望和勇气。";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/ancient_skull.png";
		this.m.Sprite = "";
		this.m.Value = 250;
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
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

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
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "减少任何近战对手的决心 [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color]"
		});
		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "佩戴者永远不会有[color=" + this.Const.UI.Color.NegativeValue + "]自信[/color]士气"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		_properties.Threat += 10;
		local actor = this.getContainer().getActor();
		actor.setMaxMoraleState(this.Const.MoraleState.Steady);

		if (actor.getMoraleState() > this.Const.MoraleState.Steady)
		{
			actor.setMoraleState(this.Const.MoraleState.Steady);
			actor.setDirty(true);
		}
	}

});
