local units = [
	{
		ID = "Unit.RF.NomadCutthroat",
		Troop = "NomadCutthroat",
		Figure = "figure_nomad_01"
	},
	{
		ID = "Unit.RF.NomadSlinger",
		Troop = "NomadSlinger",
		Figure = "figure_nomad_03"
	},
	{
		ID = "Unit.RF.NomadOutlaw",
		Troop = "NomadOutlaw",
		Figure = "figure_nomad_02"
	},
	{
		ID = "Unit.RF.NomadArcher",
		Troop = "NomadArcher",
		Figure = "figure_nomad_04"
	},
	{
		ID = "Unit.RF.NomadLeader",
		Troop = "NomadLeader",
		Figure = "figure_nomad_05"
	},
	{
		ID = "Unit.RF.DesertStalker",
		Troop = "DesertStalker",
		Figure = "figure_nomad_05"
	},
	{
		ID = "Unit.RF.Executioner",
		Troop = "处决者",
		Figure = "figure_nomad_05"
	},
	{
		ID = "Unit.RF.DesertDevil",
		Troop = "DesertDevil",
		Figure = "figure_nomad_05"
	}
];

foreach( unitDef in units )
{
	::Reforged.Spawns.Units[unitDef.ID] <- unitDef;
}
