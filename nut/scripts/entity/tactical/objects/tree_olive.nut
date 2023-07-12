this.tree_olive <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "橄榄树(Olive Tree)";
	}

	function getDescription()
	{
		return "一棵大橄榄树。阻挡移动和视线。";
	}

	function onInit()
	{
		local v = this.Math.rand(1, 2);
		local flip = this.Math.rand(0, 1) == 1;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("steppe_tree_0" + v + "_bottom");
		bottom.setHorizontalFlipping(flip);
		bottom.varyColor(0.030000, 0.030000, 0.030000);
		bottom.Scale = 0.700000 + this.Math.rand(0, 30) / 100.000000;
		local middle = this.addSprite("middle");
		middle.setBrush("steppe_tree_0" + v + "_middle");
		middle.setHorizontalFlipping(flip);
		middle.Color = bottom.Color;
		middle.Scale = bottom.Scale;
		local top = this.addSprite("top");
		top.setBrush("steppe_tree_0" + v + "_top");
		top.setHorizontalFlipping(flip);
		top.varyColor(0.050000, 0.050000, 0.050000);
		top.Scale = bottom.Scale;
		top.Rotation = this.Math.rand(-5, 5);
		this.setSpriteOcclusion("bottom", 1, -1, -2);
		this.setSpriteOcclusion("middle", 2, 2, -3);
		this.setSpriteOcclusion("top", 2, 2, -3);
		this.setBlockSight(true);
	}

});
