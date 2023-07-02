this.named_steppe_helmet_with_mail <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_steppe_helmet_with_mail";
		this.m.Description = "一个精心制作的头盔，像草原上的人们一样。 用金色装饰，并配备额外的护面。";
		this.m.NameList = [
			"草原头盔",
			"装饰的性鼻头盔",
			"头翼盔",
			"马毛头盔"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 204;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5000;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -12;
		this.m.Vision = -2;
		this.randomizeValues();
	}

});
