local units = [
	{
		ID = "Unit.RF.Peasant",
		Troop = "农民",
		Figure = "figure_civilian_01"
	},
	{
		ID = "Unit.RF.PeasantArmed",
		Troop = "PeasantArmed",
		Figure = "figure_civilian_01"
	},
	{
		ID = "Unit.RF.SouthernPeasant",
		Troop = "SouthernPeasant"
	},
	{
		ID = "Unit.RF.CultistAmbush",
		Troop = "CultistAmbush",
		Figure = "figure_civilian_03"
	},
	{
		ID = "Unit.RF.NorthernSlave",
		Troop = "NorthernSlave"
	},
	{
		ID = "Unit.RF.CaravanHand",
		Troop = "CaravanHand"
	},
	{
		ID = "Unit.RF.CaravanGuard",
		Troop = "CaravanGuard"
	},
	{
		ID = "Unit.RF.CaravanDonkey",
		Troop = "CaravanDonkey",
		Cost = 0,
		Figure = "cart_02"
	},
	{
		ID = "Unit.RF.Militia",
		Troop = "民兵"
	},
	{
		ID = "Unit.RF.MilitiaRanged",
		Troop = "MilitiaRanged"
	},
	{
		ID = "Unit.RF.MilitiaVeteran",
		Troop = "MilitiaVeteran"
	},
	{
		ID = "Unit.RF.MilitiaCaptain",
		Troop = "MilitiaCaptain"
	},
	{
		ID = "Unit.RF.BountyHunter",
		Troop = "BountyHunter"
	},
	{
		ID = "Unit.RF.BountyHunterRanged",
		Troop = "BountyHunterRanged"
	},
	{
		ID = "Unit.RF.Wardog",
		Troop = "战犬"
	},
	{
		ID = "Unit.RF.Mercenary",
		Troop = "雇佣兵"
	},
	{
		ID = "Unit.RF.MercenaryRanged",
		Troop = "MercenaryRanged"
	},
	{
		ID = "Unit.RF.MasterArcher",
		Troop = "MasterArcher"
	},
	{
		ID = "Unit.RF.HedgeKnight",
		Troop = "HedgeKnight"
	},
	{
		ID = "Unit.RF.Swordmaster",
		Troop = "剑术大师"
	}
];

foreach( unitDef in units )
{
	::Reforged.Spawns.Units[unitDef.ID] <- unitDef;
}
