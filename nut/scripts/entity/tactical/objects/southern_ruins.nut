this.southern_ruins <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "废墟";
	}

	function getDescription()
	{
		return "石头建物倒塌形成的废墟。";
	}

	function onInit()
	{
		local variants = [
			"01",
			"01",
			"08",
			"08",
			"09"
		];
		local r = this.Math.rand(0, variants.len() - 1);
		local body = this.addSprite("body");
		body.setBrush("southern_ruins_" + variants[r]);
		body.setHorizontalFlipping(this.Math.rand(0, 1) == 1);

		if (variants[r] != "08")
		{
			this.setBlockSight(true);
		}
	}

});
