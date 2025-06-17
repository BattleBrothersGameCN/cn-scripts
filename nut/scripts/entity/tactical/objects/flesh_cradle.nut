this.flesh_cradle <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "血肉摇篮";
	}

	function getDescription()
	{
		return "一座盛放着血肉和内脏的石头容器。";
	}

	function onInit()
	{
		local flip = false;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("flesh_cradle_01_bottom");
		local top = this.addSprite("top");
		top.setBrush("flesh_cradle_01_top");
		this.setBlockSight(false);
	}

	function isDying()
	{
		return true;
	}

});
