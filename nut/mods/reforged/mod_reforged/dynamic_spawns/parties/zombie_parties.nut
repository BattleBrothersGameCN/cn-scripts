local parties = [
	{
		ID = "ZombieOrcs",
		DefaultFigure = "figure_zombie_01",
		MovementSpeedMult = 0.8,
		VisibilityMult = 1.0,
		VisionMult = 0.8,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.ZombieOrcYoung",
					RatioMin = 0.15,
					RatioMax = 1.0,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * ::Math.maxf(0.1, 1.0 - 0.0001 * ::Math.pow(this.getTopParty().getStartingResources(), 1.55));
					}

				},
				{
					BaseID = "UnitBlock.RF.ZombieOrcBerserker",
					RatioMin = 0.0,
					RatioMax = 0.45,
					function getExclusionChance()
					{
						return this.getParty().getStartingResources() < 225 ? 0.7 : 0.5;
					}

					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * 0.5;
					}

				},
				{
					BaseID = "UnitBlock.RF.ZombieOrcWarrior",
					RatioMin = 0.0,
					RatioMax = 0.8,
					function getExclusionChance()
					{
						return this.getParty().getStartingResources() < 225 ? 0.6 : 0.3;
					}

					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * 2.0;
					}

				},
				{
					BaseID = "UnitBlock.RF.ZombieOrcWarlord",
					RatioMin = 0.0,
					HardMax = 1,
					function getSpawnWeight()
					{
						  // [000]  OP_GETBASE        1      0    0    0
						return $[stack offset 1].getSpawnWeight() * (this.getParty().getStartingResources() >= 350 ? 0.05 : 0.01);
					}

				}
			]
		}
	},
	{
		ID = "Zombies",
		HardMin = 6,
		DefaultFigure = "figure_zombie_01",
		MovementSpeedMult = 0.8,
		VisibilityMult = 1.0,
		VisionMult = 0.8,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.ZombieFrontline"
				}
			]
		},
		function getUpgradeChance()
		{
			return 20 + 2.25 * this.getTotal();
		}

	},
	{
		ID = "Ghosts",
		HardMin = 4,
		DefaultFigure = "figure_ghost_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.Ghost"
				},
				{
					BaseID = "UnitBlock.RF.Banshee",
					ExclusionChance = 50
				}
			]
		}
	},
	{
		ID = "ZombiesAndGhouls",
		HardMin = 7,
		DefaultFigure = "figure_zombie_01",
		MovementSpeedMult = 0.8,
		VisibilityMult = 1.0,
		VisionMult = 0.8,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.ZombieFrontline",
					RatioMin = 0.0,
					RatioMax = 1.0
				},
				{
					BaseID = "UnitBlock.RF.GhoulLowOnly",
					RatioMin = 0.15,
					RatioMax = 0.3
				}
			]
		},
		function onBeforeSpawnStart()
		{
			this.getSpawnable("Unit.RF.ZombieKnight").StartingResourceMin = 175;
			this.getSpawnable("Unit.RF.RF_ZombieHero").StartingResourceMin = 225;
		}

		function getUpgradeChance()
		{
			return 5 + 3.25 * this.getTotal();
		}

	},
	{
		ID = "ZombiesAndGhosts",
		HardMin = 7,
		DefaultFigure = "figure_zombie_01",
		MovementSpeedMult = 0.8,
		VisibilityMult = 1.0,
		VisionMult = 0.8,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.ZombieFrontline",
					RatioMin = 0.0,
					RatioMax = 1.0
				},
				{
					BaseID = "UnitBlock.RF.Ghost",
					RatioMin = 0.14,
					RatioMax = 0.3
				},
				{
					BaseID = "UnitBlock.RF.Hollenhund",
					RatioMin = 0.0,
					RatioMax = 0.15,
					ExclusionChance = 33
				},
				{
					BaseID = "UnitBlock.RF.Banshee",
					RatioMin = 0.0,
					ExclusionChance = 50
				}
			]
		},
		function onBeforeSpawnStart()
		{
			this.getSpawnable("Unit.RF.ZombieKnight").StartingResourceMin = 250;
			this.getSpawnable("Unit.RF.RF_ZombieHero").StartingResourceMin = 300;
		}

		function getUpgradeChance()
		{
			return 40 + 1.25 * this.getTotal();
		}

	},
	{
		ID = "Necromancer",
		Variants = ::MSU.Class.WeightedContainer([
			[
				4,
				{
					ID = "Necromancer_0",
					HardMin = 10,
					DefaultFigure = "figure_necromancer_01",
					MovementSpeedMult = 1.0,
					VisibilityMult = 1.0,
					VisionMult = 1.0,
					DynamicDefs = {
						UnitBlocks = [
							{
								BaseID = "UnitBlock.RF.NecromancerWithBodyguards",
								function onBeforeSpawnStart()
								{
									local c = ::MSU.Class.WeightedContainer();
									c.add(1, 80);

									if (this.getTopParty().getStartingResources() >= 500)
									{
										c.add(2, 20);
									}

									this.HardMin = c.roll();
									this.HardMax = this.HardMin;
								}

							},
							{
								BaseID = "UnitBlock.RF.ZombieFrontline",
								RatioMin = 0.3,
								RatioMax = 1.0,
								DeterminesFigure = false
							},
							{
								BaseID = "UnitBlock.RF.Ghost",
								RatioMin = 0.0,
								RatioMax = 0.2,
								ExclusionChance = 33,
								DeterminesFigure = false
							},
							{
								BaseID = "UnitBlock.RF.Hollenhund",
								RatioMin = 0.0,
								RatioMax = 0.2,
								ExclusionChance = 50,
								DeterminesFigure = false
							},
							{
								BaseID = "UnitBlock.RF.Banshee",
								RatioMin = 0.0,
								ExclusionChance = 50,
								DeterminesFigure = false
							}
						],
						Parties = [
							{
								BaseID = "ZombieOrcs",
								RatioMax = 0.2,
								ExclusionChance = 80,
								DeterminesFigure = false
							}
						]
					}
				}
			],
			[
				1,
				{
					ID = "NecromancerZombieOrc",
					HardMin = 6,
					DefaultFigure = "figure_necromancer_01",
					MovementSpeedMult = 1.0,
					VisibilityMult = 1.0,
					VisionMult = 1.0,
					DynamicDefs = {
						UnitBlocks = [
							{
								BaseID = "UnitBlock.RF.NecromancerWithBodyguardsOrc",
								function onBeforeSpawnStart()
								{
									local c = ::MSU.Class.WeightedContainer([
										[
											80,
											1
										]
									]);

									if (this.getTopParty().getStartingResources() >= 500)
									{
										c.add(2, 20);
									}

									this.HardMin = c.roll();
									this.HardMax = this.HardMin;
								}

							},
							{
								BaseID = "UnitBlock.RF.Hollenhund",
								RatioMax = 0.2,
								ExclusionChance = 50,
								DeterminesFigure = false
							}
						],
						Parties = [
							{
								BaseID = "ZombieOrcs",
								DeterminesFigure = false
							}
						]
					}
				}
			]
		])
	},
	{
		ID = "NecromancerSouthern",
		Variants = ::MSU.Class.WeightedContainer([
			[
				9,
				{
					ID = "NecromancerSouthern_0",
					HardMin = 4,
					DefaultFigure = "figure_necromancer_01",
					MovementSpeedMult = 1.0,
					VisibilityMult = 1.0,
					VisionMult = 1.0,
					DynamicDefs = {
						UnitBlocks = [
							{
								BaseID = "UnitBlock.RF.NecromancerWithBodyguardsNomad",
								function onBeforeSpawnStart()
								{
									local c = ::MSU.Class.WeightedContainer();
									c.add(1, 80);

									if (this.getTopParty().getStartingResources() >= 250)
									{
										c.add(2, 20);
									}

									this.HardMin = c.roll();
									this.HardMax = this.HardMin;
								}

							},
							{
								BaseID = "UnitBlock.RF.ZombieFrontlineSouthern",
								RatioMin = 0.3,
								RatioMax = 1.0,
								DeterminesFigure = false
							},
							{
								BaseID = "UnitBlock.RF.Hollenhund",
								RatioMin = 0.0,
								RatioMax = 0.2,
								ExclusionChance = 33,
								DeterminesFigure = false
							}
						],
						Parties = [
							{
								BaseID = "ZombieOrcs",
								RatioMax = 0.2,
								ExclusionChance = 80,
								DeterminesFigure = false
							}
						]
					}
				}
			],
			[
				1,
				{
					ID = "NecromancerSouthernZombieOrc",
					DefaultFigure = "figure_necromancer_01",
					MovementSpeedMult = 1.0,
					VisibilityMult = 1.0,
					VisionMult = 1.0,
					DynamicDefs = {
						Parties = [
							{
								BaseID = "NecromancerZombieOrc"
							}
						]
					}
				}
			]
		])
	},
	{
		ID = "ZombiesLight",
		HardMin = 6,
		DefaultFigure = "figure_zombie_01",
		MovementSpeedMult = 0.8,
		VisibilityMult = 1.0,
		VisionMult = 0.8,
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.ZombieLight"
				}
			]
		}
	},
	{
		ID = "ZombiesOrZombiesAndGhosts",
		DynamicDefs = {
			Parties = [
				{
					BaseID = "Zombies"
				},
				{
					BaseID = "ZombiesAndGhosts"
				}
			]
		},
		function onBeforeSpawnStart()
		{
			if (::Math.rand(1, 100) > 100 * ::Const.World.Spawn.Zombies.len().tofloat() / ::Const.World.Spawn.ZombiesOrZombiesAndGhosts.len())
			{
				this.getSpawnable("Zombies").HardMax = 0;
			}
			else
			{
				this.getSpawnable("ZombiesAndGhosts").HardMax = 0;
			}
		}

	},
	{
		ID = "ZombiesOrZombiesAndGhouls",
		DynamicDefs = {
			Parties = [
				{
					BaseID = "Zombies"
				},
				{
					BaseID = "ZombiesAndGhouls"
				}
			]
		},
		function onBeforeSpawnStart()
		{
			if (::Math.rand(1, 100) > 100 * ::Const.World.Spawn.Zombies.len().tofloat() / ::Const.World.Spawn.ZombiesOrZombiesAndGhosts.len())
			{
				this.getSpawnable("Zombies").HardMax = 0;
			}
			else
			{
				this.getSpawnable("ZombiesAndGhouls").HardMax = 0;
			}
		}

	},
	{
		ID = "NecromancerBodyguards",
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.ZombieBodyguard",
					RatioMin = 0.0,
					RatioMax = 1.0
				},
				{
					BaseID = "UnitBlock.RF.ZombieBodyguardOrc",
					RatioMin = 0.0,
					RatioMax = 1.0
				}
			]
		},
		function getDefaultResources()
		{
			if (this.getTopParty() == this)
			{
				  // [004]  OP_GETBASE        2      0    0    0
			}
			else
			{
			}

			return this.getTopParty() == this ? $[stack offset 2].getDefaultResources() : this.getTopParty().getStartingResources() * 0.2 * ::MSU.Math.randf(0.8, 1.2);
		}

		function onBeforeSpawnStart()
		{
			local c = ::MSU.Class.WeightedContainer();
			c.add(2, 3);

			if (this.getTopParty().getStartingResources() < 200)
			{
				c.add(1, 0.5);
			}
			else
			{
				c.add(3, 1);
			}

			this.HardMin = c.roll();
			this.HardMax = this.HardMin;
			local r = ::Math.rand(1, 100);

			if (r < 70)
			{
				this.getSpawnable("UnitBlock.RF.ZombieBodyguardOrc").HardMax = 0;
			}
			else if (r > 90)
			{
				this.getSpawnable("UnitBlock.RF.ZombieBodyguard").HardMax = 0;
			}
		}

	},
	{
		ID = "NecromancerBodyguardsNomad",
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.ZombieBodyguardNomad",
					RatioMin = 0.0,
					RatioMax = 1.0
				},
				{
					BaseID = "UnitBlock.RF.ZombieBodyguardOrc",
					RatioMin = 0.0,
					RatioMax = 1.0
				}
			]
		},
		function getDefaultResources()
		{
			if (this.getTopParty() == this)
			{
				  // [004]  OP_GETBASE        2      0    0    0
			}
			else
			{
			}

			return this.getTopParty() == this ? $[stack offset 2].getDefaultResources() : this.getTopParty().getStartingResources() * 0.2 * ::MSU.Math.randf(0.8, 1.2);
		}

		function onBeforeSpawnStart()
		{
			local c = ::MSU.Class.WeightedContainer();
			c.add(2, 3);

			if (this.getTopParty().getStartingResources() < 200)
			{
				c.add(1, 0.5);
			}
			else
			{
				c.add(3, 1);
			}

			this.HardMin = c.roll();
			this.HardMax = this.HardMin;
			local r = ::Math.rand(1, 100);

			if (r < 70)
			{
				this.getSpawnable("UnitBlock.RF.ZombieBodyguardOrc").HardMax = 0;
			}
			else if (r > 90)
			{
				this.getSpawnable("UnitBlock.RF.ZombieBodyguardNomad").HardMax = 0;
			}
		}

	},
	{
		ID = "NecromancerBodyguardsOrc",
		DynamicDefs = {
			UnitBlocks = [
				{
					BaseID = "UnitBlock.RF.ZombieBodyguardOrc",
					RatioMin = 0.0,
					RatioMax = 1.0
				}
			]
		},
		function getDefaultResources()
		{
			if (this.getTopParty() == this)
			{
				  // [004]  OP_GETBASE        2      0    0    0
			}
			else
			{
			}

			return this.getTopParty() == this ? $[stack offset 2].getDefaultResources() : this.getTopParty().getStartingResources() * 0.2 * ::MSU.Math.randf(0.8, 1.2);
		}

		function onBeforeSpawnStart()
		{
			local c = ::MSU.Class.WeightedContainer();
			c.add(2, 3);

			if (this.getTopParty().getStartingResources() < 200)
			{
				c.add(1, 0.5);
			}
			else
			{
				c.add(3, 1);
			}

			this.HardMin = c.roll();
			this.HardMax = this.HardMin;
		}

	}
];

foreach( partyDef in parties )
{
	::Reforged.Spawns.Parties[partyDef.ID] <- partyDef;
}
