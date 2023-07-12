this.tree_dead_steppe <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "死树(Dead Tree)";
	}

	function getDescription()
	{
		return "这棵枯树已经死了很久了。阻挡移动和视线。";
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("steppe_dead_tree_0" + this.Math.rand(1, 2));
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.varyColor(0.030000, 0.030000, 0.030000);
		body.Scale = 0.700000 + this.Math.rand(0, 30) / 100.000000;
		this.setSpriteOcclusion("body", 1, -1, -2);
		this.setBlockSight(true);
	}

});
