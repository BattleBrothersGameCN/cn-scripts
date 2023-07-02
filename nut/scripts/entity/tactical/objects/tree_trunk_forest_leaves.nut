this.tree_trunk_forest_leaves <- this.inherit("scripts/entity/tactical/entity", {
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
		local v = this.Math.rand(1, 3);
		local body = this.addSprite("body");
		body.setBrush("forest_treetrunk_0" + v);
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);

		if (v == 1)
		{
			body.Color = this.createColor("#f8f8e6");
		}
		else
		{
			body.Color = this.createColor("#f0ffdc");
		}

		body.varyColor(0.050000, 0.050000, 0.050000);
		body.Saturation = 0.950000;
		body.Scale = 0.700000 + this.Math.rand(0, 30) / 100.000000;
	}

});
