this.orc_camp_fireplace <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "火炉";
	}

	function getDescription()
	{
		return "一个篝火。你不想知道他们在煮着什么。";
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
