this.oathtaker_skull_02_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.oathtaker_skull_02";
		this.m.Name = "小安瑟姆的颅骨和下颌骨";
		this.m.Description = "第一位执誓者，小安瑟姆的颅骨，和一件装有他折断下颌骨的圣骨匣。这件强大遗物的佩戴者必将无往不利，有小安瑟姆的护佑在身，谁又能被打败？";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/oathtaker_skull_02.png";
		this.m.Sprite = "oathtaker_skull_02";
		this.m.Value = 0;
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
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] 决心"
		});
		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/morale.png",
			text = "如果心情允许，将以自信士气开始战斗"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		_properties.Bravery += 10;
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();

		if (actor.getMoodState() >= this.Const.MoodState.Neutral && actor.getMoraleState() < this.Const.MoraleState.Confident)
		{
			actor.setMoraleState(this.Const.MoraleState.Confident);
		}
	}

});
