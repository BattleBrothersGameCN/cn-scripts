local units = [
	{
		ID = "Unit.RF.Conscript",
		Troop = "征召兵",
		Figure = "figure_southern_01"
	},
	{
		ID = "Unit.RF.Conscript_Polearm",
		Troop = "ConscriptPolearm"
	},
	{
		ID = "Unit.RF.Officer",
		Troop = "军官",
		Figure = "figure_southern_02",
		StartingResourceMin = 280
	},
	{
		ID = "Unit.RF.Gunner",
		Troop = "炮手"
	},
	{
		ID = "Unit.RF.Engineer",
		Troop = "工程师"
	},
	{
		ID = "Unit.RF.Mortar",
		Troop = "臼炮",
		StartingResourceMin = 280,
		StaticDefs = {
			Parties = [
				{
					BaseID = "MortarEngineers"
				}
			]
		}
	},
	{
		ID = "Unit.RF.Assassin",
		Troop = "刺客",
		StartingResourceMin = 200
	},
	{
		ID = "Unit.RF.Slave",
		Troop = "Slave"
	},
	{
		ID = "Unit.RF.SouthernDonkey",
		Troop = "SouthernDonkey",
		Figure = "cart_03",
		Cost = 10
	}
];

foreach( unitDef in units )
{
	::Reforged.Spawns.Units[unitDef.ID] <- unitDef;
}
