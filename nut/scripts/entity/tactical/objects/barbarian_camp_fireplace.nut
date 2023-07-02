this.barbarian_camp_fireplace <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "火炉";
	}

	function getDescription()
	{
		return "用来做饭的火炉。";
	}

	function onInit()
	{
		local variants = [
			"01"
		];
		local body = this.addSprite("body");
		body.setBrush("barbarians_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});
