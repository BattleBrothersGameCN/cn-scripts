local parties = [
	{
		ID = "Cultists",
		HardMin = 4,
		DefaultFigure = "figure_civilian_03",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.CultistAmbush",
					RatioMin = 0.0,
					RatioMax = 1.0
				}
			]
		}
	},
	{
		ID = "Peasants",
		HardMin = 3,
		DefaultFigure = "figure_civilian_01",
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.Peasant",
					RatioMin = 0.0,
					RatioMax = 1.0
				}
			]
		}
	},
	{
		ID = "PeasantsArmed",
		HardMin = 3,
		DefaultFigure = "figure_civilian_01",
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.PeasantArmed",
					RatioMin = 0.0,
					RatioMax = 1.0
				}
			]
		}
	},
	{
		ID = "PeasantsSouthern",
		HardMin = 3,
		DefaultFigure = "figure_civilian_06",
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.SouthernPeasant",
					RatioMin = 0.0,
					RatioMax = 1.0
				}
			]
		}
	},
	{
		ID = "BountyHunters",
		HardMin = 5,
		DefaultFigure = "figure_bandit_03",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.BountyHunter",
					RatioMin = 0.6,
					RatioMax = 1.0
				},
				{
					BaseID = "UnitBlock.RF.BountyHunterRanged",
					RatioMin = 0.15,
					RatioMax = 0.3
				},
				{
					BaseID = "UnitBlock.RF.Wardog",
					RatioMin = 0.05,
					RatioMax = 0.15
				}
			]
		}
	},
	{
		ID = "Mercenaries",
		HardMin = 8,
		DefaultFigure = "figure_bandit_03",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.MercenaryFrontline",
					RatioMin = 0.6,
					RatioMax = 1.0
				},
				{
					BaseID = "UnitBlock.RF.MercenaryRanged",
					RatioMin = 0.12,
					RatioMax = 0.3
				},
				{
					BaseID = "UnitBlock.RF.MercenaryElite",
					HardMin = 1,
					HardMax = 1,
					StartingResourceMax = 300,
					function getExclusionChance()
					{
						return this.getParty().getStartingResources() < 200 ? 0.8 : 0.6;
					}

				},
				{
					BaseID = "UnitBlock.RF.MercenaryElite",
					RatioMin = 0.0,
					RatioMax = 0.2,
					StartingResourceMin = 300,
					function getSpawnWeight()
					{
						return ::Math.pow(this.getParty().getStartingResources() * 0.004, 2.0);
					}

				},
				{
					BaseID = "UnitBlock.RF.Wardog",
					RatioMin = 0.0,
					RatioMax = 0.12
				}
			]
		}
	},
	{
		ID = "Militia",
		HardMin = 6,
		DefaultFigure = "figure_militia_01",
		MovementSpeedMult = 0.9,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.MilitiaFrontline",
					RatioMin = 0.6,
					RatioMax = 1.0
				},
				{
					BaseID = "UnitBlock.RF.MilitiaRanged",
					RatioMin = 0.12,
					RatioMax = 0.35
				},
				{
					BaseID = "UnitBlock.RF.MilitiaCaptain",
					HardMin = 1,
					HardMax = 1,
					StartingResourceMin = 130
				}
			]
		},
		function getUpgradeChance()
		{
			if (this.getTopParty().getStartingResources() >= 200)
			{
				return 28;
			}
			else if (this.getTopParty().getStartingResources() >= 130)
			{
				return 15;
			}
			else
			{
				return 0;
			}
		}

	},
	{
		ID = "Caravan",
		Variants = ::MSU.Class.WeightedContainer([
			[
				12,
				{
					ID = "Caravan_0",
					HardMin = 4,
					DefaultFigure = "cart_02",
					MovementSpeedMult = 0.5,
					VisibilityMult = 1.0,
					VisionMult = 0.25,
					StaticDefs = {
						Units = [
							{
								BaseID = "Unit.RF.CaravanDonkey"
							}
						]
					},
					DynamicDefs = {
						UnitBlocks = [
							{
								BaseID = "UnitBlock.RF.CaravanDonkey",
								RatioMin = 0.01,
								RatioMax = 0.1,
								PartySizeMin = 6,
								HardMax = 2
							},
							{
								BaseID = "UnitBlock.RF.CaravanHand",
								RatioMin = 0.35,
								RatioMax = 0.8,
								DeterminesFigure = false
							},
							{
								BaseID = "UnitBlock.RF.CaravanGuard",
								RatioMin = 0.15,
								RatioMax = 0.6,
								DeterminesFigure = false,
								function getSpawnWeight()
								{
									  // [000]  OP_GETBASE        1      0    0    0
									return $[stack offset 1].getSpawnWeight() * 3.0;
								}

							}
						]
					}
				}
			],
			[
				1,
				{
					ID = "Caravan_1",
					HardMin = 16,
					DefaultFigure = "cart_02",
					MovementSpeedMult = 0.5,
					VisibilityMult = 1.0,
					VisionMult = 0.25,
					StaticDefs = {
						Units = [
							{
								BaseID = "Unit.RF.CaravanDonkey"
							}
						]
					},
					DynamicDefs = {
						UnitBlocks = [
							{
								BaseID = "UnitBlock.RF.CaravanDonkey",
								RatioMin = 0.17,
								RatioMax = 0.2,
								PartySizeMin = 6,
								HardMax = 2
							},
							{
								BaseID = "UnitBlock.RF.CaravanHand",
								RatioMin = 0.15,
								RatioMax = 0.25,
								DeterminesFigure = false
							},
							{
								BaseID = "UnitBlock.RF.MercenaryFrontline",
								RatioMin = 0.6,
								RatioMax = 1.0,
								DeterminesFigure = false
							},
							{
								BaseID = "UnitBlock.RF.MercenaryRanged",
								RatioMin = 0.12,
								RatioMax = 0.3,
								DeterminesFigure = false
							}
						]
					}
				}
			]
		])
	},
	{
		ID = "CaravanEscort",
		HardMin = 4,
		DefaultFigure = "cart_02",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
		StaticDefs = {
			Units = [
				{
					BaseID = "Unit.RF.CaravanDonkey"
				},
				{
					BaseID = "Unit.RF.CaravanDonkey"
				}
			]
		},
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.CaravanDonkey",
					RatioMin = 0.15,
					RatioMax = 0.35,
					PartySizeMin = 5,
					HardMax = 1
				},
				{
					BaseID = "UnitBlock.RF.CaravanHand",
					RatioMin = 0.5,
					RatioMax = 1.0,
					DeterminesFigure = false
				}
			]
		}
	}
];

foreach( partyDef in parties )
{
	::Reforged.Spawns.Parties[partyDef.ID] <- partyDef;
}
