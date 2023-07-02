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
			"北方的冰原是一种巨兽的家园，其他地方都找不到它的踪影。",
			"林德蠕龙（林德虫）是一种无翼的双足龙，类似于一条巨大的蛇。",
			"独眼巨人有不同的地区变种。",
			"不受限者可以在战斗中快速愈合伤口。",
			"树移动缓慢。",
			"阿尔卑斯山怪物以那些做梦时感到害怕和痛苦的人的恐惧和痛苦为食。",
			"探索世界，寻找传说中的地点和传奇宝藏。",
			"双手狼牙棒在瘫痪单个对手方面表现出色。",
			"斧头特别适合砍树。",
			"一个树人(Schrat)是一棵活着的树，由树皮和木材组成的生命体，其思维方式十分陌生。",
			"使用装甲附件来进一步改进和专门化你士兵的装备。",
			"一个被Hexe迷住的人看到的是一个年轻的容貌美丽的女人。",
			"女巫以达成令人后悔的神秘交易而著称。",
			"一个女巫可以诅咒你的一个士兵，让他遭受和她一样的伤口。",
			"蛛魔(Webknechts)能够对被困在它们网中的目标造成额外伤害。",
			"蛛魔(Webknechts)在更大的小组中更有信心。",
			"蛛魔(Webknecht)是一种大型蜘蛛，生活在全球各地森林的黑暗地带，通常聚集成大型群体。",
			"从被杀死的野兽身上收集奖杯，让制作动物标本的工匠为你制作有用的物品。",
			"出售击败野兽的战利品可以获得高额收益。你总是可以得到新的。",
			"具有高先攻属性的角色手持击剑剑最为强大。",
			"使用投掷长矛远程击破你最危险对手的盾牌。",
			"食尸鬼在世界南部地区更为常见。",
			"阿尔卑斯山几乎只在夜间出现。",
			"离文明地区越远，漫游土地的野兽就越危险。",
			"药剂，尽管它们有着华丽的描述，本质上是毒品，角色可能会对它们上瘾。",
			"过量服用药剂会导致角色呕吐和生病。",
			"选择“兽人猎手”起源后，你追踪野兽会更容易，并且你会从猎杀的每只野兽身上获得更多的战利品。"
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
