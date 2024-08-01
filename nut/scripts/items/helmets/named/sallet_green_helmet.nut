this.sallet_green_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.sallet_green";
		this.m.Description = "一顶上饰彩色缎带，下有链甲头肩巾的精造轻盔。";
		this.m.NameList = [
			"装饰轻盔",
			"衬链轻盔",
			"开面轻盔",
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
