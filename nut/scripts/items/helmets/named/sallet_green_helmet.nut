this.sallet_green_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.sallet_green";
		this.m.Description = "这是一个精心制作的带有彩色绶带的链甲头盔。";
		this.m.NameList = [
			"装饰的轻盔",
			"轻质链盔",
			"开敞式轻盔",
			"缎带轻盔"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.Variant = 49;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 7000;
		this.m.Condition = 265;
		this.m.ConditionMax = 265;
		this.m.StaminaModifier = -18;
		this.m.Vision = -1;
		this.randomizeValues();
	}

});
