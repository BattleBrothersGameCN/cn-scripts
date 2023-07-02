this.tree_trunk_forest <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return this.Const.Strings.Tactical.EntityName.Tree;
	}

	function getDescription()
	{
		return "曾经骄傲的树的残骸。";
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("forest_treetrunk_0" + this.Math.rand(2, 4));
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.Color = this.createColor("#dbdef0");
		body.varyColor(0.050000, 0.050000, 0.050000);
		body.Scale = 0.700000 + this.Math.rand(0, 30) / 100.000000;
	}

});
