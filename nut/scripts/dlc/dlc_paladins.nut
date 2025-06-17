local gt = this.getroottable();

if (!("DLC" in gt.Const))
{
	gt.Const.DLC <- {};
	gt.Const.DLC.Mask <- 0;
}

if (!("Paladins" in gt.Const.DLC) || !this.Const.DLC.Paladins)
{
	this.Const.DLC.Paladins <- this.hasDLC(1910050) && this.Const.Serialization.Version >= 64;

	if (this.Const.DLC.Paladins)
	{
		this.Const.DLC.Mask = this.Const.DLC.Mask | 256;
		this.Const.LoadingScreens.push("ui/screens/loading_screen_11.jpg");
		local tips = [
			"在“解剖学家”起源游戏中，初次击败某种敌人将授予药剂，使队员发生变异，获得特殊能力。",
			"在“宣誓者”起源游戏中，你将选择誓言而非野心，获得特殊的恩惠和负担。"
		];
		this.Const.TipOfTheDay.extend(tips);
		this.Const.PlayerBanners.push("banner_32");
		this.Const.PlayerBanners.push("banner_33");
	}
}
