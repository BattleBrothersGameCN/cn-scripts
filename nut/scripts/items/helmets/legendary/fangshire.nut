this.fangshire <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.fangshire";
		this.m.Name = "夏尔之牙";
		this.m.Description = "夏尔之牙是一个北方老虎的头骨，它的两颗凶猛牙齿深深地镶嵌在佩戴者的面孔上，显得阴森恐怖。最初是北方掠袭者野兽比约兰戴着它，在他进行血腥袭击并烧毁海岸线上的许多村庄时，它向敌人的内心灌输了恐惧。当比约兰最终被杀后，夏尔之牙被作为战利品并向南方更远的地方流传。传言称，戴上它的人的眼睛会发出锐利的黄光，让他们能看穿整个黑暗的夜晚。";
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
			text = "允许佩戴者在夜间观看，并抵消任何因夜间造成的惩罚。"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.IsAffectedByNight = false;
	}

});
