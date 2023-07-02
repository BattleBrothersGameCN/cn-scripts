this.mirage_sightings_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.mirage_sightings";
		this.m.Name = "目睹海市蜃楼";
		this.m.Description = "酷热的天气和摇曳的空气造成了许多海市蜃楼的景象，据说里面有奇怪的人影。 ";
		this.m.Icon = "ui/settlement_status/settlement_effect_43.png";
		this.m.Rumors = [
			"我告诉你，一片郁郁葱葱的绿洲，金色的屋顶在远处飞舞，彩虹色的鸟儿在前方飞翔！我在哪里看到的？嗯，是在去 %settlement% 的路上。我发誓！",
			"有些邪恶不会在黑夜中降临，也不会隐藏在暗处。他们在烈日下，在中午出来。如果你想知道我在说什么，就去 %settlement% 吧。",
			"沙漠中偶尔可以看到海市蜃楼，跟着它走可能会导致比在沙漠中迷路更糟糕的命运。"
		];
	}

	function getAddedString( _s )
	{
		return _s + "现在有" + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + "不再有" + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.removeSituationByID("situation.safe_roads");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
	}

});
