this.human_camp_wood <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "切碎的木头";
	}

	function getDescription()
	{
		return "准备用来做柴火或者修栅栏的木头。";
	}

	function onInit()
	{
		local variants = [
			"11",
			"15"
		];
		local body = this.addSprite("body");
		body.setBrush("camp_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});
