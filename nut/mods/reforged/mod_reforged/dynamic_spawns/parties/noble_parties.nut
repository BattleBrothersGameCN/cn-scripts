local parties = [
	{
		ID = "Noble",
		HardMin = 8,
		DefaultFigure = "figure_noble_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.NobleFrontline",
					RatioMin = 0.3,
					RatioMax = 1.0
				},
				{
					BaseID = "UnitBlock.RF.NobleBackline",
					RatioMax = 0.4,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * (this.getParty().getStartingResources() > 350 ? 1.8 : 1.4);
					}

				},
				{
					BaseID = "UnitBlock.RF.NobleRanged",
					RatioMax = 0.3,
					function getSpawnWeight()
					{
						if (this.getTopParty().getStartingResources() >= 330)
						{
							  // [006]  OP_GETBASE        1      0    0    0
							return $[stack offset 1].getSpawnWeight() * 2.0;
						}
						else
						{
							this.getTopParty().getStartingResources() >= 280;
						}

						  // [020]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * 1.2;
					}

				},
				{
					BaseID = "UnitBlock.RF.NobleElite",
					RatioMax = 0.2,
					function getSpawnWeight()
					{
						if (this.getTopParty().getStartingResources() >= 450)
						{
							  // [006]  OP_GETBASE        1      0    0    0
							return $[stack offset 1].getSpawnWeight() * 2.0;
						}
						else if (this.getTopParty().getStartingResources() >= 370)
						{
							  // [020]  OP_GETBASE        1      0    0    0
							return $[stack offset 1].getSpawnWeight() * 1.0;
						}
						else
						{
							  // [028]  OP_GETBASE        1      0    0    0
							return $[stack offset 1].getSpawnWeight() * 0.33;
						}
					}

				},
				{
					BaseID = "UnitBlock.RF.NobleSupport",
					RatioMax = 0.09,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * (this.getParty().getStartingResources() > 250 ? 3 : 0.5);
					}

				},
				{
					BaseID = "UnitBlock.RF.NobleOfficer",
					RatioMax = 0.1,
					function getSpawnWeight()
					{
						if (this.getTopParty().getStartingResources() > 500)
						{
							  // [006]  OP_GETBASE        1      0    0    0
							return $[stack offset 1].getSpawnWeight() * 3.0;
						}
						else if (this.getTopParty().getStartingResources() > 400)
						{
							  // [020]  OP_GETBASE        1      0    0    0
							return $[stack offset 1].getSpawnWeight() * 2.0;
						}
						else if (this.getTopParty().getStartingResources() > 250)
						{
							  // [034]  OP_GETBASE        1      0    0    0
							return $[stack offset 1].getSpawnWeight() * 0.6;
						}
						else
						{
							  // [042]  OP_GETBASE        1      0    0    0
							return $[stack offset 1].getSpawnWeight() * 0.2;
						}
					}

				},
				{
					BaseID = "UnitBlock.RF.NobleLeader",
					RatioMax = 0.08,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * (this.getParty().getStartingResources() > 450 ? 2 : 0.3);
					}

				},
				{
					BaseID = "UnitBlock.RF.NobleFlank",
					RatioMax = 0.25,
					HardMax = 3,
					ExclusionChance = 40,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * 0.75;
					}

				}
			]
		},
		function getUpgradeChance()
		{
			if (this.getTopParty().getStartingResources() >= 700)
			{
				return 80;
			}
			else
			{
				return 50;
			}
		}

	},
	{
		ID = "NobleCaravan",
		HardMin = 9,
		DefaultFigure = "cart_01",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
		StaticDefs = {
			Units = [
				"Unit.RF.NobleCaravanDonkey"
			]
		},
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.NobleFrontline",
					RatioMin = 0.4,
					RatioMax = 0.6,
					DeterminesFigure = false
				},
				{
					BaseID = "UnitBlock.RF.NobleBackline",
					RatioMin = 0.0,
					RatioMax = 0.4,
					DeterminesFigure = false
				},
				{
					BaseID = "UnitBlock.RF.NobleRanged",
					RatioMin = 0.0,
					RatioMax = 0.3,
					DeterminesFigure = false
				},
				{
					BaseID = "UnitBlock.RF.NobleElite",
					RatioMin = 0.0,
					RatioMax = 0.2,
					PartySizeMin = 16,
					DeterminesFigure = false
				},
				{
					BaseID = "UnitBlock.RF.NobleOfficer",
					RatioMin = 0.0,
					RatioMax = 0.05,
					PartySizeMin = 12,
					HardMax = 1,
					DeterminesFigure = false,
					function getSpawnWeight()
					{
						return ::Math.pow(this.getTopParty().getStartingResources() / 350, 1.5);
					}

				},
				{
					BaseID = "UnitBlock.RF.NobleDonkey",
					RatioMin = 0.01,
					RatioMax = 0.08,
					PartySizeMin = 13
				}
			]
		},
		function getUpgradeChance()
		{
			if (this.getTopParty().getStartingResources() >= 500)
			{
				return 80;
			}
			else
			{
				return 50;
			}
		}

	}
];

foreach( partyDef in parties )
{
	::Reforged.Spawns.Parties[partyDef.ID] <- partyDef;
}
