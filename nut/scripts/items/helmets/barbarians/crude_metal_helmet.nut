this.crude_metal_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.crude_metal_helmet";
		this.m.Name = "粗制金属盔";
		this.m.Description = "尽管制作粗糙，锈迹斑斑，这倒算得上是顶坚固耐用的金属头盔。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			196
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 550;
		this.m.Condition = 145;
		this.m.ConditionMax = 145;
		this.m.StaminaModifier = -11;
		this.m.Vision = -1;
	}

});
