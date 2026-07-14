local parties = [
	{
		ID = "GreenskinHorde",
		HardMin = 8,
		DefaultFigure = "figure_orc_02",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		DynamicDefs = {
			Parties = [
				{
					ID = "Orcs",
					DynamicDefs = {
						UnitBlocks = [
							{
								BaseID = "UnitBlock.RF.OrcYoung"
							},
							{
								BaseID = "UnitBlock.RF.OrcBerserker",
								StartingResourceMin = 200,
								SpawnWeightMult = 0.3
							},
							{
								BaseID = "UnitBlock.RF.OrcWarrior",
								StartingResourceMin = 230
							},
							{
								BaseID = "UnitBlock.RF.OrcBoss",
								HardMax = 1,
								StartingResourceMin = 480,
								PartySizeMin = 14
							}
						]
					}
				},
				{
					ID = "Goblins",
					DynamicDefs = {
						UnitBlocks = [
							{
								BaseID = "UnitBlock.RF.GoblinFrontline"
							},
							{
								BaseID = "UnitBlock.RF.GoblinRanged"
							},
							{
								BaseID = "UnitBlock.RF.GoblinFlank",
								StartingResourceMin = 160
							},
							{
								BaseID = "UnitBlock.RF.GoblinBoss",
								HardMax = 1,
								StartingResourceMin = 390,
								PartySizeMin = 21
							},
							{
								BaseID = "UnitBlock.RF.GoblinSupport",
								HardMax = 3,
								StartingResourceMin = 495,
								PartySizeMin = 17,
								SpawnWeightMult = 0.2
							}
						]
					}
				}
			]
		},
		function onBeforeSpawnStart()
		{
			local res = this.getTopParty().getStartingResources();
			local orcs = this.getSpawnable("兽人");
			local goblins = this.getSpawnable("地精");
			local orcBoss = this.getSpawnable("UnitBlock.RF.OrcBoss");
			local goblinBoss = this.getSpawnable("UnitBlock.RF.GoblinBoss");
			local chosen;

			if (::Math.rand(1, 2) == 1)
			{
				chosen = orcs;
				goblinBoss.ExclusionChance = 50;
			}
			else
			{
				chosen = goblins;
				orcBoss.ExclusionChance = 50;
			}

			chosen.RatioMin = 0.6;
			orcBoss.SpawnWeightMult = ::Reforged.Math.lerpClamp(res, 150, 0.1, 1100, 0.3);
			goblinBoss.SpawnWeightMult = ::Reforged.Math.lerpClamp(res, 150, 0.1, 1100, 0.3);

			if (::Math.rand(1, 100) > 70)
			{
				this.getSpawnable("UnitBlock.RF.GoblinFlank").SpawnWeightMult = 5.0;
			}

			if (::Math.rand(1, 100) > 70)
			{
				this.getSpawnable("UnitBlock.RF.OrcWarrior").SpawnWeightMult = 5.0;
			}

			this.getSpawnable("UnitBlock.RF.OrcYoung").SpawnWeightMult = ::Reforged.Math.lerpClamp(res, 150, 1.0, 1100, 0.4);
		}

	}
];

foreach( partyDef in parties )
{
	::Reforged.Spawns.Parties[partyDef.ID] <- partyDef;
}
