::Reforged.Entities.editEntity("Footman", {
	Strength = 25
}, {
	XP = 250,
	ActionPoints = 9,
	Hitpoints = 75,
	Bravery = 60,
	Stamina = 120,
	MeleeSkill = 75,
	RangedSkill = 50,
	MeleeDefense = 10,
	RangedDefense = 5,
	Initiative = 110,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.addEntity("RF_FootmanHeavy", "重步兵", "重步兵", "rf_footman_heavy_orientation", ::Const.FactionType.NobleHouse, {
	Variant = 0,
	Strength = 40,
	Cost = 28,
	Row = 0,
	Script = "scripts/entity/tactical/humans/rf_footman_heavy"
}, {
	XP = 325,
	ActionPoints = 9,
	Hitpoints = 85,
	Bravery = 70,
	Stamina = 130,
	MeleeSkill = 80,
	RangedSkill = 50,
	MeleeDefense = 15,
	RangedDefense = 10,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.Footman + 1);
::Reforged.Entities.editEntity("Billman", {
	Strength = 25
}, {
	XP = 250,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 60,
	Stamina = 100,
	MeleeSkill = 75,
	RangedSkill = 50,
	MeleeDefense = 10,
	RangedDefense = 10,
	Initiative = 100,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.addEntity("RF_BillmanHeavy", "戟兵", "戟兵", "rf_billman_heavy_orientation", ::Const.FactionType.NobleHouse, {
	Variant = 0,
	Strength = 40,
	Cost = 28,
	Row = 1,
	Script = "scripts/entity/tactical/humans/rf_billman_heavy"
}, {
	XP = 325,
	ActionPoints = 9,
	Hitpoints = 80,
	Bravery = 70,
	Stamina = 120,
	MeleeSkill = 80,
	RangedSkill = 50,
	MeleeDefense = 10,
	RangedDefense = 15,
	Initiative = 110,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.Billman + 1);
::Reforged.Entities.editEntity("Arbalester", {
	Strength = 25
}, {
	XP = 250,
	ActionPoints = 9,
	Hitpoints = 60,
	Bravery = 60,
	Stamina = 100,
	MeleeSkill = 55,
	RangedSkill = 70,
	MeleeDefense = 5,
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
	::Const.Strings.EntityName[::Const.EntityType.Arbalester] = "弩手";
	::Const.Strings.EntityNamePlural[::Const.EntityType.Arbalester] = "弩手";
});
::Reforged.Entities.addEntity("RF_ArbalesterHeavy", "劲弩手", "劲弩手", "rf_arbalester_heavy_orientation", ::Const.FactionType.NobleHouse, {
	Variant = 0,
	Strength = 40,
	Cost = 28,
	Row = 1,
	Script = "scripts/entity/tactical/humans/rf_arbalester_heavy"
}, {
	XP = 325,
	ActionPoints = 9,
	Hitpoints = 70,
	Bravery = 60,
	Stamina = 110,
	MeleeSkill = 55,
	RangedSkill = 70,
	MeleeDefense = 5,
	RangedDefense = 10,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.Arbalester + 1);
::Reforged.Entities.addEntity("RF_ManAtArms", "重装兵", "重装兵", "rf_man_at_arms_orientation", ::Const.FactionType.NobleHouse, {
	Variant = 1,
	Strength = 35,
	Cost = 30,
	Row = 1,
	Script = "scripts/entity/tactical/humans/rf_man_at_arms",
	NameList = ::Const.Strings.CharacterNames,
	TitleList = ::Const.Strings.RF_ManAtArmsTitles
}, {
	XP = 400,
	ActionPoints = 9,
	Hitpoints = 90,
	Bravery = 70,
	Stamina = 120,
	MeleeSkill = 85,
	RangedSkill = 50,
	MeleeDefense = 20,
	RangedDefense = 0,
	Initiative = 110,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.Greatsword + 1);
::Reforged.Entities.editEntity("Greatsword", {
	Strength = 35,
	Cost = 30,
	Variant = 1,
	NameList = ::Const.Strings.CharacterNames,
	TitleList = ::Const.Strings.RF_ZweihanderTitles
}, {
	XP = 400,
	ActionPoints = 9,
	Hitpoints = 90,
	Bravery = 70,
	Stamina = 115,
	MeleeSkill = 85,
	RangedSkill = 50,
	MeleeDefense = 20,
	RangedDefense = 0,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.addEntity("RF_Fencer", "击剑手", "击剑手", "rf_fencer_orientation", ::Const.FactionType.NobleHouse, {
	Variant = 1,
	Strength = 35,
	Cost = 30,
	Row = 1,
	Script = "scripts/entity/tactical/humans/rf_fencer",
	NameList = ::Const.Strings.CharacterNames,
	TitleList = ::Const.Strings.RF_FencerTitles
}, {
	XP = 400,
	ActionPoints = 9,
	Hitpoints = 60,
	Bravery = 70,
	Stamina = 120,
	MeleeSkill = 85,
	RangedSkill = 50,
	MeleeDefense = 20,
	RangedDefense = 0,
	Initiative = 130,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.RF_ManAtArms + 1);
::Reforged.Entities.editEntity("Knight", {
	Strength = 45
}, {
	XP = 450,
	ActionPoints = 9,
	Hitpoints = 135,
	Bravery = 100,
	Stamina = 150,
	MeleeSkill = 95,
	RangedSkill = 60,
	MeleeDefense = 25,
	RangedDefense = 5,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
::Reforged.Entities.addEntity("RF_KnightAnointed", "受膏骑士", "受膏骑士", "rf_knight_anointed_orientation", ::Const.FactionType.NobleHouse, {
	Variant = 2,
	Strength = 60,
	Cost = 45,
	Row = 2,
	Script = "scripts/entity/tactical/humans/rf_knight_anointed",
	NameList = ::Const.Strings.RF_KnightAnointedNames,
	TitleList = null
}, {
	XP = 600,
	ActionPoints = 9,
	Hitpoints = 150,
	Bravery = 120,
	Stamina = 170,
	MeleeSkill = 100,
	RangedSkill = 60,
	MeleeDefense = 25,
	RangedDefense = 10,
	Initiative = 125,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.Knight + 1);
::Reforged.Entities.addEntity("RF_Squire", "扈从", "扈从", "rf_squire_orientation", ::Const.FactionType.NobleHouse, {
	Variant = 0,
	Strength = 25,
	Cost = 20,
	Row = 2,
	Script = "scripts/entity/tactical/humans/rf_squire"
}, {
	XP = 275,
	ActionPoints = 9,
	Hitpoints = 80,
	Bravery = 60,
	Stamina = 120,
	MeleeSkill = 65,
	RangedSkill = 50,
	MeleeDefense = 10,
	RangedDefense = 0,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.RF_KnightAnointed + 1);
::Reforged.Entities.editEntity("Sergeant", {
	Strength = 40
}, {
	XP = 350,
	ActionPoints = 9,
	Hitpoints = 130,
	Bravery = 80,
	Stamina = 130,
	MeleeSkill = 80,
	RangedSkill = 60,
	MeleeDefense = 25,
	RangedDefense = 15,
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
	::Const.EntityIcon[::Const.EntityType.Sergeant] = "rf_sergeant_orientation";
});
::Reforged.Entities.addEntity("RF_Marshal", "元帅", "元帅", "rf_marshal_orientation", ::Const.FactionType.NobleHouse, {
	Variant = 0,
	Strength = 50,
	Cost = 40,
	Row = 1,
	Script = "scripts/entity/tactical/humans/rf_marshal"
}, {
	XP = 475,
	ActionPoints = 9,
	Hitpoints = 160,
	Bravery = 100,
	Stamina = 140,
	MeleeSkill = 90,
	RangedSkill = 60,
	MeleeDefense = 30,
	RangedDefense = 20,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.Sergeant + 1);
::Reforged.Entities.editEntity("StandardBearer", {
	Row = 3
}, {
	XP = 250,
	ActionPoints = 9,
	Hitpoints = 80,
	Bravery = 90,
	Stamina = 115,
	MeleeSkill = 65,
	RangedSkill = 50,
	MeleeDefense = 10,
	RangedDefense = 10,
	Initiative = 105,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, function ()
{
	::Const.EntityIcon[::Const.EntityType.StandardBearer] = "rf_standard_bearer_orientation";
});
::Reforged.Entities.addEntity("RF_Herald", "传令官", "传令官", "rf_herald_orientation", ::Const.FactionType.NobleHouse, {
	Variant = 0,
	Strength = 30,
	Cost = 30,
	Row = 2,
	Script = "scripts/entity/tactical/humans/rf_herald"
}, {
	XP = 350,
	ActionPoints = 9,
	Hitpoints = 80,
	Bravery = 90,
	Stamina = 125,
	MeleeSkill = 75,
	RangedSkill = 50,
	MeleeDefense = 15,
	RangedDefense = 15,
	Initiative = 115,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.StandardBearer + 1);
::Reforged.Entities.addEntity("RF_HeraldsBodyguard", "传令官侍卫", "传令官侍卫", "rf_heralds_bodyguard_orientation", ::Const.FactionType.NobleHouse, {
	Variant = 0,
	Strength = 40,
	Cost = 30,
	Row = 2,
	Script = "scripts/entity/tactical/humans/rf_heralds_bodyguard"
}, {
	XP = 475,
	ActionPoints = 9,
	Hitpoints = 120,
	Bravery = 90,
	Stamina = 140,
	MeleeSkill = 90,
	RangedSkill = 60,
	MeleeDefense = 20,
	RangedDefense = 0,
	Initiative = 130,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
}, ::Const.EntityType.RF_Herald + 1);
::Reforged.Entities.editEntity("Noble", null, {
	XP = 300,
	ActionPoints = 9,
	Hitpoints = 75,
	Bravery = 75,
	Stamina = 125,
	MeleeSkill = 75,
	RangedSkill = 60,
	MeleeDefense = 10,
	RangedDefense = 10,
	Initiative = 120,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 15
});
