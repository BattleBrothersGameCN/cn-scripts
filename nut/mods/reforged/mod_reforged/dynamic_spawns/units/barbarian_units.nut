local units = [
	{
		ID = "Unit.RF.BarbarianThrall",
		Troop = "BarbarianThrall",
		Figure = "figure_wildman_01"
	},
	{
		ID = "Unit.RF.BarbarianMarauder",
		Troop = "BarbarianMarauder",
		Figure = "figure_wildman_02",
		StartingResourceMin = 75
	},
	{
		ID = "Unit.RF.BarbarianChampion",
		Troop = "BarbarianChampion",
		Figure = "figure_wildman_03",
		StartingResourceMin = 160
	},
	{
		ID = "Unit.RF.BarbarianDrummer",
		Troop = "BarbarianDrummer",
		StartingResourceMin = 170
	},
	{
		ID = "Unit.RF.BarbarianChosen",
		Troop = "BarbarianChosen",
		Figure = "figure_wildman_04"
	},
	{
		ID = "Unit.RF.Warhound",
		Troop = "战獒"
	},
	{
		ID = "Unit.RF.BarbarianUnhold",
		Troop = "BarbarianUnhold",
		Figure = "figure_unhold_01"
	},
	{
		ID = "Unit.RF.BarbarianUnholdFrost",
		Troop = "BarbarianUnholdFrost",
		Figure = "figure_unhold_02"
	},
	{
		ID = "Unit.RF.BarbarianBeastmasterU",
		Troop = "BarbarianBeastmaster",
		StartingResourceMin = 200,
		StaticDefs = {
			Parties = [
				{
					BaseID = "OneUnhold"
				}
			]
		}
	},
	{
		ID = "Unit.RF.BarbarianBeastmasterUU",
		Troop = "BarbarianBeastmaster",
		StartingResourceMin = 400,
		StaticDefs = {
			Parties = [
				{
					BaseID = "TwoUnhold"
				}
			]
		}
	},
	{
		ID = "Unit.RF.BarbarianBeastmasterF",
		Troop = "BarbarianBeastmaster",
		StartingResourceMin = 200,
		StaticDefs = {
			Parties = [
				{
					BaseID = "OneFrostUnhold"
				}
			]
		}
	},
	{
		ID = "Unit.RF.BarbarianBeastmasterFF",
		Troop = "BarbarianBeastmaster",
		StartingResourceMin = 430,
		StaticDefs = {
			Parties = [
				{
					BaseID = "TwoFrostUnhold"
				}
			]
		}
	}
];

foreach( unitDef in units )
{
	::Reforged.Spawns.Units[unitDef.ID] <- unitDef;
}
