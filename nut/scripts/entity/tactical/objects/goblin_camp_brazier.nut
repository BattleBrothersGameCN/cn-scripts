this.goblin_camp_brazier <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "火盆";
	}

	function getDescription()
	{
		return "装满了木头的火盆。";
	}

	function onInit()
	{
		local variants = [
			"04"
		];
		local body = this.addSprite("body");
		body.setBrush("goblins_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});
