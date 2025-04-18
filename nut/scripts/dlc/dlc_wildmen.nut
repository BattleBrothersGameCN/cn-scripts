local gt = this.getroottable();

if (!("DLC" in gt.Const))
{
	gt.Const.DLC <- {};
	gt.Const.DLC.Mask <- 0;
}

if (!("Wildmen" in gt.Const.DLC) || !this.Const.DLC.Wildmen)
{
	this.Const.DLC.Wildmen <- this.hasDLC(1067690) && this.Const.Serialization.Version >= 48;

	if (this.Const.DLC.Wildmen)
	{
		this.Const.DLC.Mask = this.Const.DLC.Mask | 16;
		this.Const.LoadingScreens.push("ui/screens/loading_screen_06.jpg");
		this.Const.LoadingScreens.push("ui/screens/loading_screen_09.jpg");
		local tips = [
			"北方居住着凶猛的野蛮人部落。",
			"蛮族常常在战斗开始时压倒对手，但很快就会疲惫不堪。",
			"比起南方战犬，北方的战獒强壮更甚但敏捷不足。",
			"鼓手有节奏的部落节拍每回合都能为所有野蛮人降低少量疲劳值。",
			"兽王不能在接邻敌人时使用鞭子指挥他们的野兽战争机器。",
			"蛮族人期望在来世与他们的祖先相遇。",
			"根据游戏风格选择不同起源，定制你的战役。",
			"在“独狼”起源游戏中，你将拥有一个玩家角色。如果你死了，游戏（战役）就结束了。",
			"在“农民民兵”起源游戏中，你可以将至多16人投入同一场战斗。",
			"在“邪教徒”起源游戏中，你的神会向你索要贡品，也会赐予忠于祂的人恩惠。",
			"在“偷猎团”起源游戏中，你的队伍能更快地世界地图上移动。",
			"在“贸易商队”起源游戏中，你能获得更好的买入和卖出价格。",
			"投石索命中头部会施加“茫然”状态效果。",
			"石头遍地都是，投石索永远不缺弹药。",
			"战鞭能够暂时解除对手的武器，阻止他们使用武器技能。",
			"战鞭能够造成流血伤口，但对抗护甲效果低下。",
			"短弯刀和狮尾弯刀在打击目标时更容易造成创伤。"
		];
		this.Const.TipOfTheDay.extend(tips);
		this.Const.PlayerBanners.push("banner_24");
		this.Const.PlayerBanners.push("banner_25");
		this.Const.Tattoos.All.push("warpaint_02");
		this.Const.Tattoos.All.push("warpaint_03");
		this.Const.Tattoos.All.push("tattoo_02");
		this.Const.Tattoos.All.push("tattoo_03");
		this.Const.Tattoos.All.push("tattoo_04");
		this.Const.Tattoos.All.push("tattoo_05");
		this.Const.Tattoos.All.push("tattoo_06");
		this.Const.Items.NamedWeapons.push("weapons/named/named_bardiche");
		this.Const.Items.NamedWeapons.push("weapons/named/named_shamshir");
		this.Const.Items.NamedWeapons.push("weapons/named/named_battle_whip");
		this.Const.Items.NamedMeleeWeapons.push("weapons/named/named_bardiche");
		this.Const.Items.NamedMeleeWeapons.push("weapons/named/named_shamshir");
		this.Const.Items.NamedMeleeWeapons.push("weapons/named/named_battle_whip");
		this.Const.Items.NamedHelmets.push("helmets/named/norse_helmet");
		this.Const.Items.NamedHelmets.push("helmets/named/named_conic_helmet_with_faceguard");
		this.Const.Items.NamedHelmets.push("helmets/named/named_nordic_helmet_with_closed_mail");
		this.Const.Items.NamedHelmets.push("helmets/named/named_steppe_helmet_with_mail");
		this.Const.Items.NamedSouthernHelmets.push("helmets/named/named_steppe_helmet_with_mail");
		this.Const.Items.NamedArmors.push("armor/named/named_golden_lamellar_armor");
		this.Const.Items.NamedArmors.push("armor/named/named_noble_mail_armor");
		this.Const.Items.NamedArmors.push("armor/named/named_sellswords_armor");
		this.Const.Items.NamedSouthernArmors.push("armor/named/named_golden_lamellar_armor");
		this.Const.Items.NamedBarbarianHelmets.push("helmets/named/named_metal_bull_helmet");
		this.Const.Items.NamedBarbarianHelmets.push("helmets/named/named_metal_nose_horn_helmet");
		this.Const.Items.NamedBarbarianHelmets.push("helmets/named/named_metal_skull_helmet");
		this.Const.Items.NamedBarbarianArmors.push("armor/named/named_bronze_armor");
		this.Const.Items.NamedBarbarianArmors.push("armor/named/named_plated_fur_armor");
		this.Const.Items.NamedBarbarianArmors.push("armor/named/named_skull_and_chain_armor");
		this.Const.Items.NamedBarbarianWeapons.push("weapons/named/named_rusty_warblade");
		this.Const.Items.NamedBarbarianWeapons.push("weapons/named/named_skullhammer");
		this.Const.Items.NamedBarbarianWeapons.push("weapons/named/named_heavy_rusty_axe");
		this.Const.Items.NamedBarbarianWeapons.push("weapons/named/named_two_handed_spiked_mace");
	}
}
