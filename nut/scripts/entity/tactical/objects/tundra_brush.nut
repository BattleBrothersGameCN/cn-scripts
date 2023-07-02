this.tundra_brush <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "灌木丛";
	}

	function getDescription()
	{
		return "茂密的灌木阻挡了移动和视线。";
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("tundra_brush_0" + this.Math.rand(1, 3));
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.varyColor(0.070000, 0.070000, 0.070000);
		body.Scale = 0.900000 + this.Math.rand(0, 10) / 100.000000;
		body.Rotation = this.Math.rand(-5, 5);
		this.setBlockSight(true);
	}

});
