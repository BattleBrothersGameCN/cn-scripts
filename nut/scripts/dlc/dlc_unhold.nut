local gt = this.getroottable();

if (!("DLC" in gt.Const))
{
	gt.Const.DLC <- {};
	gt.Const.DLC.Mask <- 0;
}

if (!("Unhold" in gt.Const.DLC) || !this.Const.DLC.Unhold)
{
	this.Const.DLC.Unhold <- this.hasDLC(961930) && this.Const.Serialization.Version >= 46;

	if (this.Const.DLC.Unhold)
	{
		this.Const.DLC.Mask = this.Const.DLC.Mask | 4;
		this.Const.LoadingScreens.push("ui/screens/loading_screen_06.jpg");
		local tips = [
			"北方的冰冻废土栖居着一种其他地方见不到的野兽。",
			"林德蠕龙（林德虫）是一种无翼的双足龙，形似一条巨蛇。",
			"巨魔有不同的地区变种。",
			"即使是战斗中，巨魔的伤口也可以快速愈合。",
			"树木缓缓移动。",
			"梦魔以人们噩梦中的恐惧和痛苦为食。",
			"探索世界，寻找传说中的地点和传奇宝藏。",
			"双手棒在瘫痪单个对手方面表现出色。",
			"斧头特别适合砍树。",
			"树人是一棵棵活着的树，是树皮和木材组成的生命，其思维方式非人类所能理解。",
			"使用盔甲附件，进一步改进和专门化你士兵的装备。",
			"女巫在她迷住的人眼里，是光彩照人的年轻女性。",
			"女巫以做令人后悔的不光彩交易而著称。",
			"女巫可以诅咒你的人，让他受和她一样的伤。",
			"蛛魔能够对困在网中的目标造成额外伤害。",
			"蛛魔以大群行动时更有信心。",
			"蛛魔是一种大型蜘蛛，大群聚居在各地森林深处的黑暗地带。",
			"从被杀死的野兽身上收集战利品，让剥制师制成有用的物品。",
			"出售野兽战利品可以获得高额收益。你总能得到新的。",
			"刺剑在具有高主动值的角色手中最为强大。",
			"使用投矛远程击破最具威胁对手的盾牌。",
			"食尸鬼多见于世界南部地区。",
			"梦魔几乎只在夜间出现。",
			"离文明越远的土地上，游荡的野兽就越危险。",
			"药剂，描述天花乱坠，本质却是毒品，角色可能会对它们上瘾。",
			"过量服用药剂会导致角色呕吐和生病。",
			"在“野兽杀手”起源游戏中，你能更轻松地追踪野兽，从猎杀的野兽身上获得更多的战利品。"
		];
		this.Const.TipOfTheDay.extend(tips);
		this.Const.Music.BeastsTracks.push("music/beasts_03.ogg");
		this.Const.Music.BattleTracks[7].push("music/beasts_03.ogg");
		this.Const.Music.WorldmapTracks.push("music/worldmap_10.ogg");
		this.Const.Music.WorldmapTracksGreaterEvil.push("music/worldmap_10.ogg");
		this.Const.Items.NamedWeapons.push("weapons/named/named_polehammer");
		this.Const.Items.NamedWeapons.push("weapons/named/named_fencing_sword");
		this.Const.Items.NamedWeapons.push("weapons/named/named_two_handed_mace");
		this.Const.Items.NamedWeapons.push("weapons/named/named_two_handed_flail");
		this.Const.Items.NamedWeapons.push("weapons/named/named_three_headed_flail");
		this.Const.Items.NamedWeapons.push("weapons/named/named_spetum");
		this.Const.Items.NamedMeleeWeapons.push("weapons/named/named_polehammer");
		this.Const.Items.NamedMeleeWeapons.push("weapons/named/named_fencing_sword");
		this.Const.Items.NamedMeleeWeapons.push("weapons/named/named_two_handed_mace");
		this.Const.Items.NamedMeleeWeapons.push("weapons/named/named_two_handed_flail");
		this.Const.Items.NamedMeleeWeapons.push("weapons/named/named_three_headed_flail");
		this.Const.Items.NamedMeleeWeapons.push("weapons/named/named_spetum");
	}
}
