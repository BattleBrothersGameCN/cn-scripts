this.tree_stump1 <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "树桩(Tree Stump)";
	}

	function getDescription()
	{
		return "被砍倒的树的残留物。";
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("stump_0" + this.Math.rand(1, 3));
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.varyColor(0.050000, 0.050000, 0.050000);
		body.Scale = 0.800000 + this.Math.rand(0, 20) / 100.000000;
		body.Rotation = this.Math.rand(-5, 5);
	}

});
