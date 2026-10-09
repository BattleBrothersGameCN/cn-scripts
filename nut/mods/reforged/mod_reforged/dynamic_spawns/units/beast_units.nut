local units = [
	{
		ID = "Unit.RF.Direwolf",
		Troop = "恐狼",
		Figure = "figure_werewolf_01"
	},
	{
		ID = "Unit.RF.DirewolfHIGH",
		Troop = "DirewolfHIGH",
		Figure = "figure_werewolf_01",
		StartingResourceMin = 125
	},
	{
		ID = "Unit.RF.GhoulLOW",
		Troop = "GhoulLOW",
		Figure = "figure_ghoul_01"
	},
	{
		ID = "Unit.RF.Ghoul",
		Troop = "Ghoul",
		Figure = "figure_ghoul_01",
		StartingResourceMin = 150
	},
	{
		ID = "Unit.RF.GhoulHIGH",
		Troop = "GhoulHIGH",
		Figure = "figure_ghoul_02",
		StartingResourceMin = 220
	},
	{
		ID = "Unit.RF.Lindwurm",
		Troop = "林德蠕龙",
		Figure = "figure_lindwurm_01"
	},
	{
		ID = "Unit.RF.Unhold",
		Troop = "巨魔",
		Figure = "figure_unhold_01"
	},
	{
		ID = "Unit.RF.UnholdFrost",
		Troop = "UnholdFrost",
		Figure = "figure_unhold_02"
	},
	{
		ID = "Unit.RF.UnholdBog",
		Troop = "UnholdBog",
		Figure = "figure_unhold_03"
	},
	{
		ID = "Unit.RF.Spider",
		Troop = "Spider",
		Figure = "figure_spider_01"
	},
	{
		ID = "Unit.RF.Alp",
		Troop = "梦魇",
		Figure = "figure_alp_01"
	},
	{
		ID = "Unit.RF.Schrat",
		Troop = "树人",
		Figure = "figure_schrat_01"
	},
	{
		ID = "Unit.RF.Kraken",
		Troop = "克拉肯"
	},
	{
		ID = "Unit.RF.Hyena",
		Troop = "鬣狗",
		Figure = "figure_hyena_01"
	},
	{
		ID = "Unit.RF.HyenaHIGH",
		Troop = "HyenaHIGH",
		Figure = "figure_hyena_01",
		StartingResourceMin = 125
	},
	{
		ID = "Unit.RF.Serpent",
		Troop = "大蛇",
		Figure = "figure_serpent_01"
	},
	{
		ID = "Unit.RF.SandGolem",
		Troop = "SandGolem",
		Figure = "figure_golem_01"
	},
	{
		ID = "Unit.RF.SandGolemMEDIUM",
		Troop = "SandGolemMEDIUM",
		Figure = "figure_golem_01",
		Cost = 42
	},
	{
		ID = "Unit.RF.SandGolemHIGH",
		Troop = "SandGolemHIGH",
		Figure = "figure_golem_02",
		Cost = 129
	},
	{
		ID = "Unit.RF.Hexe",
		Troop = "女巫",
		Figure = "figure_hexe_01"
	},
	{
		ID = "Unit.RF.HexeOneSpider",
		Troop = "女巫",
		Figure = "figure_hexe_01",
		Cost = 50,
		StaticDefs = {
			Parties = [
				{
					BaseID = "SpiderBodyguards",
					HardMin = 1,
					HardMax = 1
				}
			]
		}
	},
	{
		ID = "Unit.RF.HexeTwoSpider",
		Troop = "女巫",
		Figure = "figure_hexe_01",
		Cost = 50,
		StaticDefs = {
			Parties = [
				{
					BaseID = "SpiderBodyguards",
					HardMin = 2,
					HardMax = 2
				}
			]
		}
	},
	{
		ID = "Unit.RF.HexeOneDirewolf",
		Troop = "女巫",
		Figure = "figure_hexe_01",
		Cost = 50,
		StaticDefs = {
			Parties = [
				{
					BaseID = "DirewolfBodyguards",
					HardMin = 1,
					HardMax = 1
				}
			]
		}
	},
	{
		ID = "Unit.RF.HexeTwoDirewolf",
		Troop = "女巫",
		Figure = "figure_hexe_01",
		Cost = 50,
		StaticDefs = {
			Parties = [
				{
					BaseID = "DirewolfBodyguards",
					HardMin = 2,
					HardMax = 2
				}
			]
		}
	},
	{
		ID = "Unit.RF.SpiderBodyguard",
		Troop = "SpiderBodyguard"
	},
	{
		ID = "Unit.RF.DirewolfBodyguard",
		Troop = "DirewolfBodyguard"
	}
];

foreach( unitDef in units )
{
	::Reforged.Spawns.Units[unitDef.ID] <- unitDef;
}
