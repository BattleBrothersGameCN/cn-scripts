local units = [
	{
		ID = "Unit.RF.Zombie",
		Troop = "Zombie",
		Figure = "figure_zombie_01"
	},
	{
		ID = "Unit.RF.ZombieYeoman",
		Troop = "ZombieYeoman",
		Figure = "figure_zombie_02",
		StartingResourceMin = 50
	},
	{
		ID = "Unit.RF.ZombieKnight",
		Troop = "ZombieKnight",
		Figure = "figure_zombie_03",
		StartingResourceMin = 115
	},
	{
		ID = "Unit.RF.RF_ZombieHero",
		Troop = "RF_ZombieHero",
		Figure = "figure_zombie_03",
		StartingResourceMin = 200
	},
	{
		ID = "Unit.RF.ZombieNomad",
		Troop = "ZombieNomad",
		Figure = "figure_zombie_03"
	},
	{
		ID = "Unit.RF.Necromancer",
		Troop = "死灵法师",
		Figure = [
			"figure_necromancer_01",
			"figure_necromancer_02"
		]
	},
	{
		ID = "Unit.RF.RF_ZombieOrcYoung",
		Troop = "RF_ZombieOrcYoung"
	},
	{
		ID = "Unit.RF.RF_ZombieOrcWarrior",
		Troop = "RF_ZombieOrcWarrior",
		StartingResourceMin = 150
	},
	{
		ID = "Unit.RF.RF_ZombieOrcBerserker",
		Troop = "RF_ZombieOrcBerserker",
		StartingResourceMin = 175
	},
	{
		ID = "Unit.RF.RF_ZombieOrcWarlord",
		Troop = "RF_ZombieOrcWarlord",
		StartingResourceMin = 235
	},
	{
		ID = "Unit.RF.NecromancerWithBodyguards",
		Troop = "死灵法师",
		Figure = [
			"figure_necromancer_01",
			"figure_necromancer_02"
		],
		StartingResourceMin = 100,
		Cost = 30,
		StaticDefs = {
			Parties = [
				{
					BaseID = "NecromancerBodyguards"
				}
			]
		}
	},
	{
		ID = "Unit.RF.NecromancerWithBodyguardsNomad",
		Troop = "死灵法师",
		Figure = [
			"figure_necromancer_01",
			"figure_necromancer_02"
		],
		StartingResourceMin = 100,
		Cost = 30,
		StaticDefs = {
			Parties = [
				{
					BaseID = "NecromancerBodyguardsNomad"
				}
			]
		}
	},
	{
		ID = "Unit.RF.NecromancerWithBodyguardsOrc",
		Troop = "死灵法师",
		Figure = [
			"figure_necromancer_01",
			"figure_necromancer_02"
		],
		StartingResourceMin = 100,
		Cost = 30,
		StaticDefs = {
			Parties = [
				{
					BaseID = "NecromancerBodyguardsOrc"
				}
			]
		}
	},
	{
		ID = "Unit.RF.ZombieBodyguard",
		Troop = "ZombieBodyguard",
		Figure = "figure_zombie_02"
	},
	{
		ID = "Unit.RF.ZombieYeomanBodyguard",
		Troop = "ZombieYeomanBodyguard",
		Figure = "figure_zombie_02"
	},
	{
		ID = "Unit.RF.ZombieKnightBodyguard",
		Troop = "ZombieKnightBodyguard",
		Figure = "figure_zombie_03",
		StartingResourceMin = 175
	},
	{
		ID = "Unit.RF.RF_ZombieHeroBodyguard",
		Troop = "RF_ZombieHeroBodyguard",
		Figure = "figure_zombie_03",
		StartingResourceMin = 250
	},
	{
		ID = "Unit.RF.ZombieNomadBodyguard",
		Troop = "ZombieNomadBodyguard",
		Figure = "figure_zombie_03"
	},
	{
		ID = "Unit.RF.RF_ZombieOrcYoungBodyguard",
		Troop = "RF_ZombieOrcYoungBodyguard",
		Figure = "figure_zombie_03"
	},
	{
		ID = "Unit.RF.RF_ZombieOrcWarriorBodyguard",
		Troop = "RF_ZombieOrcWarriorBodyguard",
		Figure = "figure_zombie_03",
		StartingResourceMin = 150
	},
	{
		ID = "Unit.RF.Ghost",
		Troop = "幽灵",
		Figure = "figure_ghost_01"
	},
	{
		ID = "Unit.RF.RF_Hollenhund",
		Troop = "RF_Hollenhund",
		DeterminesFigure = false,
		StartingResourceMin = 200
	},
	{
		ID = "Unit.RF.RF_Banshee",
		Troop = "RF_Banshee",
		DeterminesFigure = false,
		StartingResourceMin = 230
	}
];

foreach( unitDef in units )
{
	::Reforged.Spawns.Units[unitDef.ID] <- unitDef;
}
