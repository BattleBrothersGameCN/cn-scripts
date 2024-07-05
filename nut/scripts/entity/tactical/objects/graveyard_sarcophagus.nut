this.graveyard_sarcophagus <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "石棺";
	}

	function getDescription()
	{
		return "也许是很久前的某人的安眠之地。";
	}

	function onInit()
	{
		local variants = [
			"03"
		];
		local body = this.addSprite("body");
		body.setBrush("graveyard_" + variants[this.Math.rand(0, variants.len() - 1)]);
		body.setHorizontalFlipping(this.Math.rand(0, 1) == 1);
		this.setBlockSight(true);
	}

});
