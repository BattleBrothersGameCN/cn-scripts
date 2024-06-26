this.tree_cypress <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "柏树";
	}

	function getDescription()
	{
		return "一棵柏树。阻挡移动和视线。";
	}

	function onInit()
	{
		local flip = this.Math.rand(0, 1) == 1;
		local v = this.Math.rand(1, 2);
		local bottom = this.addSprite("bottom");
		bottom.setBrush("steppe_cypress_0" + v + "_bottom");
		bottom.setHorizontalFlipping(flip);
		bottom.varyColor(0.07, 0.07, 0.07);
		bottom.Scale = 0.9 + this.Math.rand(0, 10) / 100.0;
		bottom.Rotation = this.Math.rand(-5, 5);
		local top = this.addSprite("top");
		top.setBrush("steppe_cypress_0" + v + "_top");
		top.setHorizontalFlipping(flip);
		top.Color = bottom.Color;
		top.Scale = bottom.Scale;
		top.Rotation = bottom.Rotation;
		this.setSpriteOcclusion("top", 1, 2, -3);
		this.setBlockSight(true);
	}

});
