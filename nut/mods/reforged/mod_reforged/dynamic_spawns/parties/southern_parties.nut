local parties = [
	{
		ID = "Southern",
		HardMin = 5,
		DefaultFigure = "figure_southern_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.SouthernFrontline",
					RatioMin = 0.4,
					RatioMax = 0.8,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * 0.8;
					}

				},
				{
					BaseID = "UnitBlock.RF.SouthernBackline",
					RatioMin = 0.0,
					RatioMax = 0.4,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * (this.getParty().getStartingResources() >= 250 ? 0.7 : 0.3);
					}

				},
				{
					BaseID = "UnitBlock.RF.SouthernRanged",
					RatioMin = 0.0,
					RatioMax = 0.3,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * (this.getParty().getStartingResources() >= 225 ? 0.7 : 0.2);
					}

				},
				{
					BaseID = "UnitBlock.RF.Assassin",
					RatioMin = 0.0,
					RatioMax = 0.35,
					PartySizeMin = 7,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * 0.15;
					}

				},
				{
					BaseID = "UnitBlock.RF.Officer",
					RatioMin = 0.0,
					RatioMax = 0.15,
					PartySizeMin = 5,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * 0.7;
					}

					function onBeforeSpawnStart()
					{
						this.HardMax = ::Math.floor(this.getTopParty().getStartingResources() / 175);
					}

				},
				{
					BaseID = "UnitBlock.RF.Siege",
					RatioMin = 0.0,
					RatioMax = 0.13,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * 0.5;
					}

					function onBeforeSpawnStart()
					{
						this.HardMax = ::Math.floor(this.getTopParty().getStartingResources() / 220);
					}

				},
				{
					BaseID = "UnitBlock.RF.Slave",
					RatioMin = 0.3,
					RatioMax = 0.7,
					StartingResourceMin = 300,
					ExclusionChance = 90,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * 5.0;
					}

				}
			]
		}
	},
	{
		ID = "CaravanSouthern",
		HardMin = 10,
		DefaultFigure = "cart_03",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
		StaticDefs = {
			Units = [
				{
					BaseID = "Unit.RF.SouthernDonkey"
				}
			]
		},
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.SouthernFrontline",
					RatioMin = 0.15,
					RatioMax = 1.0,
					DeterminesFigure = false
				},
				{
					BaseID = "UnitBlock.RF.Slave",
					RatioMin = 0.1,
					RatioMax = 0.4,
					ExclusionChance = 75,
					DeterminesFigure = false,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * 3.0;
					}

				},
				{
					BaseID = "UnitBlock.RF.SouthernBackline",
					RatioMin = 0.1,
					RatioMax = 0.4,
					DeterminesFigure = false
				},
				{
					BaseID = "UnitBlock.RF.Officer",
					RatioMin = 0.0,
					RatioMax = 0.08,
					PartySizeMin = 14,
					DeterminesFigure = false
				},
				{
					BaseID = "UnitBlock.RF.SouthernCaravanDonkey",
					RatioMin = 0.01,
					RatioMax = 0.12,
					PartySizeMin = 14
				}
			]
		}
	},
	{
		ID = "CaravanSouthernEscort",
		HardMin = 2,
		DefaultFigure = "cart_03",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
		StaticDefs = {
			Units = [
				{
					BaseID = "Unit.RF.SouthernDonkey"
				}
			]
		},
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.SouthernFrontline",
					RatioMin = 0.35,
					RatioMax = 1.0,
					DeterminesFigure = false
				},
				{
					BaseID = "UnitBlock.RF.SouthernCaravanDonkey",
					RatioMin = 0.35,
					RatioMax = 0.5,
					PartySizeMin = 3,
					HardMax = 2
				}
			]
		}
	},
	{
		ID = "Slaves",
		HardMin = 6,
		DefaultFigure = "figure_slave_01",
		MovementSpeedMult = 0.66,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.Slave",
					RatioMin = 0.0,
					RatioMax = 1.0
				}
			]
		}
	},
	{
		ID = "NorthernSlaves",
		HardMin = 6,
		DefaultFigure = "figure_slave_01",
		MovementSpeedMult = 0.66,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.Slave",
					RatioMin = 0.0,
					RatioMax = 1.0
				}
			]
		}
	},
	{
		ID = "Assassins",
		HardMin = 3,
		DefaultFigure = "figure_southern_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.Assassin",
					RatioMin = 0.0,
					RatioMax = 1.0
				}
			]
		}
	},
	{
		ID = "MortarEngineers",
		HardMin = 2,
		HardMax = 2,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.Engineer"
				}
			]
		}
	}
];

foreach( partyDef in parties )
{
	::Reforged.Spawns.Parties[partyDef.ID] <- partyDef;
}
