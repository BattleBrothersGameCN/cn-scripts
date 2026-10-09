::Reforged.Entities.editEntity("BanditThug", null, {
	XP = 150,
	ActionPoints = 9,
	Hitpoints = 55,
	Bravery = 40,
	Stamina = 95,
	MeleeSkill = 55,
	RangedSkill = 45,
	MeleeDefense = 0,
	RangedDefense = 0,
	Initiative = 95,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.addEntity("RF_BanditPillager", "强盗掠夺者", "强盗掠夺者", "rf_bandit_pillager_orientation", ::Const.FactionType.Bandits, {
	Variant = 0,
	Strength = 16,
	Cost = 16,
	Row = 0,
	Script = "scripts/entity/tactical/enemies/rf_bandit_pillager"
}, {
	XP = 225,
	ActionPoints = 9,
	Hitpoints = 75,
	Bravery = 50,
	Stamina = 115,
	MeleeSkill = 65,
	RangedSkill = 55,
	MeleeDefense = 10,
	RangedDefense = 0,
	Initiative = 105,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.BanditRaider);
::Reforged.Entities.editEntity("BanditRaider", {
	Cost = 23,
	Strength = 23
}, {
	XP = 300,
	ActionPoints = 9,
	Hitpoints = 80,
	Bravery = 60,
	Stamina = 125,
	MeleeSkill = 72,
	RangedSkill = 60,
	MeleeDefense = 10,
	RangedDefense = 0,
	Initiative = 110,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.addEntity("RF_BanditMarauder", "强盗劫掠者", "强盗劫掠者", "rf_bandit_marauder_orientation", ::Const.FactionType.Bandits, {
	Variant = 0,
	Strength = 30,
	Cost = 30,
	Row = 0,
	Script = "scripts/entity/tactical/enemies/rf_bandit_marauder"
}, {
	XP = 350,
	ActionPoints = 9,
	Hitpoints = 85,
	Bravery = 70,
	Stamina = 130,
	MeleeSkill = 80,
	RangedSkill = 65,
	MeleeDefense = 15,
	RangedDefense = 0,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.BanditRaider + 1);
::Reforged.Entities.addTroopAndActor("RF_BanditThugTough", ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.BanditThug, {
	Script = "scripts/entity/tactical/enemies/rf_bandit_thug_tough"
}), {
	XP = 150,
	ActionPoints = 9,
	Hitpoints = 90,
	Bravery = 50,
	Stamina = 100,
	MeleeSkill = 55,
	RangedSkill = 45,
	MeleeDefense = -5,
	RangedDefense = 0,
	Initiative = 60,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.addTroopAndActor("RF_BanditPillagerTough", ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_BanditPillager, {
	Script = "scripts/entity/tactical/enemies/rf_bandit_pillager_tough"
}), {
	XP = 225,
	ActionPoints = 9,
	Hitpoints = 110,
	Bravery = 60,
	Stamina = 115,
	MeleeSkill = 65,
	RangedSkill = 45,
	MeleeDefense = 0,
	RangedDefense = 0,
	Initiative = 70,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.addTroopAndActor("RF_BanditRaiderTough", ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.BanditRaider, {
	Script = "scripts/entity/tactical/enemies/rf_bandit_raider_tough"
}), {
	XP = 300,
	ActionPoints = 9,
	Hitpoints = 130,
	Bravery = 70,
	Stamina = 120,
	MeleeSkill = 72,
	RangedSkill = 45,
	MeleeDefense = 5,
	RangedDefense = 0,
	Initiative = 75,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.addTroopAndActor("RF_BanditMarauderTough", ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_BanditMarauder, {
	Script = "scripts/entity/tactical/enemies/rf_bandit_marauder_tough"
}), {
	XP = 350,
	ActionPoints = 9,
	Hitpoints = 150,
	Bravery = 80,
	Stamina = 125,
	MeleeSkill = 80,
	RangedSkill = 45,
	MeleeDefense = 15,
	RangedDefense = 0,
	Initiative = 80,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.addEntity("RF_BanditVandal", "强盗破坏者", "强盗破坏者", "rf_bandit_vandal_orientation", ::Const.FactionType.Bandits, ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_BanditPillager, {
	Script = "scripts/entity/tactical/enemies/rf_bandit_vandal"
}), {
	XP = 225,
	ActionPoints = 9,
	Hitpoints = 60,
	Bravery = 45,
	Stamina = 100,
	MeleeSkill = 65,
	RangedSkill = 55,
	MeleeDefense = 0,
	RangedDefense = 0,
	Initiative = 110,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.RF_BanditMarauder + 1);
::Reforged.Entities.addEntity("RF_BanditOutlaw", "强盗亡命徒", "强盗亡命徒", "rf_bandit_outlaw_orientation", ::Const.FactionType.Bandits, ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.BanditRaider, {
	Script = "scripts/entity/tactical/enemies/rf_bandit_outlaw"
}), {
	XP = 300,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 55,
	Stamina = 110,
	MeleeSkill = 72,
	RangedSkill = 60,
	MeleeDefense = 10,
	RangedDefense = 5,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.RF_BanditVandal + 1);
::Reforged.Entities.addEntity("RF_BanditHighwayman", "强盗拦路徒", "强盗拦路徒", "rf_bandit_highwayman_orientation", ::Const.FactionType.Bandits, ::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_BanditMarauder, {
	Script = "scripts/entity/tactical/enemies/rf_bandit_highwayman"
}), {
	XP = 350,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 60,
	Stamina = 120,
	MeleeSkill = 80,
	RangedSkill = 70,
	MeleeDefense = 15,
	RangedDefense = 10,
	Initiative = 130,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.RF_BanditOutlaw + 1);
::Reforged.Entities.editEntity("BanditPoacher", null, {
	XP = 175,
	ActionPoints = 9,
	Hitpoints = 55,
	Bravery = 40,
	Stamina = 95,
	MeleeSkill = 50,
	RangedSkill = 50,
	MeleeDefense = 0,
	RangedDefense = 5,
	Initiative = 95,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.editEntity("BanditMarksman", {
	Cost = 19,
	Strength = 19
}, {
	XP = 225,
	ActionPoints = 9,
	Hitpoints = 60,
	Bravery = 50,
	Stamina = 105,
	MeleeSkill = 50,
	RangedSkill = 65,
	MeleeDefense = 0,
	RangedDefense = 10,
	Initiative = 110,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, function ()
{
	::Const.EntityIcon[::Const.EntityType.BanditMarksman] = "rf_bandit_marksman_orientation";
});
::Reforged.Entities.addEntity("RF_BanditSharpshooter", "强盗神射手", "强盗神射手", "rf_bandit_sharpshooter_orientation", ::Const.FactionType.Bandits, {
	Variant = 0,
	Strength = 26,
	Cost = 26,
	Row = 1,
	Script = "scripts/entity/tactical/enemies/rf_bandit_sharpshooter"
}, {
	XP = 275,
	ActionPoints = 9,
	Hitpoints = 65,
	Bravery = 55,
	Stamina = 115,
	MeleeSkill = 55,
	RangedSkill = 70,
	MeleeDefense = 5,
	RangedDefense = 15,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.BanditMarksman + 1);
::Reforged.Entities.editEntity("BanditLeader", {
	Cost = 31,
	Strength = 40
}, {
	XP = 400,
	ActionPoints = 9,
	Hitpoints = 100,
	Bravery = 80,
	Stamina = 130,
	MeleeSkill = 80,
	RangedSkill = 45,
	MeleeDefense = 20,
	RangedDefense = 5,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.addEntity("RF_BanditBaron", "强盗男爵", "强盗男爵", "rf_bandit_baron_orientation", ::Const.FactionType.Bandits, {
	Variant = 1,
	Strength = 50,
	Cost = 40,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_bandit_baron",
	NameList = ::Const.Strings.BanditLeaderNames,
	TitleList = null
}, {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 120,
	Bravery = 100,
	Stamina = 150,
	MeleeSkill = 90,
	RangedSkill = 45,
	MeleeDefense = 30,
	RangedDefense = 0,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.BanditLeader + 1);
::Reforged.Entities.editEntity("战犬", null, {
	XP = 75,
	ActionPoints = 12,
	Hitpoints = 50,
	Bravery = 50,
	Stamina = 130,
	MeleeSkill = 55,
	RangedSkill = 0,
	MeleeDefense = 25,
	RangedDefense = 30,
	Initiative = 130,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.editEntity("战獒", null, {
	XP = 100,
	ActionPoints = 11,
	Hitpoints = 70,
	Bravery = 60,
	Stamina = 140,
	MeleeSkill = 60,
	RangedSkill = 0,
	MeleeDefense = 20,
	RangedDefense = 20,
	Initiative = 110,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.editEntity("BanditRaiderWolf", {
	Cost = 25,
	Strength = 30
});
