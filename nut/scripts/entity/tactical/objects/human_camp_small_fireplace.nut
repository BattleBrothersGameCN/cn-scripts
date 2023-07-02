this.human_camp_small_fireplace <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "火炉";
	}

	function getDescription()
	{
		return "一个点着火的火盆。";
	}

	function onInit()
	{
		local variants = [
			"10"
		];
		local body = this.addSprite("body");
		body.setBrush("camp_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});
