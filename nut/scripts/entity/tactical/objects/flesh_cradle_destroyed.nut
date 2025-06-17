this.flesh_cradle_destroyed <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "毁坏的血肉摇篮";
	}

	function getDescription()
	{
		return "一座毁坏的石头容器。其中盛放着的血肉和内脏洒落在周围的地面上。";
	}

	function onInit()
	{
		local flip = false;
		local body = this.addSprite("body");
		body.setBrush("flesh_cradle_01_destroyed");
		this.setBlockSight(false);
	}

	function isDying()
	{
		return true;
	}

});
