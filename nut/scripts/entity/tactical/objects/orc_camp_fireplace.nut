this.orc_camp_fireplace <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "火堆";
	}

	function getDescription()
	{
		return "一个火堆。你可不想知道他们在煮什么。";
	}

	function onInit()
	{
		local variants = [
			"06",
			"09"
		];
		local body = this.addSprite("body");
		body.setBrush("orcs_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});
