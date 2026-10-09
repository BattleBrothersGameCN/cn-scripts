this.rf_barrows_horns <- ::inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "大块遗骨";
	}

	function getDescription()
	{
		return "大型动物的遗体。";
	}

	function onInit()
	{
		local variants = [
			"01"
		];
		local tile = this.getTile();
		local isOnSnow = tile.Subtype == ::Const.Tactical.TerrainSubtype.Snow || tile.Subtype == ::Const.Tactical.TerrainSubtype.LightSnow;
		local body = this.addSprite("body");
		body.setBrush("rf_barrows_horns_" + ::MSU.Array.rand(variants) + (isOnSnow ? "_snow" : ""));
		body.setHorizontalFlipping(::Math.rand(0, 1) == 1);
	}

});
