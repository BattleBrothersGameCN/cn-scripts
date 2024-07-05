this.destroyed_greenskin_catapult <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "被毁的攻城器";
	}

	function getDescription()
	{
		return "失去作用的绿皮攻城器。";
	}

	function onInit()
	{
		local flip = false;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("greenskin_catapult_destroyed_bottom");
		local top = this.addSprite("top");
		top.setBrush("greenskin_catapult_destroyed_top");
		this.setSpriteOcclusion("top", 1, 2, -3);
		this.setBlockSight(false);
	}

	function isDying()
	{
		return true;
	}

});
