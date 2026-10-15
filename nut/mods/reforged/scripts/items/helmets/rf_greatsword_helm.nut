this.rf_greatsword_helm <- ::inherit("scripts/items/helmets/greatsword_faction_helm", {
	m = {},
	function create()
	{
		this.greatsword_faction_helm.create();
		this.m.ID = "armor.head.rf_greatsword_helm";
		this.m.Name = "决斗者之盔";
		this.m.Variant = 82;
		this.m.VariantString = "helmet";
		this.updateVariant();
	}

	function updateVariant()
	{
		this.helmet.updateVariant();
	}

});
