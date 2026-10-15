local units = [
	{
		ID = "Unit.RF.Footman",
		Troop = "步兵",
		Figure = "figure_noble_01"
	},
	{
		ID = "Unit.RF.Billman",
		Troop = "钩镰兵",
		Figure = "figure_noble_01"
	},
	{
		ID = "Unit.RF.Arbalester",
		Troop = "弩手",
		Figure = "figure_noble_01"
	},
	{
		ID = "Unit.RF.ArmoredWardog",
		Troop = "ArmoredWardog",
		StartingResourceMin = 126
	},
	{
		ID = "Unit.RF.StandardBearer",
		Troop = "StandardBearer",
		Figure = "figure_noble_02",
		StartingResourceMin = 185
	},
	{
		ID = "Unit.RF.Sergeant",
		Troop = "军士",
		Figure = "figure_noble_02",
		StartingResourceMin = 185
	},
	{
		ID = "Unit.RF.Greatsword",
		Troop = "大剑",
		Figure = "figure_noble_02",
		StartingResourceMin = 350
	},
	{
		ID = "Unit.RF.Knight",
		Troop = "骑士",
		Figure = "figure_noble_03",
		StartingResourceMin = 350,
		StaticDefs = {
			Units = [
				{
					BaseID = "Unit.RF.RF_Squire"
				}
			]
		}
	},
	{
		ID = "Unit.RF.NobleCaravanDonkey",
		Troop = "CaravanDonkey",
		Cost = 0,
		Figure = "cart_01"
	},
	{
		ID = "Unit.RF.RF_FootmanHeavy",
		Troop = "RF_FootmanHeavy",
		Figure = "figure_noble_02",
		StartingResourceMin = 300
	},
	{
		ID = "Unit.RF.RF_BillmanHeavy",
		Troop = "RF_BillmanHeavy",
		Figure = "figure_noble_02",
		StartingResourceMin = 300
	},
	{
		ID = "Unit.RF.RF_ArbalesterHeavy",
		Troop = "RF_ArbalesterHeavy",
		Figure = "figure_noble_01",
		StartingResourceMin = 300
	},
	{
		ID = "Unit.RF.RF_ManAtArms",
		Troop = "RF_ManAtArms",
		Figure = "figure_noble_02",
		StartingResourceMin = 300
	},
	{
		ID = "Unit.RF.RF_Fencer",
		Troop = "RF_Fencer",
		Figure = "figure_noble_01",
		StartingResourceMin = 350
	},
	{
		ID = "Unit.RF.RF_Herald",
		Troop = "RF_Herald",
		Figure = "figure_noble_02",
		StartingResourceMin = 350,
		StaticDefs = {
			Units = [
				{
					BaseID = "Unit.RF.RF_HeraldsBodyguard"
				},
				{
					BaseID = "Unit.RF.RF_HeraldsBodyguard"
				}
			]
		}
	},
	{
		ID = "Unit.RF.RF_Marshal",
		Troop = "RF_Marshal",
		Figure = "figure_noble_02",
		StartingResourceMin = 350
	},
	{
		ID = "Unit.RF.RF_KnightAnointed",
		Troop = "RF_KnightAnointed",
		Figure = "figure_noble_03",
		StartingResourceMin = 450,
		StaticDefs = {
			Units = [
				{
					BaseID = "Unit.RF.RF_Squire"
				},
				{
					BaseID = "Unit.RF.RF_Squire"
				}
			]
		}
	},
	{
		ID = "Unit.RF.RF_HeraldsBodyguard",
		Troop = "RF_HeraldsBodyguard",
		Figure = "figure_noble_02"
	},
	{
		ID = "Unit.RF.RF_Squire",
		Troop = "RF_Squire",
		Figure = "figure_noble_01"
	}
];

foreach( unitDef in units )
{
	::Reforged.Spawns.Units[unitDef.ID] <- unitDef;
}
