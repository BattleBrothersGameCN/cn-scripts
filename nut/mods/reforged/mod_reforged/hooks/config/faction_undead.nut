::Reforged.Entities.addEntity("RF_SkeletonMediumElite", "古代资深老兵", "古代资深老兵", "rf_skeleton_medium_elite_orientation", ::Const.FactionType.Undead, {
	Variant = 0,
	Strength = 35,
	Cost = 30,
	Row = 0,
	Script = "scripts/entity/tactical/enemies/rf_skeleton_medium_elite"
}, {
	XP = 325,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 85,
	Stamina = 100,
	MeleeSkill = 75,
	RangedSkill = 0,
	MeleeDefense = 10,
	RangedDefense = 0,
	Initiative = 80,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, ::Const.EntityType.SkeletonMedium + 1);
::Reforged.Entities.addTroop("RF_SkeletonMediumElitePolearm", ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_SkeletonMediumElite, {
	Cost = 35,
	Row = 1
}));
::Reforged.Entities.editEntity("SkeletonHeavy", {
	Strength = 35,
	Variant = 0,
	Row = 1
}, {
	XP = 350,
	ActionPoints = 9,
	Hitpoints = 75,
	Bravery = 90,
	Stamina = 100,
	MeleeSkill = 75,
	RangedSkill = 0,
	MeleeDefense = 10,
	RangedDefense = 0,
	Initiative = 75,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, function ()
{
	::Const.Strings.EntityName[::Const.EntityType.SkeletonHeavy] = "古代禁卫军";
	::Const.Strings.EntityNamePlural[::Const.EntityType.SkeletonHeavy] = "古代禁卫军";
	::Const.EntityIcon[::Const.EntityType.SkeletonHeavy] = "rf_skeleton_heavy_orientation";
});
::Reforged.Entities.addEntity("RF_SkeletonHeavyElite", "古代仪仗兵", "古代仪仗兵", "skeleton_03_orientation", ::Const.FactionType.Undead, {
	Variant = 1,
	Strength = 45,
	Cost = 45,
	Row = 1,
	Script = "scripts/entity/tactical/enemies/rf_skeleton_heavy_elite",
	NameList = ::Const.Strings.AncientDeadNames,
	TitleList = null
}, {
	XP = 450,
	ActionPoints = 9,
	Hitpoints = 90,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 80,
	RangedSkill = 0,
	MeleeDefense = 15,
	RangedDefense = 0,
	Initiative = 75,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, ::Const.EntityType.SkeletonHeavy + 1);
::Reforged.Entities.addTroop("RF_SkeletonHeavyEliteBodyguard", ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_SkeletonHeavyElite, {
	Variant = 0,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_skeleton_heavy_elite_bodyguard"
}));
::Reforged.Entities.addEntity("RF_SkeletonDecanus", "古代十夫长", "古代十夫长", "rf_skeleton_decanus_orientation", ::Const.FactionType.Undead, {
	Variant = 0,
	Strength = 30,
	Cost = 30,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_skeleton_decanus"
}, {
	XP = 325,
	ActionPoints = 9,
	Hitpoints = 65,
	Bravery = 80,
	Stamina = 100,
	MeleeSkill = 70,
	RangedSkill = 0,
	MeleeDefense = 10,
	RangedDefense = 10,
	Initiative = 75,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, ::Const.EntityType.RF_SkeletonHeavyElite + 1);
::Reforged.Entities.addEntity("RF_SkeletonCenturion", "古代百夫长", "古代百夫长", "rf_skeleton_centurion_orientation", ::Const.FactionType.Undead, {
	Variant = 0,
	Strength = 40,
	Cost = 40,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_skeleton_centurion"
}, {
	XP = 400,
	ActionPoints = 9,
	Hitpoints = 75,
	Bravery = 90,
	Stamina = 100,
	MeleeSkill = 75,
	RangedSkill = 0,
	MeleeDefense = 15,
	RangedDefense = 15,
	Initiative = 80,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, ::Const.EntityType.RF_SkeletonDecanus + 1);
::Reforged.Entities.addEntity("RF_SkeletonLegatus", "古代军团长", "古代军团长", "rf_skeleton_legatus_orientation", ::Const.FactionType.Undead, {
	Variant = 5,
	Strength = 50,
	Cost = 50,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_skeleton_legatus",
	NameList = ::Const.Strings.AncientDeadNames,
	TitleList = ::Const.Strings.RF_AncientDeadCommanderTitles
}, {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 85,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 80,
	RangedSkill = 0,
	MeleeDefense = 20,
	RangedDefense = 20,
	Initiative = 85,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, ::Const.EntityType.RF_SkeletonCenturion + 1);
::Reforged.Entities.addEntity("RF_VampireLord", "死灵领主", "死灵领主", "rf_vampire_lord_orientation", ::Const.FactionType.Undead, {
	Variant = 5,
	Strength = 50,
	Cost = 50,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_vampire_lord",
	NameList = ::Const.Strings.RF_VampireLordNames,
	TitleList = ::Const.Strings.RF_VampireLordTitles
}, {
	XP = 700,
	ActionPoints = 9,
	Hitpoints = 300,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 95,
	RangedSkill = 0,
	MeleeDefense = 30,
	RangedDefense = 30,
	Initiative = 140,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, ::Const.EntityType.Vampire + 1);
::Reforged.Entities.addEntity("RF_DraugrThrall", "墓穴战奴", "墓穴战奴", "rf_draugr_thrall_orientation", ::Const.FactionType.Undead, {
	Variant = 0,
	Strength = 25,
	Cost = 18,
	Row = 0,
	Script = "scripts/entity/tactical/enemies/rf_draugr_thrall"
}, {
	XP = 200,
	ActionPoints = 9,
	Hitpoints = 120,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 60,
	RangedSkill = 0,
	MeleeDefense = 5,
	RangedDefense = 0,
	Initiative = 55,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
});
::Reforged.Entities.addTroop("RF_DraugrThrallBodyguard", ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_DraugrThrall, {
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_draugr_thrall_bodyguard"
}));
::Reforged.Entities.addEntity("RF_DraugrWarrior", "墓穴尸鬼", "墓穴尸鬼", "rf_draugr_warrior_orientation", ::Const.FactionType.Undead, {
	Variant = 0,
	Strength = 35,
	Cost = 35,
	Row = 0,
	Script = "scripts/entity/tactical/enemies/rf_draugr_warrior"
}, {
	XP = 350,
	ActionPoints = 9,
	Hitpoints = 160,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 70,
	RangedSkill = 0,
	MeleeDefense = 10,
	RangedDefense = 0,
	Initiative = 60,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
});
::Reforged.Entities.addTroop("RF_DraugrWarriorBodyguard", ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_DraugrWarrior, {
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_draugr_warrior_bodyguard"
}));
::Reforged.Entities.addEntity("RF_DraugrHuskarl", "墓穴亲卫", "墓穴亲卫", "rf_draugr_huskarl_orientation", ::Const.FactionType.Undead, {
	Variant = 0,
	Strength = 45,
	Cost = 45,
	Row = 1,
	Script = "scripts/entity/tactical/enemies/rf_draugr_huskarl"
}, {
	XP = 450,
	ActionPoints = 9,
	Hitpoints = 200,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 80,
	RangedSkill = 0,
	MeleeDefense = 20,
	RangedDefense = 0,
	Initiative = 65,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
});
::Reforged.Entities.addTroop("RF_DraugrHuskarlBodyguard", ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_DraugrHuskarl, {
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_draugr_huskarl_bodyguard"
}));
::Reforged.Entities.addEntity("RF_DraugrHero", "墓穴勇士", "墓穴勇士", "rf_draugr_hero_orientation", ::Const.FactionType.Undead, {
	Variant = 1,
	Strength = 60,
	Cost = 60,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_draugr_hero",
	NameList = ::Const.Strings.RF_DraugrNames,
	TitleList = ::Const.Strings.RF_DraugrTitles
}, {
	XP = 650,
	ActionPoints = 9,
	Hitpoints = 220,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 90,
	RangedSkill = 0,
	MeleeDefense = 30,
	RangedDefense = 0,
	Initiative = 70,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
});
::Reforged.Entities.addTroop("RF_DraugrHeroChampion", ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_DraugrHero, {
	Variant = 999
}));
::Reforged.Entities.addEntity("RF_DraugrShaman", "墓穴先知", "墓穴先知", "rf_draugr_shaman_orientation", ::Const.FactionType.Undead, {
	Variant = 0,
	Strength = 60,
	Cost = 60,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_draugr_shaman"
}, {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 150,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 55,
	RangedSkill = 0,
	MeleeDefense = 5,
	RangedDefense = 20,
	Initiative = 75,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
});
::Reforged.Entities.editEntity("Necromancer", {
	Variant = 10
});
::Reforged.Entities.editEntity("ZombieKnight", {
	Variant = 0
}, {
	XP = 250,
	ActionPoints = 7,
	Hitpoints = 180,
	Bravery = 70,
	Stamina = 100,
	MeleeSkill = 60,
	RangedSkill = 0,
	MeleeDefense = 5,
	RangedDefense = 0,
	Initiative = 60,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, function ()
{
	::Const.Strings.EntityName[::Const.EntityType.ZombieKnight] = "堕落骑士";
	::Const.Strings.EntityNamePlural[::Const.EntityType.ZombieKnight] = "堕落骑士";
});
::Reforged.Entities.addEntity("RF_ZombieHero", "堕落英雄", "堕落英雄", "zombie_03_orientation", ::Const.FactionType.Zombies, {
	Variant = 1,
	Strength = 30,
	Cost = 32,
	Row = -1,
	Script = "scripts/entity/tactical/enemies/rf_zombie_hero",
	NameList = ::Const.Strings.KnightNames,
	TitleList = ::Const.Strings.FallenHeroTitles
}, {
	XP = 350,
	ActionPoints = 7,
	Hitpoints = 230,
	Bravery = 110,
	Stamina = 100,
	MeleeSkill = 70,
	RangedSkill = 0,
	MeleeDefense = 10,
	RangedDefense = 0,
	Initiative = 70,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, ::Const.EntityType.ZombieKnight + 1);
::Reforged.Entities.addTroop("RF_ZombieHeroBodyguard", ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_ZombieHero, {
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_zombie_hero_bodyguard"
}));
::Reforged.Entities.addEntity("RF_Hollenhund", "地狱犬", "地狱犬", "rf_hollenhund_orientation", ::Const.FactionType.Zombies, {
	Variant = 0,
	Strength = 40,
	Cost = 20,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_hollenhund"
}, {
	XP = 400,
	ActionPoints = 12,
	Hitpoints = 150,
	Bravery = 90,
	Stamina = 100,
	MeleeSkill = 70,
	RangedSkill = 0,
	MeleeDefense = 20,
	RangedDefense = 50,
	Initiative = 110,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, ::Const.EntityType.Ghost + 1);
::Reforged.Entities.addEntity("RF_Banshee", "哀伤之母", "哀伤之母", "rf_banshee_orientation", ::Const.FactionType.Zombies, {
	Variant = 10,
	Strength = 50,
	Cost = 50,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_banshee",
	NameList = ::Const.Strings.RF_BansheeNames,
	TitleList = ::Const.Strings.RF_BansheeTitles
}, {
	XP = 550,
	ActionPoints = 9,
	Hitpoints = 1,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 80,
	RangedSkill = 0,
	MeleeDefense = 15,
	RangedDefense = 999,
	Initiative = 100,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, ::Const.EntityType.Ghost + 1);
::Reforged.Entities.addEntity("RF_ZombieOrcYoung", "僵尸兽人青年", "僵尸兽人青年", "rf_zombie_orc_young_orientation", ::Const.FactionType.Zombies, {
	Variant = 0,
	Strength = 14,
	Cost = 12,
	Row = -1,
	Script = "scripts/entity/tactical/enemies/rf_zombie_orc_young"
}, {
	XP = 200,
	ActionPoints = 6,
	Hitpoints = 200,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 50,
	RangedSkill = 0,
	MeleeDefense = -10,
	RangedDefense = -10,
	Initiative = 60,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, ::Const.EntityType.Ghost);
::Reforged.Entities.addTroop("RF_ZombieOrcYoungBodyguard", ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_ZombieOrcYoung, {
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_zombie_orc_young_bodyguard"
}));
::Reforged.Entities.addEntity("RF_ZombieOrcBerserker", "Wiederganger Orc Berserker", "Wiederganger Orc Berserkers", "rf_zombie_orc_berserker_orientation", ::Const.FactionType.Zombies, {
	Variant = 0,
	Strength = 25,
	Cost = 20,
	Row = -1,
	Script = "scripts/entity/tactical/enemies/rf_zombie_orc_berserker"
}, {
	XP = 300,
	ActionPoints = 7,
	Hitpoints = 350,
	Bravery = 90,
	Stamina = 100,
	MeleeSkill = 60,
	RangedSkill = 0,
	MeleeDefense = 0,
	RangedDefense = -5,
	Initiative = 60,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, ::Const.EntityType.Ghost);
::Reforged.Entities.addEntity("RF_ZombieOrcWarrior", "僵尸兽人战士", "僵尸兽人战士", "rf_zombie_orc_warrior_orientation", ::Const.FactionType.Zombies, {
	Variant = 0,
	Strength = 28,
	Cost = 25,
	Row = -1,
	Script = "scripts/entity/tactical/enemies/rf_zombie_orc_warrior"
}, {
	XP = 350,
	ActionPoints = 7,
	Hitpoints = 300,
	Bravery = 90,
	Stamina = 100,
	MeleeSkill = 60,
	RangedSkill = 0,
	MeleeDefense = -15,
	RangedDefense = -15,
	Initiative = 60,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, ::Const.EntityType.Ghost);
::Reforged.Entities.addTroop("RF_ZombieOrcWarriorBodyguard", ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_ZombieOrcWarrior, {
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_zombie_orc_warrior_bodyguard"
}));
::Reforged.Entities.addEntity("RF_ZombieOrcWarlord", "僵尸兽人军阀", "僵尸兽人军阀", "rf_zombie_orc_warlord_orientation", ::Const.FactionType.Zombies, {
	Variant = 0,
	Strength = 36,
	Cost = 34,
	Row = -1,
	Script = "scripts/entity/tactical/enemies/rf_zombie_orc_warlord"
}, {
	XP = 450,
	ActionPoints = 7,
	Hitpoints = 600,
	Bravery = 130,
	Stamina = 100,
	MeleeSkill = 70,
	RangedSkill = 0,
	MeleeDefense = -15,
	RangedDefense = -15,
	Initiative = 60,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
}, ::Const.EntityType.Ghost);
::Reforged.Entities.editEntity("GrandDiviner", null, {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 115,
	Bravery = 130,
	Stamina = 110,
	MeleeSkill = 80,
	RangedSkill = 0,
	MeleeDefense = 15,
	RangedDefense = 35,
	Initiative = 105,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	]
});
