this.fangshire <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.fangshire";
		this.m.Name = "夏尔之牙";
		this.m.Description = "夏尔之牙是一头北方老虎的头骨，它的两颗凶猛獠牙深深地镶在穿戴者的脸上，显得阴森恐怖。它的第一任主人是北方掠袭者野兽比约兰，这顶头盔伴随了他在海岸线上的烧杀掳掠，向他的敌人心中灌输着恐惧。比约兰最终被杀后，夏尔之牙作为战利品传向了更远的南方。传言称，穿戴者眼中会发出锐利的黄光，让他们看穿黑夜的最深处。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.IsIndestructible = true;
		this.m.Variant = 24;
		this.updateVariant();
		this.m.ImpactSound = [
			"sounds/enemies/skeleton_hurt_03.wav"
		];
		this.m.Value = 300;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = -5;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "允许穿戴者在夜间视物，抵消一切黑夜惩罚。"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.IsAffectedByNight = false;
	}

});
