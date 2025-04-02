local gt = this.getroottable();

if (!("DLC" in gt.Const))
{
	gt.Const.DLC <- {};
	gt.Const.DLC.Mask <- 0;
}

if (!("Desert" in gt.Const.DLC) || !this.Const.DLC.Desert)
{
	this.Const.DLC.Desert <- this.hasDLC(1361280) && this.Const.Serialization.Version >= 63;

	if (this.Const.DLC.Desert)
	{
		this.Const.DLC.Mask = this.Const.DLC.Mask | 64;
		this.Const.LoadingScreens.push("ui/screens/loading_screen_10.jpg");
		local tips = [
			"南方城邦在医学、占星术和炼金术方面取得了空前的进步。",
			"南方人以他们的神命名自己为“金镀者”，他们整日沐浴在神光之中。",
			"“负债者”是城邦事实上的奴隶阶层，由罪犯、战俘和违反宗教教条者组成。",
			"南方城邦建立在古代帝国的废墟之上。",
			"游牧民是一群不受城邦统治的南方人。",
			"游牧民是沙漠战争的专家，善于利用环境 —— 包括把沙子抛到你脸上。",
			"伊夫利特是一种附身于岩石和流沙的恶灵。",
			"刺杀匕首最好与其他能使敌人昏迷或茫然的武器结合使用。",
			"火铳装填要用上一整个回合 —— 除非你的角色拥有“弩和火器精通”特技。",
			"火铳是一种能一次命中6个目标的远程武器，但射程比弓弩都要短。",
			"火矛和投掷武器一样，每场战斗后都需要重新装填。",
			"竞技场比赛来钱很快，但比赛中不能撤退，赛后也不能搜刮战利品。",
			"竞技场锦标赛是使用特殊规则的特别赛事。率领五名队员连续进行三场战斗，获胜即可赢得一件著名物品！",
			"每五场竞技场比赛中的第五场中，你都可以赢得一件无法通过购买获得的角斗士装备。",
			"火油罐不仅可以对对手造成伤害，还可以用来封锁格子，延迟对手行动。",
			"发烟罐可被用于使陷入近战的人安全撤退。",
			"城邦的臼炮必须有火炮技师在旁操作才能开火。",
			"在“猎奴者”起源游戏中，在每场与人类的战斗之后，你都可以俘获敌人，强迫他们为你而战。",
			"在“角斗士”起源游戏中，你将拥有3个强大的初始角色，失去全部3人将使游戏（战役）结束。",
			"雇佣非战斗追随者加入随行人员，根据游戏风格定制你的战役。",
			"著名盾牌毁于兽人之手？为你的战团雇一名铁匠，耐久度归零的物品他也能修好。",
			"训练新兵太花时间？雇一名教官能让他们更快地获得经验。",
			"冠军敌人太少？雇佣赏金猎人能帮你寻获他们，完成击杀还能获得赏金。",
			"工资支出太多？雇佣一名出纳员，减少您需要支付的工资。",
			"想知道谁去过那里？雇佣一名哨兵，他能从足迹中提取更多信息。",
			"弹药和工具总不够用？雇佣一名拾荒者，回收你用过的弹药，从摧毁的护甲里收集工具。",
			"背包已满？在战团界面购买板车和货车。",
			"你可以通过获得名望来解锁非战斗随从席位。",
			"凶猛的鬣狗漫游在南方的沙漠里，它们有着强大的颚骨，甚至能咬碎金属盔甲，造成出血伤口。",
			"尝试不同的追随者，找到适合你游戏风格和所选战团起源的组合。"
		];
		this.Const.TipOfTheDay.extend(tips);
		this.Const.Music.BeastsTracksSouth.push("music/beasts_04.ogg");
		this.Const.Music.ArenaTracks.push("music/beasts_04.ogg");
		this.Const.Music.WorldmapTracksSouth.push("music/worldmap_11.ogg");
		this.Const.Music.WorldmapTracksGreaterEvilSouth.push("music/worldmap_11.ogg");
		this.Const.PlayerBanners.push("banner_28");
		this.Const.PlayerBanners.push("banner_29");
		this.Const.PlayerBanners.push("banner_30");
		this.Const.Items.NamedWeapons.push("weapons/named/named_qatal_dagger");
		this.Const.Items.NamedWeapons.push("weapons/named/named_swordlance");
		this.Const.Items.NamedWeapons.push("weapons/named/named_polemace");
		this.Const.Items.NamedWeapons.push("weapons/named/named_two_handed_scimitar");
		this.Const.Items.NamedWeapons.push("weapons/named/named_handgonne");
		this.Const.Items.NamedMeleeWeapons.push("weapons/named/named_qatal_dagger");
		this.Const.Items.NamedMeleeWeapons.push("weapons/named/named_swordlance");
		this.Const.Items.NamedMeleeWeapons.push("weapons/named/named_polemace");
		this.Const.Items.NamedMeleeWeapons.push("weapons/named/named_two_handed_scimitar");
		this.Const.Items.NamedSouthernWeapons.push("weapons/named/named_shamshir");
		this.Const.Items.NamedSouthernWeapons.push("weapons/named/named_qatal_dagger");
		this.Const.Items.NamedSouthernWeapons.push("weapons/named/named_swordlance");
		this.Const.Items.NamedSouthernWeapons.push("weapons/named/named_polemace");
		this.Const.Items.NamedSouthernWeapons.push("weapons/named/named_two_handed_scimitar");
		this.Const.Items.NamedSouthernWeapons.push("weapons/named/named_spear");
		this.Const.Items.NamedSouthernWeapons.push("weapons/named/named_handgonne");
		this.Const.Items.NamedSouthernMeleeWeapons.push("weapons/named/named_shamshir");
		this.Const.Items.NamedSouthernMeleeWeapons.push("weapons/named/named_qatal_dagger");
		this.Const.Items.NamedSouthernMeleeWeapons.push("weapons/named/named_swordlance");
		this.Const.Items.NamedSouthernMeleeWeapons.push("weapons/named/named_polemace");
		this.Const.Items.NamedSouthernMeleeWeapons.push("weapons/named/named_two_handed_scimitar");
		this.Const.Items.NamedSouthernMeleeWeapons.push("weapons/named/named_spear");
		this.Const.Items.NamedShields.push("shields/named/named_sipar_shield");
		this.Const.Items.NamedSouthernShields.push("shields/named/named_sipar_shield");
		this.Const.Items.NamedSouthernArmors.push("armor/named/black_and_gold_armor");
		this.Const.Items.NamedSouthernArmors.push("armor/named/leopard_armor");
		this.Const.Items.NamedArmors.push("armor/named/black_and_gold_armor");
		this.Const.Items.NamedArmors.push("armor/named/leopard_armor");
		this.Const.Items.NamedSouthernHelmets.push("helmets/named/red_and_gold_band_helmet");
		this.Const.Items.NamedSouthernHelmets.push("helmets/named/gold_and_black_turban");
		this.Const.Items.NamedHelmets.push("helmets/named/red_and_gold_band_helmet");
		this.Const.Items.NamedHelmets.push("helmets/named/gold_and_black_turban");
		this.Const.World.Settings.SizeY = 170;
		this.Const.World.Settlements.Master.push({
			Amount = 3,
			List = this.Const.World.Settlements.CityStates,
			IgnoreSide = true,
			AdditionalSpace = 13
		});
		this.Const.Faces.Barber.extend(this.Const.Faces.SouthernMale);
		this.Const.Bodies.Barber.extend(this.Const.Bodies.SouthernMale);
		this.Const.Hair.Barber.extend(this.Const.Hair.SouthernMaleOnly);
		this.Const.Beards.Barber.extend(this.Const.Beards.SouthernOnly);
	}
}
