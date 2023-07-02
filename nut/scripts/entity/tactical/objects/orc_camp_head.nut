this.orc_camp_head <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "尖头";
	}

	function getDescription()
	{
		return "用来警示这一带的人类会遭遇什么的标记。";
	}

	function setFlipped( _flip )
	{
		this.getSprite("body").setHorizontalFlipping(_flip);
	}

	function setVariant( _variant )
	{
		local variants = [
			"15",
			"16"
		];
		this.getSprite("body").setBrush("orcs_" + variants[_variant]);
	}

	function onInit()
	{
		this.addSprite("body");
	}

});
