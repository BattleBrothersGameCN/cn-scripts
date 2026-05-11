this.asset_manager <- {
	m = {
		Stash = null,
		OverflowItems = [],
		CampaignID = 0,
		Name = "战场兄弟",
		Banner = "banner_01",
		BannerID = 1,
		Look = 1,
		EconomicDifficulty = 1,
		CombatDifficulty = 1,
		SeedString = "",
		Origin = null,
		RestoreEquipment = [],
		Money = 0,
		Food = 0.0,
		Ammo = 0.0,
		ArmorParts = 0.0,
		Medicine = 0.0,
		FoodAdditionalDays = 0,
		FoodConsumptionMult = 1.0,
		DailyWageMult = 1.0,
		TaxidermistPriceMult = 1.0,
		TrainingPriceMult = 1.0,
		TryoutPriceMult = 1.0,
		ContractPaymentMult = 1.0,
		ArmorPartsPerArmor = 0.067,
		HitpointsPerHourMult = 1.0,
		AdditionalHitpointsPerHour = 0,
		RepairSpeedMult = 1.0,
		HiringCostMult = 1.0,
		CampingMult = 1.5,
		RosterSizeAdditionalMin = 0,
		RosterSizeAdditionalMax = 0,
		XPMult = 1.0,
		ChampionChanceAdditional = 0,
		RelationDecayGoodMult = 1.0,
		RelationDecayBadMult = 1.0,
		NegotiationAnnoyanceMult = 1.0,
		AdvancePaymentCap = 0.5,
		VisionRadiusMult = 1.0,
		AmmoMaxAdditional = 0,
		MedicineMaxAdditional = 0,
		ArmorPartsMaxAdditional = 0,
		TerrainTypeSpeedMult = [],
		IsRecoveringAmmo = false,
		IsRecoveringArmor = false,
		IsBlacksmithed = false,
		IsDisciplined = false,
		IsBrigand = false,
		IsNonFlavorRumorsOnly = false,
		IsSurvivalGuaranteed = false,
		IsShowingExtendedFootprints = false,
		BusinessReputation = 0,
		BusinessReputationRate = 1.0,
		MoralReputation = 50.0,
		Score = 0.0,
		BuyPriceMult = 1.0,
		BuyPriceTradeMult = 1.0,
		SellPriceMult = 1.0,
		SellPriceTradeMult = 1.0,
		ExtraLootChance = 0,
		FootprintVision = 1.0,
		AverageMoodState = this.Const.MoodState.Neutral,
		BrothersMax = 20,
		BrothersMaxInCombat = 12,
		BrothersScaleMax = 12,
		BrothersScaleMin = 3,
		LastDayPaid = 1,
		LastHourUpdated = 0,
		LastFoodConsumed = 0,
		IsIronman = false,
		IsExplorationMode = false,
		IsPermanentDestruction = true,
		IsCamping = false,
		IsUsingProvisions = true,
		IsConsumingAssets = true
	},
	function getCampaignID()
	{
		return this.m.CampaignID;
	}

	function getSeedString()
	{
		return this.m.SeedString;
	}

	function getName()
	{
		return this.m.Name;
	}

	function getBanner()
	{
		return this.m.Banner;
	}

	function getBannerID()
	{
		return this.m.BannerID;
	}

	function getOrigin()
	{
		return this.m.Origin;
	}

	function getEconomicDifficulty()
	{
		return this.m.EconomicDifficulty;
	}

	function getCombatDifficulty()
	{
		return this.m.CombatDifficulty;
	}

	function getDifficulty()
	{
		return this.m.CombatDifficulty;
	}

	function getStash()
	{
		return this.m.Stash;
	}

	function getOverflowItems()
	{
		return this.m.OverflowItems;
	}

	function getAverageMoodState()
	{
		return this.m.AverageMoodState;
	}

	function getMoney()
	{
		return this.m.Money;
	}

	function getFood()
	{
		return this.Math.floor(this.m.Food);
	}

	function getAmmo()
	{
		return this.Math.floor(this.m.Ammo);
	}

	function getArmorParts()
	{
		return this.Math.floor(this.m.ArmorParts);
	}

	function getMedicine()
	{
		return this.Math.floor(this.m.Medicine);
	}

	function getBusinessReputation()
	{
		return this.m.BusinessReputation;
	}

	function getMoralReputation()
	{
		return this.m.MoralReputation;
	}

	function getBuyPriceMult()
	{
		return this.m.BuyPriceMult;
	}

	function getSellPriceMult()
	{
		return this.m.SellPriceMult;
	}

	function getExtraLootChance()
	{
		return this.m.ExtraLootChance;
	}

	function getFootprintVision()
	{
		return this.m.FootprintVision;
	}

	function getBrothersMax()
	{
		return this.m.BrothersMax;
	}

	function getBrothersMaxInCombat()
	{
		return this.m.BrothersMaxInCombat;
	}

	function getBrothersScaleMax()
	{
		return this.m.BrothersScaleMax;
	}

	function getBrothersScaleMin()
	{
		return this.m.BrothersScaleMin;
	}

	function getTerrainTypeSpeedMult( _t )
	{
		return this.m.TerrainTypeSpeedMult[_t];
	}

	function isIronman()
	{
		return this.m.IsIronman;
	}

	function isExplorationMode()
	{
		return this.m.IsExplorationMode;
	}

	function isPermanentDestruction()
	{
		return this.m.IsPermanentDestruction;
	}

	function isCamping()
	{
		return this.m.IsCamping;
	}

	function isUsingProvisions()
	{
		return this.m.IsUsingProvisions;
	}

	function isConsumingAssets()
	{
		return this.m.IsConsumingAssets;
	}

	function setCamping( _c )
	{
		this.m.IsCamping = _c;
		this.World.State.getPlayer().setCamping(_c);
	}

	function setUseProvisions( _p )
	{
		this.m.IsUsingProvisions = _p;
	}

	function setConsumingAssets( _a )
	{
		this.m.IsConsumingAssets = _a;
	}

	function addScore( _s )
	{
		this.m.Score += _s;
	}

	function setMoney( _m )
	{
		this.m.Money = _m;
	}

	function setAmmo( _f )
	{
		this.m.Ammo = this.Math.min(this.Math.max(0, _f), this.Const.Difficulty.MaxResources[this.m.EconomicDifficulty].Ammo + this.m.AmmoMaxAdditional);
		this.refillAmmo();
	}

	function setArmorParts( _f )
	{
		this.m.ArmorParts = this.Math.min(this.Math.max(0, _f), this.Const.Difficulty.MaxResources[this.m.EconomicDifficulty].ArmorParts + this.m.ArmorPartsMaxAdditional);
	}

	function setMedicine( _f )
	{
		this.m.Medicine = this.Math.min(this.Math.max(0, _f), this.Const.Difficulty.MaxResources[this.m.EconomicDifficulty].Medicine + this.m.MedicineMaxAdditional);
	}

	function addAmmo( _f )
	{
		this.m.Ammo = this.Math.min(this.Math.max(0, this.m.Ammo + _f), this.Const.Difficulty.MaxResources[this.m.EconomicDifficulty].Ammo + this.m.AmmoMaxAdditional);
	}

	function addArmorParts( _f )
	{
		this.m.ArmorParts = this.Math.minf(this.Math.maxf(0, this.m.ArmorParts + _f), this.Const.Difficulty.MaxResources[this.m.EconomicDifficulty].ArmorParts + this.m.ArmorPartsMaxAdditional);
	}

	function addMedicine( _f )
	{
		this.m.Medicine = this.Math.min(this.Math.max(0, this.m.Medicine + _f), this.Const.Difficulty.MaxResources[this.m.EconomicDifficulty].Medicine + this.m.MedicineMaxAdditional);
	}

	function addMoralReputation( _f )
	{
		this.m.MoralReputation = this.Math.minf(100.0, this.Math.max(0.0, this.m.MoralReputation + _f));
	}

	function addMoney( _f )
	{
		if (_f == 0)
		{
			return;
		}

		this.m.Money += _f;
		this.Sound.play(this.Const.Sound.MoneyTransaction[this.Math.rand(0, this.Const.Sound.MoneyTransaction.len() - 1)], this.Const.Sound.Volume.Inventory);

		if (_f > 0)
		{
			this.m.Score += _f * 0.01;
		}

		if (this.m.Money >= 5000)
		{
			this.updateAchievement("BackInBusiness", 1, 1);
		}

		if (this.m.Money >= 50000)
		{
			this.updateAchievement("Moneymaker", 1, 1);
		}

		if (this.m.Money >= 250000)
		{
			this.updateAchievement("DragonsHoard", 1, 1);
		}
	}

	function addBusinessReputation( _f )
	{
		this.m.BusinessReputation += this.Math.ceil(_f * this.m.BusinessReputationRate);

		if (this.m.BusinessReputation >= 1000)
		{
			this.updateAchievement("MakingAName", 1, 1);
		}

		if (this.m.BusinessReputation >= 3000)
		{
			this.updateAchievement("ManOfRenown", 1, 1);
		}

		if (this.m.BusinessReputation >= 8000)
		{
			this.updateAchievement("StuffOfLegends", 1, 1);
		}
	}

	function setCampaignSettings( _settings )
	{
		this.m.CampaignID = this.Math.max(0, this.Math.rand());
		this.m.Name = this.removeFromBeginningOfText(" ", this.removeFromBeginningOfText(" ", _settings.Name));
		this.m.Banner = _settings.Banner;
		this.m.BannerID = _settings.Banner.slice(_settings.Banner.find("_") + 1).tointeger();
		this.m.CombatDifficulty = _settings.Difficulty;
		this.m.EconomicDifficulty = _settings.EconomicDifficulty;
		this.m.IsIronman = _settings.Ironman;
		this.m.IsPermanentDestruction = _settings.PermanentDestruction;
		this.m.Origin = _settings.StartingScenario;
		this.m.IsExplorationMode = _settings.ExplorationMode;
		this.m.BusinessReputation = 0;
		this.m.SeedString = _settings.Seed;
		this.World.FactionManager.getGreaterEvil().Type = _settings.GreaterEvil;

		switch(_settings.BudgetDifficulty)
		{
		case 0:
			this.m.Money = 2500;
			this.m.Ammo = 80;
			this.m.ArmorParts = 40;
			this.m.Medicine = 30;
			break;

		case 1:
			this.m.Money = 2000;
			this.m.Ammo = 40;
			this.m.ArmorParts = 20;
			this.m.Medicine = 20;
			break;

		case 2:
			this.m.Money = 1500;
			this.m.Ammo = 20;
			this.m.ArmorParts = 10;
			this.m.Medicine = 10;
			break;
		}

		this.m.Stash.clear();
		this.m.Origin.onSpawnAssets();
		local bros = this.World.getPlayerRoster().getAll();

		foreach( bro in bros )
		{
			bro.getBackground().buildDescription(true);
			bro.m.XP = this.Const.LevelXP[bro.m.Level - 1];
			bro.m.Attributes = [];
			bro.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
			bro.getSkills().update();
		}

		this.updateFormation();

		foreach( item in this.Const.World.Assets.NewCampaignEquipment )
		{
			this.m.Stash.add(this.new(item));
		}

		this.updateFood();
	}

	function getBusinessReputationAsText()
	{
		for( local i = 1; i != this.Const.BusinessReputation.len(); i = ++i )
		{
			if (this.Const.BusinessReputation[i] > this.m.BusinessReputation)
			{
				return this.Const.Strings.BusinessReputation[i - 1];
			}
		}

		return this.Const.Strings.BusinessReputation[this.Const.Strings.BusinessReputation.len() - 1];
	}

	function getMoralReputationAsText()
	{
		return this.Const.Strings.MoralReputation[this.Math.max(0, this.Math.min(this.Const.Strings.MoralReputation.len() - 1, this.m.MoralReputation / 10))];
	}

	function getDailyMoneyCost()
	{
		local cost = 0;
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			cost = cost + bro.getDailyCost();
		}

		return cost;
	}

	function getDailyFoodCost()
	{
		local cost = 0;
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			cost = cost + bro.getDailyFood();
		}

		return cost;
	}

	function getRepairRequired()
	{
		local ret = {
			ArmorParts = 0,
			Hours = 0
		};
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local d;
			local items = bro.getItems().getAllItems();

			foreach( item in items )
			{
				if (item.getCondition() < item.getConditionMax())
				{
					d = item.getConditionMax() - item.getCondition();

					if (d > 0)
					{
						ret.ArmorParts += d * this.m.ArmorPartsPerArmor;

						if (d / this.Const.World.Assets.ArmorPerHour > ret.Hours)
						{
							ret.Hours = d / this.Const.World.Assets.ArmorPerHour;
						}
					}
				}
			}
		}

		local items = this.m.Stash.getItems();

		foreach( item in items )
		{
			if (item == null)
			{
				continue;
			}

			local d = 0;

			if (item.isToBeRepaired())
			{
				d = item.getConditionMax() - item.getCondition();
			}

			if (d > 0)
			{
				ret.ArmorParts += d * this.m.ArmorPartsPerArmor;

				if (d / this.Const.World.Assets.ArmorPerHour > ret.Hours)
				{
					ret.Hours = d / this.Const.World.Assets.ArmorPerHour;
				}
			}
		}

		ret.ArmorParts = this.Math.ceil(ret.ArmorParts);
		ret.Hours = this.Math.ceil(ret.Hours / (this.isCamping() ? this.m.CampingMult : 1.0) / this.m.RepairSpeedMult);
		return ret;
	}

	function getHealingRequired()
	{
		local ret = {
			MedicineMin = 0,
			MedicineMax = 0,
			DaysMin = 0,
			DaysMax = 0
		};
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local injuries = bro.getSkills().query(this.Const.SkillType.TemporaryInjury);

			if (bro.getSkills().hasSkill("injury.sickness"))
			{
				injuries.push(bro.getSkills().getSkillByID("injury.sickness"));
			}

			foreach( inj in injuries )
			{
				local ht = inj.getHealingTime();
				ret.MedicineMin += ht.Min * this.Const.World.Assets.MedicinePerInjuryDay;
				ret.MedicineMax += ht.Max * this.Const.World.Assets.MedicinePerInjuryDay;

				if (ht.Min > ret.DaysMin)
				{
					ret.DaysMin = ht.Min;
				}

				if (ht.Max > ret.DaysMax)
				{
					ret.DaysMax = ht.Max;
				}
			}
		}

		ret.MedicineMin = this.Math.ceil(ret.MedicineMin);
		ret.MedicineMax = this.Math.ceil(ret.MedicineMax);
		ret.DaysMin = this.Math.ceil(ret.DaysMin);
		ret.DaysMax = this.Math.ceil(ret.DaysMax);
		return ret;
	}

	function getAllBrotherNames()
	{
		local ret = "";
		local roster = this.World.getPlayerRoster().getAll();

		for( local i = 0; i < roster.len(); i = ++i )
		{
			if (i != 0)
			{
				if (i == roster.len() - 1)
				{
					ret = ret + "和";
				}
				else
				{
					ret = ret + ", ";
				}
			}

			ret = ret + roster[i].getName();
		}

		return ret;
	}

	function removeRandomFood( _num )
	{
		local food = this.World.Assets.getFoodItems();

		if (food.len() != 0)
		{
			food = food[this.Math.rand(0, food.len() - 1)];
			food.setAmount(this.Math.max(1, food.getAmount() - _num));
		}
	}

	function clear()
	{
		this.m.Stash.clear();
		this.m.SeedString = "";
		this.m.IsCamping = false;
		this.m.IsUsingProvisions = true;
		this.resetToDefaults();
	}

	function resetToDefaults()
	{
		this.m.BrothersMax = 20;
		this.m.BrothersMaxInCombat = 12;
		this.m.BrothersScaleMax = 12;
		this.m.BrothersScaleMin = 3;
		this.m.BusinessReputationRate = 1.0;
		this.m.BuyPriceMult = 1.0;
		this.m.BuyPriceTradeMult = 1.0;
		this.m.SellPriceMult = 1.0;
		this.m.SellPriceTradeMult = 1.0;
		this.m.ExtraLootChance = 0;
		this.m.FootprintVision = 1.0;
		this.m.FoodAdditionalDays = 0;
		this.m.FoodConsumptionMult = 1.0;
		this.m.DailyWageMult = 1.0;
		this.m.TaxidermistPriceMult = 1.0;
		this.m.TrainingPriceMult = 1.0;
		this.m.TryoutPriceMult = 1.0;
		this.m.ContractPaymentMult = 1.0;
		this.m.ArmorPartsPerArmor = this.Const.World.Assets.ArmorPartsPerArmor;
		this.m.HitpointsPerHourMult = 1.0;
		this.m.AdditionalHitpointsPerHour = 0;
		this.m.RepairSpeedMult = 1.0;
		this.m.HiringCostMult = 1.0;
		this.m.CampingMult = 1.5;
		this.m.RosterSizeAdditionalMin = 0;
		this.m.RosterSizeAdditionalMax = 0;
		this.m.XPMult = 1.0;
		this.m.ChampionChanceAdditional = 0;
		this.m.RelationDecayGoodMult = 1.0;
		this.m.RelationDecayBadMult = 1.0;
		this.m.NegotiationAnnoyanceMult = 1.0;
		this.m.AdvancePaymentCap = 0.5;
		this.m.VisionRadiusMult = 1.0;
		this.m.AmmoMaxAdditional = 0;
		this.m.MedicineMaxAdditional = 0;
		this.m.ArmorPartsMaxAdditional = 0;
		this.m.TerrainTypeSpeedMult.resize(this.Const.World.TerrainFoodConsumption.len());

		for( local i = 0; i < this.m.TerrainTypeSpeedMult.len(); i = ++i )
		{
			this.m.TerrainTypeSpeedMult[i] = 1.0;
		}

		this.m.IsRecoveringAmmo = false;
		this.m.IsRecoveringArmor = false;
		this.m.IsDisciplined = false;
		this.m.IsBrigand = false;
		this.m.IsNonFlavorRumorsOnly = false;
		this.m.IsSurvivalGuaranteed = false;
		this.m.IsShowingExtendedFootprints = false;
		this.m.IsBlacksmithed = false;
		this.World.Retinue.update();

		if (this.m.Origin != null)
		{
			this.m.Origin.onInit();
		}

		if (this.World.Ambitions.hasActiveAmbition())
		{
			this.World.Ambitions.getActiveAmbition().onUpdateEffect();
		}
	}

	function create()
	{
		this.m.Stash = this.new("scripts/items/stash_container");
		this.m.Stash.resize(99);
		this.m.Stash.setID("player");
		local globalTable = this.getroottable();
		globalTable.Stash <- this.WeakTableRef(this.m.Stash);
	}

	function init()
	{
		this.m.LastFoodConsumed = this.Time.getVirtualTimeF();
		this.clear();
	}

	function destroy()
	{
		local globalTable = this.getroottable();
		delete globalTable.Stash;
		this.m.Stash.clear();
		this.m.Stash = null;
	}

	function sortFoodByFreshness( _f1, _f2 )
	{
		if (!_f1.isDesirable() && _f2.isDesirable())
		{
			return 1;
		}
		else if (_f1.isDesirable() && !_f2.isDesirable())
		{
			return -1;
		}
		else if (_f1.getBestBeforeTime() > _f2.getBestBeforeTime())
		{
			return 1;
		}
		else if (_f1.getBestBeforeTime() < _f2.getBestBeforeTime())
		{
			return -1;
		}
		else
		{
			return 0;
		}
	}

	function getFoodItems()
	{
		local items = this.m.Stash.getItems();
		local food = [];

		foreach( i, item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				food.push(item);
			}
		}

		return food;
	}

	function consumeFood()
	{
		local items = this.m.Stash.getItems();
		local food = [];

		foreach( i, item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (this.Time.getVirtualTimeF() >= item.getBestBeforeTime())
				{
					items[i] = null;
				}
				else
				{
					food.push(item);
				}
			}
		}

		if (!this.m.IsUsingProvisions)
		{
			this.m.LastFoodConsumed = this.Time.getVirtualTimeF();
			return;
		}

		food.sort(this.sortFoodByFreshness);
		local d = this.Math.maxf(0.0, this.Time.getVirtualTimeF() - this.m.LastFoodConsumed);
		this.m.LastFoodConsumed = this.Time.getVirtualTimeF();
		local eaten = d * this.getDailyFoodCost() * this.Const.World.TerrainFoodConsumption[this.World.State.getPlayer().getTile().Type] * this.m.FoodConsumptionMult * this.Const.World.Assets.FoodConsumptionMult;

		for( local i = 0; i < food.len();  )
		{
			local foodLeft = food[i].getAmount() - eaten;

			if (foodLeft <= 0)
			{
				eaten = eaten - food[i].getAmount();

				foreach( j, item in items )
				{
					if (item == food[i])
					{
						items[j] = null;
						break;
					}
				}

				food.remove(i);
				  // [136]  OP_JMP            0      8    0    0
			}
			else
			{
				food[i].setAmount(foodLeft);
				break;
			}
		}

		this.updateFood();
	}

	function update( _worldState )
	{
		if (this.World.getTime().Days > this.m.LastDayPaid && this.World.getTime().Hours > 8 && this.m.IsConsumingAssets)
		{
			this.m.LastDayPaid = this.World.getTime().Days;

			if (this.m.BusinessReputation > 0)
			{
				this.m.BusinessReputation = this.Math.max(0, this.m.BusinessReputation + this.Const.World.Assets.ReputationDaily);
			}

			this.World.Retinue.onNewDay();

			if (this.World.Flags.get("IsGoldenGoose") == true)
			{
				this.addMoney(15);
			}

			local roster = this.World.getPlayerRoster().getAll();
			local mood = 0;
			local slaves = 0;
			local nonSlaves = 0;

			if (this.m.Origin.getID() == "scenario.manhunters")
			{
				foreach( bro in roster )
				{
					if (bro.getBackground().getID() == "background.slave")
					{
						slaves = ++slaves;
					}
					else
					{
						nonSlaves = ++nonSlaves;
					}
				}
			}

			foreach( bro in roster )
			{
				bro.getSkills().onNewDay();
				bro.updateInjuryVisuals();

				if (bro.getDailyCost() > 0 && this.m.Money < bro.getDailyCost())
				{
					if (bro.getSkills().hasSkill("trait.greedy"))
					{
						bro.worsenMood(this.Const.MoodChange.NotPaidGreedy, "没拿到工钱");
					}
					else
					{
						bro.worsenMood(this.Const.MoodChange.NotPaid, "没拿到工钱");
					}
				}

				if (this.m.IsUsingProvisions && this.m.Food < bro.getDailyFood())
				{
					if (bro.getSkills().hasSkill("trait.spartan"))
					{
						bro.worsenMood(this.Const.MoodChange.NotEatenSpartan, "实在是饿了");
					}
					else if (bro.getSkills().hasSkill("trait.gluttonous"))
					{
						bro.worsenMood(this.Const.MoodChange.NotEatenGluttonous, "实在是饿了");
					}
					else
					{
						bro.worsenMood(this.Const.MoodChange.NotEaten, "实在是饿了");
					}
				}

				if (this.m.Origin.getID() == "scenario.manhunters" && slaves <= nonSlaves)
				{
					if (bro.getBackground().getID() != "background.slave")
					{
						bro.worsenMood(this.Const.MoodChange.TooFewSlaves, "战团中负债者太少。");
					}
				}

				this.m.Money -= bro.getDailyCost();
				mood = mood + bro.getMoodState();
			}

			this.Sound.play(this.Const.Sound.MoneyTransaction[this.Math.rand(0, this.Const.Sound.MoneyTransaction.len() - 1)], this.Const.Sound.Volume.Inventory);
			this.m.AverageMoodState = this.Math.round(mood / roster.len());
			_worldState.updateTopbarAssets();

			if (this.m.EconomicDifficulty >= 1 && this.m.CombatDifficulty >= 1)
			{
				if (this.World.getTime().Days >= 365)
				{
					this.updateAchievement("Anniversary", 1, 1);
				}
				else if (this.World.getTime().Days >= 100)
				{
					this.updateAchievement("Campaigner", 1, 1);
				}
				else if (this.World.getTime().Days >= 10)
				{
					this.updateAchievement("Survivor", 1, 1);
				}
			}
		}

		if (this.World.getTime().Hours != this.m.LastHourUpdated && this.m.IsConsumingAssets)
		{
			this.m.LastHourUpdated = this.World.getTime().Hours;
			this.consumeFood();
			local roster = this.World.getPlayerRoster().getAll();
			local campMultiplier = this.isCamping() ? this.m.CampingMult : 1.0;

			foreach( bro in roster )
			{
				local d = bro.getHitpointsMax() - bro.getHitpoints();

				if (bro.getHitpoints() < bro.getHitpointsMax())
				{
					bro.setHitpoints(this.Math.minf(bro.getHitpointsMax(), bro.getHitpoints() + (this.Const.World.Assets.HitpointsPerHour + this.m.AdditionalHitpointsPerHour) * campMultiplier * this.m.HitpointsPerHourMult));
				}
			}

			foreach( bro in roster )
			{
				if (this.m.ArmorParts == 0)
				{
					break;
				}

				local items = bro.getItems().getAllItems();
				local updateBro = false;

				foreach( item in items )
				{
					if (item.getCondition() < item.getConditionMax())
					{
						local d = this.Math.minf(this.Const.World.Assets.ArmorPerHour * campMultiplier * this.m.RepairSpeedMult, item.getConditionMax() - item.getCondition());
						item.improveCondition(d);
						this.m.ArmorParts = this.Math.maxf(0, this.m.ArmorParts - d * this.m.ArmorPartsPerArmor);
						updateBro = true;
					}

					if (item.getCondition() >= item.getConditionMax())
					{
						item.setToBeRepaired(false);
					}

					if (this.m.ArmorParts == 0)
					{
						break;
					}
				}

				if (updateBro)
				{
					bro.getSkills().update();
				}
			}

			local items = this.m.Stash.getItems();

			foreach( item in items )
			{
				if (this.m.ArmorParts == 0)
				{
					break;
				}

				if (item == null)
				{
					continue;
				}

				if (item.isToBeRepaired())
				{
					if (item.getCondition() < item.getConditionMax())
					{
						local d = this.Math.minf(this.Const.World.Assets.ArmorPerHour * campMultiplier * this.m.RepairSpeedMult, item.getConditionMax() - item.getCondition());
						item.improveCondition(d);
						this.m.ArmorParts = this.Math.maxf(0, this.m.ArmorParts - d * this.m.ArmorPartsPerArmor);
					}

					if (item.getCondition() >= item.getConditionMax())
					{
						item.setToBeRepaired(false);
					}
				}
			}

			if (this.World.getTime().Hours % 4 == 0)
			{
				this.checkDesertion();
				local towns = this.World.EntityManager.getSettlements();
				local playerTile = this.World.State.getPlayer().getTile();
				local town;

				foreach( t in towns )
				{
					if (t.getSize() >= 2 && !t.isMilitary() && t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
					{
						town = t;
						break;
					}
				}

				foreach( bro in roster )
				{
					bro.recoverMood();

					if (town != null && bro.getMoodState() <= this.Const.MoodState.Neutral)
					{
						bro.improveMood(this.Const.MoodChange.NearCity, "高兴能来" + town.getName());
					}
				}
			}

			_worldState.updateTopbarAssets();
		}
	}

	function updateAverageMoodState()
	{
		local mood = 0;
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			mood = mood + bro.getMoodState();
		}

		if (roster.len() > 0)
		{
			this.m.AverageMoodState = this.Math.round(mood / roster.len());
		}
	}

	function updateFood()
	{
		local items = this.m.Stash.getItems();
		this.m.Food = 0.0;

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				this.m.Food += item.getAmount();
			}
		}
	}

	function checkAmbitionItems()
	{
		local supposedToHaveStandard = this.World.Ambitions.getAmbition("ambition.battle_standard").isDone();
		local supposedToHaveSergeant = this.World.Ambitions.getAmbition("ambition.sergeant").isDone();
		local hasStandard = false;
		local hasSergeant = false;

		if (supposedToHaveStandard || supposedToHaveSergeant)
		{
			local items = this.m.Stash.getItems();

			foreach( item in items )
			{
				if (item != null)
				{
					if (item.getID() == "weapon.player_banner")
					{
						hasStandard = true;
					}
					else if (item.getID() == "accessory.sergeant_badge")
					{
						hasSergeant = true;
					}
				}
			}

			local roster = this.World.getPlayerRoster().getAll();

			foreach( bro in roster )
			{
				local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

				if (item != null && item.getID() == "weapon.player_banner")
				{
					hasStandard = true;
				}

				item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

				if (item != null && item.getID() == "accessory.sergeant_badge")
				{
					hasSergeant = true;
				}

				for( local i = 0; i < bro.getItems().getUnlockedBagSlots(); i = ++i )
				{
					item = bro.getItems().getItemAtBagSlot(i);

					if (item != null && item.getID() == "weapon.player_banner")
					{
						hasStandard = true;
					}
					else if (item != null && item.getID() == "accessory.sergeant_badge")
					{
						hasSergeant = true;
					}
				}
			}

			if (supposedToHaveStandard && !hasStandard)
			{
				this.World.Ambitions.getAmbition("ambition.battle_standard").setDone(false);

				foreach( bro in roster )
				{
					bro.worsenMood(this.Const.MoodChange.StandardLost, "失去了战旗");
				}
			}

			if (supposedToHaveSergeant && !hasSergeant)
			{
				this.World.Ambitions.getAmbition("ambition.sergeant").setDone(false);
			}
		}
	}

	function updateAchievements()
	{
		if (!this.hasAchievement("FieldHospital"))
		{
			local roster = this.World.getPlayerRoster().getAll();
			local numWithInjuries = 0;

			foreach( bro in roster )
			{
				if (bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
				{
					numWithInjuries = ++numWithInjuries;
				}
			}

			if (numWithInjuries >= 5)
			{
				this.updateAchievement("FieldHospital", 1, 1);
			}
		}

		if (!this.hasAchievement("BlingBling") || !this.hasAchievement("TrickedOut"))
		{
			local items = this.m.Stash.getItems();
			local numNamedItems = 0;

			foreach( item in items )
			{
				if (item != null && item.isItemType(this.Const.Items.ItemType.Named))
				{
					numNamedItems = ++numNamedItems;
				}
			}

			if (numNamedItems < 5)
			{
				local roster = this.World.getPlayerRoster().getAll();

				foreach( bro in roster )
				{
					local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

					if (item != null && item.isItemType(this.Const.Items.ItemType.Named))
					{
						numNamedItems = ++numNamedItems;
					}

					item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

					if (item != null && item != "-1" && item.isItemType(this.Const.Items.ItemType.Named))
					{
						numNamedItems = ++numNamedItems;
					}

					item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

					if (item != null && item.isItemType(this.Const.Items.ItemType.Named))
					{
						numNamedItems = ++numNamedItems;
					}

					item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

					if (item != null && item.isItemType(this.Const.Items.ItemType.Named))
					{
						numNamedItems = ++numNamedItems;
					}

					for( local i = 0; i < bro.getItems().getUnlockedBagSlots(); i = ++i )
					{
						item = bro.getItems().getItemAtBagSlot(i);

						if (item != null && item.isItemType(this.Const.Items.ItemType.Named))
						{
							numNamedItems = ++numNamedItems;
						}
					}
				}
			}

			if (numNamedItems >= 1)
			{
				this.updateAchievement("BlingBling", 1, 1);
			}

			if (numNamedItems >= 5)
			{
				this.updateAchievement("TrickedOut", 1, 1);
			}
		}
	}

	function checkDesertion()
	{
		if (!this.World.Events.canFireEvent())
		{
			return;
		}

		local roster = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local hasPaymaster = this.World.Retinue.hasFollower("follower.paymaster");

		foreach( bro in roster )
		{
			if (bro.getDailyCost() == 0 || bro.getFlags().has("IsPlayerCharacter"))
			{
				continue;
			}

			if (bro.getMood() < 1.0)
			{
				local chance = (1.0 - bro.getMood()) * 100;

				if (bro.getSkills().hasSkill("trait.loyal"))
				{
					chance = chance * 0.5;
				}
				else if (bro.getSkills().hasSkill("trait.disloyal"))
				{
					chance = chance * 2.0;
				}

				if (bro.getBackground().getID() == "background.companion")
				{
					chance = chance * 0.5;
				}

				if (hasPaymaster)
				{
					chance = chance * 0.5;
				}

				if (this.Math.rand(1, 100) <= chance)
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() != 0)
		{
			local bro = candidates[this.Math.rand(0, candidates.len() - 1)];

			if (this.World.getPlayerRoster().getSize() > 1)
			{
				local event = this.World.Events.getEvent("event.desertion");
				event.setDeserter(bro);
				this.World.Events.fire("event.desertion", false);
			}
			else
			{
				this.World.State.showGameFinishScreen(false);
			}
		}
	}

	function refillAmmo()
	{
		if (this.m.Ammo == 0)
		{
			return;
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local items = bro.getItems().getAllItems();

			foreach( item in items )
			{
				if (item.isItemType(this.Const.Items.ItemType.Ammo) && item.getAmmo() < item.getAmmoMax())
				{
					local a = this.Math.min(this.m.Ammo, this.Math.ceil(item.getAmmoMax() - item.getAmmo()) * item.getAmmoCost());

					if (this.m.Ammo >= a)
					{
						item.setAmmo(item.getAmmo() + this.Math.ceil(a / item.getAmmoCost()));
						this.m.Ammo -= a;
					}
				}

				if (this.m.Ammo == 0)
				{
					break;
				}
			}
		}

		if (this.World.State.getCurrentTown() != null)
		{
			this.World.State.getTownScreen().updateAssets();
		}
	}

	function consumeItems()
	{
		local items = this.m.Stash.getItems();
		local garbage = [];

		foreach( i, item in items )
		{
			if (item == null || !item.isConsumed())
			{
				continue;
			}

			item.consume();
			garbage.push(i);
		}

		garbage.reverse();

		foreach( i in garbage )
		{
			items[i] = null;
		}
	}

	function getFormation()
	{
		local ret = [];
		ret.resize(27, null);
		local roster = this.World.getPlayerRoster().getAll();

		foreach( b in roster )
		{
			ret[b.getPlaceInFormation()] = b;
		}

		return ret;
	}

	function updateFormation( considerMaxBros = false )
	{
		local NOT_IN_FORMATION = 255;
		local formation = [];
		formation.resize(27, false);
		local roster = this.World.getPlayerRoster().getAll();
		local hasUnplaced = false;
		local inCombat = 0;

		foreach( b in roster )
		{
			if (b.getPlaceInFormation() != NOT_IN_FORMATION && formation[b.getPlaceInFormation()] == false && (!considerMaxBros || inCombat < this.m.BrothersMaxInCombat))
			{
				formation[b.getPlaceInFormation()] = true;

				if (b.getPlaceInFormation() <= 17)
				{
					inCombat = ++inCombat;
				}
			}
			else
			{
				b.setPlaceInFormation(NOT_IN_FORMATION);
				hasUnplaced = true;
			}
		}

		if (hasUnplaced)
		{
			foreach( b in roster )
			{
				if (b.getPlaceInFormation() != NOT_IN_FORMATION)
				{
					continue;
				}

				local i = 0;

				if (inCombat >= this.m.BrothersMaxInCombat)
				{
					i = 18;
				}

				while (i != formation.len())
				{
					if (formation[i] == false)
					{
						b.setPlaceInFormation(i);
						formation[i] = true;

						if (i <= 17)
						{
							inCombat = ++inCombat;
						}

						break;
					}

					i = ++i;
				}
			}
		}

		if (inCombat == 0)
		{
			foreach( b in roster )
			{
				b.setPlaceInFormation(3);
				break;
			}
		}
	}

	function updateLook( _updateTo = -1 )
	{
		if (_updateTo == -1)
		{
			_updateTo = this.m.Look;
		}

		this.m.Look = _updateTo;
		_updateTo = _updateTo < 10 ? "0" + _updateTo : _updateTo;
		this.World.State.getPlayer().getSprite("body").setBrush("figure_player_" + _updateTo);
	}

	function saveEquipment()
	{
		this.m.RestoreEquipment = [];
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			if (bro.getPlaceInFormation() > 17)
			{
				continue;
			}

			local store = {
				ID = bro.getID(),
				Slots = []
			};

			for( local i = this.Const.ItemSlot.Mainhand; i <= this.Const.ItemSlot.Ammo; i = ++i )
			{
				local item = bro.getItems().getItemAtSlot(i);

				if (item != null && item != "-1")
				{
					store.Slots.push({
						Item = item,
						Slot = i
					});
				}
			}

			for( local i = 0; i < bro.getItems().getUnlockedBagSlots(); i = ++i )
			{
				local item = bro.getItems().getItemAtBagSlot(i);

				if (item != null && item != "-1")
				{
					store.Slots.push({
						Item = item,
						Slot = this.Const.ItemSlot.Bag
					});
				}
			}

			this.m.RestoreEquipment.push(store);
		}
	}

	function restoreEquipment()
	{
		foreach( s in this.m.RestoreEquipment )
		{
			local bro = this.Tactical.getEntityByID(s.ID);

			if (bro == null || !bro.isAlive())
			{
				continue;
			}

			local currentItems = [];
			local itemsHandled = [];
			local overflowItems = [];

			for( local i = this.Const.ItemSlot.Mainhand; i <= this.Const.ItemSlot.Ammo; i = ++i )
			{
				local item = bro.getItems().getItemAtSlot(i);

				if (item != null && item != "-1")
				{
					currentItems.push({
						Item = item,
						Slot = i
					});
					bro.getItems().unequip(item);
				}
			}

			for( local i = 0; i < bro.getItems().getUnlockedBagSlots(); i = ++i )
			{
				local item = bro.getItems().getItemAtBagSlot(i);

				if (item != null && item != "-1")
				{
					currentItems.push({
						Item = item,
						Slot = this.Const.ItemSlot.Bag
					});
					bro.getItems().removeFromBag(item);
				}
			}

			foreach( item in s.Slots )
			{
				local itemExists = false;

				foreach( current in currentItems )
				{
					if (current.Item.getInstanceID() == item.Item.getInstanceID())
					{
						itemExists = true;
						break;
					}
				}

				if (!itemExists)
				{
					continue;
				}

				if (item.Slot == this.Const.ItemSlot.Bag)
				{
					if (!bro.getItems().addToBag(item.Item))
					{
						overflowItems.push(item.Item);
					}

					itemsHandled.push(item.Item.getInstanceID());
				}
				else
				{
					if (!bro.getItems().equip(item.Item))
					{
						overflowItems.push(item.Item);
					}

					itemsHandled.push(item.Item.getInstanceID());
				}
			}

			foreach( item in currentItems )
			{
				if (itemsHandled.find(item.Item.getInstanceID()) != null)
				{
					continue;
				}

				if (item.Item.getCurrentSlotType() == this.Const.ItemSlot.Bag)
				{
					if (!bro.getItems().addToBag(item.Item))
					{
						overflowItems.push(item.Item);
					}
				}
				else if (!bro.getItems().equip(item.Item))
				{
					overflowItems.push(item.Item);
				}
			}

			foreach( item in overflowItems )
			{
				if (itemsHandled.find(item.getInstanceID()) != null)
				{
					continue;
				}

				if (this.m.Stash.add(item) == null)
				{
					bro.getItems().addToBag(item);
				}
			}
		}

		this.m.RestoreEquipment = [];
	}

	function getGameFinishData( _gameWon )
	{
		if (this.isIronman())
		{
			this.PersistenceManager.deleteStorage(this.getName() + "_" + this.getCampaignID());
			this.m.IsIronman = false;
		}

		local data = {
			Image = "",
			Text = "",
			Score = "" + this.getScore() + "分"
		};
		local brothers = this.World.getPlayerRoster().getAll();
		local excludedBackgrounds = [];

		if (!_gameWon || brothers.len() == 0)
		{
			data.Image = "ui/screens/game_lost.jpg";
			data.Text = "{终于结束了。\n\n乌鸦在倒毙的战团成员上空盘旋，他们终究遇到了旗鼓相当的对手。\n\n%companyname%很快将被世人遗忘，但在这从不缺雇佣兵活计的世道，总有新的战团会前赴后继…… | 乌鸦在%companyname%的尸堆上空盘旋，等着拾荒者离开后享用盛宴。尽管他们曾奋力搏杀，但战团很快就会被遗忘，淹没在后续涌现的众多佣兵战团中。 | 战团已全员战死。等待他们的只有乌鸦与蛆虫。但在这雇佣兵永不失业的世道，总会有新的战团顶替他们的位置…… | %companyname%已全军覆没。你和弟兄们曾拼死奋战，但这对死人毫无意义。或许当初果断撤退才是明智之选？ | 作为%companyname%的团长，你真是给蛆虫送上了饕餮盛宴。战死于此的弟兄很快会被遗忘，但在这刀头舔血永不停歇的世道，总有新的战团会接替他们…… | 你仰望着漫天鸦群，眼中的光芒逐渐黯淡。这具垂死的躯体如此诱人，连拥有飞翔奇迹的生灵都愿屈尊降落，将你分食。 | 你本该带领%companyname%赢取财富与荣耀。或许曾有所获，但此刻躺在尸堆里又有何用？ | %companyname%曾相信你能带来荣耀、财富与美人。如今他们全成了地上尸骸，你也位列其中。世人很快会将他们遗忘，但在这雇佣兵永不缺活计的世道，总会有新的战团涌现…… | 鸦群开始遮蔽天空，令人作呕的啼鸣响彻四野。拾荒者正在翻检你与弟兄们的遗体，你们的武器装备将继续流转，执行你们再也无法掌控的使命。 | 难以断定是从何时开始走错。是最后关头本该撤退却选择死守？还是初次握剑时感到得心应手的那刻？这一切如今还有何意义？\n\n%companyname%已全军覆没，但在这雇佣兵永不失业的世道，总会有新的战团前赴后继…… | 一只乌鸦停在你脚上，用墓园看守般的目光凝视你走向死亡。战团其他成员横陈大地，拾荒者早已开始搜刮财物。 | 你奋战一场，至少在体内的生命缓缓消逝时你是这么宽慰自己的。\n\n战团之名终将湮没于历史，但在这雇佣兵永不缺活计的世道，总会有新的战团接替他们的位置…… | 你以为死亡如同入睡，是一个不知不觉地过程。但此刻不同——剧痛撕扯着每一根神经。你拼命祈求痛苦终止，而后终于得偿所愿。 |  %companyname%这次遇到了克星。虽非首次遭遇强敌，但过往你总能审时度势。这次却判断失误，麾下弟兄全为这个错误献出了生命。 | %companyname%已无人生还。某位史官会在阴暗烛光里记下战团覆灭的讯息。而这份记载终将湮没于洪流，连同战团存在过的所有痕迹一起消失。 | %companyname%将士的鲜血将化作史官的墨汁，所有挣扎与苦难都将沦为注脚，沉没在档案库的黑暗深处。 | 难道这就是你唯一的结局吗？你本可以走出不同的道路。在最后时刻，你拼命回溯往昔，试图在记忆中找到避开此刻结局的可能，寻求对抗这残酷终局的庄重解药。 | %companyname%的尸骸遍布荒野，即将成为蛆虫与乌鸦的食粮，一身甲胄尽成虚设。战死于此的将士很快会被遗忘，但在这雇佣兵永不失业的世道，总会有新的战团前赴后继…… | 真是份大礼——耗费时间金钱为弟兄置办武器装备，最终却便宜了拾荒者。献给乌鸦蛆虫的肉身馈赠同样值得嘉奖。恭喜。 | 不出几年，%companyname%的事迹就会彻底被遗忘。当酒客向酒保打听佣兵旧事时，他稍作思索，你的面容便从记忆中淡去，名号随之消散。最终他只会耸耸肩继续斟酒。 | 当光芒从你的世界褪去时，你仍奢望%companyname%的威名能长存于世，奢望世人铭记他们的功绩——但不会的。 | 当剧痛席卷全身，你索性抛弃物质世界，退守到意识深处，筑起壁垒，拼命寻找选择这种人生的合理缘由——此刻已再明显不过：你选择的生涯也选择了你的死亡。 | %companyname%已无人生还，你的尸身混在弟兄中间，再无需区分阶位。这是宿命吗？你们的死会催生新的力量吗？抑或世界依旧如常运转？ | 你曾施加于他人的残酷终结，如今完整回报给%companyname%。鲜少有人会提及你们，就连宣告尸体归属的乌鸦啼鸣都比这频繁。在这雇佣兵永不失业的世道，总会有新的战团前赴后继…… | %companyname%已被彻底歼灭，连最后一位弟兄也未能幸免。拾荒者正在尸堆中翻捡，为每件战利品发出惊喜的呼喊。你让他们收获颇丰——可惜这是以你的终局为代价。}";
		}
		else if (this.m.BusinessReputation >= 6000 && this.World.Statistics.getFlags().get("GreaterEvilsDefeated") >= 2)
		{
			this.Music.setTrackList(this.Const.Music.Retirement4Tracks, this.Const.Music.CrossFadeTime);
			this.updateAchievement("LeavingALegacy", 1, 1);
			data.Image = "ui/screens/retirement_04.jpg";
			data.Text = "{你经历的传奇连梦境都望尘莫及！在你的的统领下，%companyname%不仅积累了巨额财富、荣耀与声望，更亲手粉碎了无数险些摧毁整个国度的邪恶势力、外敌入侵与战乱！ | %companyname%的威名已传遍四方。战团不仅聚集了海量财富、权势与声望，更在化解多场席卷大地的危机中扮演了关键角色。史官学者必将传颂你们的传奇——纵使千年之后，世人仍将铭记%companyname%的英名！ | 退役后，一位史馆带着画师登门拜访。他们为你绘制肖像，并将你的讲述记录在长长的卷轴上。看来，凭借化解多次危机与积累的惊人财富，%companyname%必将流芳百世！ | 离开%companyname%并非易事，但你深知这是正确的抉择。而此刻急流勇退恰逢其时：战团已名震四海，成功化解连番危机，最重要的是——积累了前所未闻的巨额财富！ | 在你的统帅下，%companyname%不仅威震八方，更因终结了威胁整个国度的系列危机而备受敬仰！佣兵虽少有幸青史留名，但你确信史官学者们必将为书写%companyname%的传奇而耗尽墨水！}";
			this.removeSuccessor(brothers);
			data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, true);
			data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, true);
			data.Text += "\n\n{前些天有个隐士来到你木屋前，问你是否听说过%companyname%。你摇头佯装感兴趣。这野人声称那是全境最了不起的战团。你问他是否确定。隐士猛地后仰，仿佛受了天大侮辱。%SPEECH_ON%确定？先生你最好坐下。让我好好说说%companyname%——据说当年统领战团的是个七尺巨汉，浑身腱子肉，名字叫……%SPEECH_OFF% | 下定决心离开战团谈何容易，不过现在你城堡里有间屋子能让你在金币堆里打滚，倒也不算太糟。 | 如今你对着金山银山竟不知如何消遣。各色人等络绎不绝地造访城堡——体态各异的姑娘，提出奇葩敛财计划的怪人，以及许多屈尊亲自来找你求教兵法的王公贵族。偶尔，你在花园里砍柴时会萌生重返战场的念头。无聊，是你迄今面对的最恶心难缠的野兽。 | 前几天有人来到你城堡，想请教如何组建佣兵团——显然是受你事迹鼓舞。你问他之前找过多少成功的佣兵讨教。他耸肩道：%SPEECH_ON%你是目前唯一一个。%SPEECH_OFF%你点头回应：%SPEECH_ON%没错。尽管世上出现过成百上千我这样的佣兵，但活到现在的就我一个。或许是因为我特别厉害，不过实话实说——纯粹是运气好。所以想要组建佣兵团的建议，那就是别干这行。就这样。仆人会送你出去，祝今日愉快。%SPEECH_OFF% | 打理菜园时发现只老鼠在啃番茄。这小家伙醉心于美味，让你不费吹灰之力就双手擒住。当你凝视它时，绝望的认命神情在鼠脸上蔓延——它半张嘴还叼着番茄碎屑。仆人急忙跑来：%SPEECH_ON%我来处理，老爷。%SPEECH_OFF%你瞅瞅仆人又看看老鼠：%SPEECH_ON%不必，我打算养着它当个朋友。%SPEECH_OFF%仆人低下头。你拍拍他肩膀：%SPEECH_ON%开心点，你也是我的朋友！%SPEECH_OFF%仆人笑了：%SPEECH_ON%谢谢老爷。%SPEECH_OFF%}";
		}
		else if (this.World.Statistics.getFlags().get("GreaterEvilsDefeated") >= 1)
		{
			this.Music.setTrackList(this.Const.Music.Retirement3Tracks, this.Const.Music.CrossFadeTime);
			this.updateAchievement("LeavingAMark", 1, 1);
			data.Image = "ui/screens/retirement_03.jpg";
			this.removeSuccessor(brothers);

			if (this.World.FactionManager.getGreaterEvil().LastType == this.Const.World.GreaterEvilType.CivilWar)
			{
				data.Text = "{接手%companyname%时，你曾怀揣着宏图壮志——幻想着终有一日能坐上国王宝座，用金杯畅饮世间最昂贵的佳酿。这部分虽未实现，但确实带领战团在贵族内战中登上了巅峰。\n\n 权贵间的倾轧从来不可避免，你巧妙利用这些冲突为%companyname%赢得了声望与财富。当然，战争的残酷也让你明白武人的性命何其短暂无常。当尘埃落定，你清醒地认识到在贵族眼中，你在这场冲突中扮演的角色根本无足轻重。你始终只是枚棋子，永远都是枚棋子。深刻反思后，你决定急流勇退，在能力范围内将战团安置妥当。 | 初掌%companyname%时，你坚信能带领它成就伟业。这目标或许过于远大，但至少成功铸就了声名显赫的战团。当贵族们不可避免地滑向战争时，%companyname%的服务成为境内最抢手的资源——这完全在你意料之中。这场战争的残酷程度前所未见，但至少这次你赚得的金币多到不知如何挥霍。\n\n带着金山隐退后，你将战团交给当时最骁勇善战的佣兵统领。直至今日，这支队伍仍在续写传奇。}";
				data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, true);
				data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, true);
				data.Text += "\n\n{佣兵这行能全身而退的实在不多，但你就是做到了。虽说身子骨硬朗、神志清明很重要，可你最满意的还是攒下的克朗多得能当床睡。最近风闻贵族老爷们又在吵吵着要开战，你连眼皮都懒得抬。 | 身心俱健的你继续过着还算太平的日子。这几个月来最糟心的事，无非是有个隐士从野地里钻出来偷你柴火。这不正是你一直向往的生活么，如今过得再满意不过。}";
			}
			else if (this.World.FactionManager.getGreaterEvil().LastType == this.Const.World.GreaterEvilType.Greenskins)
			{
				data.Text = "{当年接手%companyname%时，你可没料到历史会以最糟糕的方式重演。\"万名之战\"本只是传说中的故事，但亲眼目睹绿皮大军如传说般从东方涌来——这场面着实令人难忘。而你已做好迎战准备。\n\n 尽管史书可能不会大书特书，但你坚信战团在击溃那群绿色蛮族时发挥了关键作用。否则眼前这座金山银山又是从何而来？\n\n 正是靠着这堆金币，你决定急流勇退，将战团交托给最可靠的人。 | 史书将人类与绿皮大军在多年以前的那场决战称为\"万名之战\"。你原以为这不过是个尘封的历史故事，直到目睹野蛮人浪潮从东方地平线涌来。这次兽人和地精学会了全面入侵而非单点突破。尽管绿皮有了新战术，但人类世界也有了新武器：%companyname%。\n\n 或许只是你的自负，但你真心相信战团那些看似唯利是图的行动，确实在扭转绿色狂潮中起了关键作用。随着绿皮溃败，你带着足以养老的金山解甲归田，把战团指挥权交给了最出色的弟兄。}";
				data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, true);
				data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, true);
				data.Text += "\n\n{有些深夜你会猛然惊醒，满头大汗，狂战士般的嘶吼逐渐消散在未竟之梦的残影里。这些噩梦如影随形，仿佛是你获得新财富的终极代价。尽管%companyname%发展顺利，你偶尔仍会想：是否重新执掌战团才是更好的选择？在这所谓的‘平静’退休生活里，你终于明白能亲手斩杀的恐怖，与潜藏在内心最深处的恐惧有着天壤之别。 | 如今你的日常就是打理菜园，宰杀那些闯入你新领地的兔子。偶尔会听到%companyname%的消息——那些战功赫赫的传奇，当然也不时传来某位弟兄阵亡的噩耗。这些传闻成了终日驱赶兔子的生活中难得的调剂。你打了大半辈子仗，从未意识到种田人和这些天杀的动物之间也存在着战争。}";
			}
			else if (this.World.FactionManager.getGreaterEvil().LastType == this.Const.World.GreaterEvilType.Undead)
			{
				data.Text = "{你曾以为早已看透世间的残酷。刚接手%companyname%时，还笃定能带领战团名利双收。直到亡者爬出坟茔，才明白这种天真多么可笑。但你很快调整策略，专接报酬最丰厚的合约来应对这诡异威胁。亡灵大军最终被赶回了老巢。\n\n财富、荣誉、声望尽入囊中。你选择急流勇退，将战团托付给最得力的弟兄。 | 接手%companyname%时，你怎会预见将来竟要靠它击退亡灵大军。不过猎杀亡者的特殊赏金确实利润惊人，趁着邪祟溃散后攒下的金山银山，你当即决定见好就收。%companyname%被交托给了最值得信赖的成员。}";
				data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, true);
				data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, true);
				data.Text += "\n\n{如今你整天琢磨着该不该给木屋加个二层，又嫌太费事。虽说可以雇人帮忙，但签合同雇人这事总让你觉得别扭。至于%companyname%，听说至今仍混得风生水起。 | 现在你整天跟邻居妇人调情。虽然她已嫁作人妇，但这反而更添情趣。治安官还特意上门找你谈过这新癖好——眼下这大概就是你的人生巅峰了。虽不比当年躲兽人砍亡灵刺激，却别有一番趣味。你丝毫不怀念过去，反而满足于能清闲地听着%companyname%的成功事迹。}";
			}
			else if (this.World.FactionManager.getGreaterEvil().LastType == this.Const.World.GreaterEvilType.HolyWar)
			{
				data.Text = "{执掌%companyname%时，你本以为不过是带点土匪习气的佣兵营生。岂料整个世界都陷入宗教动荡。当北方与南方带着神圣怒火相互征伐时，你率领战团赚得盆满钵满。旧神信徒若要借你之剑，你便携北境群山之力降临；镀金者若渴求光明，你连烈日都能为其擒来。 | 都说凡人越是虔诚，神明就越显人性。当南北宗教的嫌隙爆发成冲突时，形形色色的宗教投机者涌过神圣门槛。信徒们将自身意志神化，把战争利器磨得铮亮，仿佛真是神祇亲自下令。或许真是如此，但你始终只关心%companyname%如何为自己谋利。镀金者？旧神？你唯一在意的只有自己的钱袋——待到这场神圣闹剧落幕时，它们早已被塞得满满当当。}";
				data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, true);
				data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, true);
				data.Text += "\n\n{佣兵团能存活下来的本就不多，青史留名的更是凤毛麟角。你相信%companyname%在圣战中的表现，足以在史册中赢得一个体面的脚注。这个念头让你不禁莞尔——区区一两行文字，怎能道尽你亲历的峥嵘岁月？ | 从%companyname%退役后，你终于有空闲仔细琢磨那些旧神与镀金者的教义。或许其中某个信仰确有道理？抑或两者皆对。再或者——你谨慎地掂量着这个想法——两者皆错。但看来这些信仰并非仅有的选择。宗教起义正如雨后春笋般涌现，无疑都是宗教战争残骸中滋生的产物。就在前几日，第三股重要势力找上门来，正是你再熟悉不过的：达库尔的门徒。当他开始宣扬那些黑暗秘法时，你直接摔门送客。改日再说吧，你还要劈柴和整理袜屉呢。}";
			}
		}
		else if (this.m.BusinessReputation >= 1100 && this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			this.Music.setTrackList(this.Const.Music.Retirement2Tracks, this.Const.Music.CrossFadeTime);
			this.updateAchievement("ABitterEnd", 1, 1);
			data.Image = "ui/screens/retirement_02.jpg";

			if (this.Math.rand(1, 100) <= 25)
			{
				data.Text = "你成功重建了%companyname%。不仅竭力为战团补充新鲜血液，更让这个名号重新响彻四方。最终急流勇退时，你将指挥权交予%highestbravery_bro%并寄予厚望。在他的统领下，%companyname%发展得相当不错，凡有刀头舔血的买卖总少不了他们的身影。然而在你离开数月后，贵族间的宿怨骤然升级。%highestbravery_bro%毫不犹豫地抓住这个为战团敛取战争横财的良机，但队伍里有人却另有打算。";
				this.removeSuccessor(brothers);
				data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, true);
				data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, false);
				data.Text += "贵族们自有其凶险的棋局，而%highestbravery_bro%未能窥见其中杀机。几场小规模交锋告捷后，%companyname%突然陷入重围，既无退路，也无援军。他们被当作弃子牺牲，沦为诱敌深入的幌子，好让主力在别处出击。佣兵终究是耗材，何况死人无需支付酬金——这场战役对整个战局无足轻重，却让战团遭受了无法愈合的重创。\n\n战争又持续了两年，但硝烟散尽时，世上已几乎无人记得‘%companyname%’这个名号了……";
			}
			else
			{
				data.Text = "{你将%companyname%打造成声名显赫的战团后，贵族们竞相争取你们的服务——不仅为让你们效命，更为了确保不必与你们为敌！随着克朗滚滚而来，加上对战团能独立发展的信心，你认定是时候封剑归隐，远离杀戮了。\n\n然而盛名终需代价。战团不断卷入战时合约，逐渐消耗殆尽。弟兄们开始陆续离开，唯恐成为下一个自以为能指挥佣兵的贵族老爷的牺牲品。 | 在你离开战团归隐山林之后，听说%companyname%在贵族间的声望与日俱增。每逢战事，伯爵男爵们必会找上门来。但盛名之下代价沉重。每场新冲突都伴随着伤亡，战团实力缓慢而持续地衰减，成员或因战损减少，或像你当年那样及时抽身。最后传来的消息是，某贵族指挥官让战团担任正面突击任务，几乎导致全军覆没。 | 初掌%companyname%时不过是为求生计挣扎的寥寥数人，后来却成了轰轰烈烈的商业冒险。但以杀戮为业终非你愿。攒够钱财后，你便将战团交托给最信任的%successor%后隐退。\n\n可惜继任者缺乏保全弟兄的能耐。据最后传来的消息，他们接连承接合约，只顾追逐克朗却罔顾安危。这种冒进最终使战团在某次贵族纷争中覆灭——尽管%companyname%声名在外，某贵族男爵仍毫不犹豫将其作为诱饵牵制大军。万幸的是，仍有少数成员在那场决战前及时退休。}";
				this.removeSuccessor(brothers);
				data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, true);
				data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, false);
				data.Text += "\n\n{佣兵这行当本就如此。有人功成名就，有人折戟沉沙。没有哪个战团能永存于世，青史留名的更是凤毛麟角。你打算安稳度过余生，也希望那些从刀口舔血生涯中幸存的老伙计们各自安好。 | 这就是佣兵的宿命。有人赢，有人输——说实话大多数都是输家。你努力将往事抛在脑后，准备平静地度过余生。 | 佣兵生涯本就如此。这行唯一确定的事就是谁都不敢保证能全身而退。入行时大家都心知肚明，你自己也不例外。你侥幸生还，别人却没这运气。世道如此。你打算尽力过好往后的日子，不仅为自己，也为那些没能走到今天的弟兄。}";
			}
		}
		else
		{
			this.Music.setTrackList(this.Const.Music.Retirement1Tracks, this.Const.Music.CrossFadeTime);
			this.updateAchievement("EarlyRetirement", 1, 1);
			data.Image = "ui/screens/retirement_01.jpg";
			data.Text = "{失去你的统领后，%companyname%迅速分崩离析。众人各奔前程，可除了打仗别无长技的汉子又能何去何从？ | %companyname%在你退休后不久便宣告瓦解。新任指挥不仅接的尽是烂合同，实战指挥更是糟糕透顶。既然赚钱打胜仗是这行的根本，战团在你离开后迅速没落也就不足为奇了。 | 自从你卸任后，%companyname%接连签下好几笔烂合同，最终走向解体。 | 你选择在刀剑加身发出凄厉惨叫之前及时退役——这行当没人能幸免。一位弟兄接手了战团，但骁勇善战的佣兵与杰出领袖终究天差地别。%companyname%接连遭遇糟糕合同与惨烈败仗，最终走向覆灭。 | 退役的决定对你和%companyname%都同样艰难——战团曾竭力挽留。但大势已定，你终究转身离去。一名佣兵接掌了队伍，然而善战者未必善治，战团很快便土崩瓦解。 | 弟兄们曾努力挽留，但你认定是时候金盆洗手。最后听说%companyname%的新指挥官不慎签下致命合约。报酬少得可怜，战况更是一败涂地。经此重创，战团彻底瓦解。}";
			data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, false);
			data.Text += this.addBrotherEnding(brothers, excludedBackgrounds, false);
			data.Text += "\n\n{你再没收到过老伙计们的消息——不过退休后积蓄日渐见底，你也顾不得别人了…… | 如今你蜷缩在破屋里，唯有一豆烛火相伴，开始后悔当初的决定。自己的境况每况愈下，而关于旧部的传闻更让你寝食难安。 | 此刻你窝在棚屋里，与一群挤着取暖的陌生醉汉相伴。借着微弱的烛光，你摩挲着%companyname%磨损的徽章，在回忆里寻求慰藉。直到有人咳嗽着吹灭烛火，最后的光亮也随之熄灭。 | 如今你蜷在酒馆的地下室里，与连单间都住不起的流浪汉挤作一团。想重操旧业当佣兵，可身无分文只能从底层做起，多半还得受蠢材指挥。穷死还是被蠢死——眼下似乎只剩这两种选择。 | 此刻你独坐酒馆，将最后几枚硬币换麦酒灌下。正当仰头畅饮时，一名高壮男子踏入酒馆。皮底环甲覆盖着他的双腿与胸肩，银线刺绣的鞘中露出金柄武器。他拳抵胯骨扫视全场：%SPEECH_ON%有谁想靠杀人赚克朗？我找佣兵。只要会挥剑且不怕挨砍就行。%SPEECH_OFF%你饮尽残酒，那佣兵头子转向你，仿佛早已知晓你的来历与能耐。 | 老兄弟们的音讯再难打听。几个月后，你放弃了追寻他们的下落。如今只是眼睁睁看着积蓄消耗殆尽，每个夜晚都在与自我怀疑抗争——当初为何会选择这样的结局。}";
		}

		data.Text += "\n\n";
		data.Text = this.buildGameFinishText(data.Text);
		return data;
	}

	function addBrotherEnding( _brothers, _excludedBackgrounds, _isPositive )
	{
		local removeIndex;
		local candidates = [];

		foreach( i, bro in _brothers )
		{
			if (_excludedBackgrounds.find(bro.getBackground().getID()) != null)
			{
				continue;
			}

			if (_isPositive && bro.getBackground().getGoodEnding() != null)
			{
				candidates.push({
					Index = i,
					Bro = bro
				});
			}
			else if (!_isPositive && bro.getBackground().getBadEnding() != null)
			{
				candidates.push({
					Index = i,
					Bro = bro
				});
			}
		}

		if (candidates.len() == 0)
		{
			return "";
		}

		local bro = candidates[this.Math.rand(0, candidates.len() - 1)];
		_brothers.remove(bro.Index);
		_excludedBackgrounds.push(bro.Bro.getBackground().getID());
		local villages = this.World.EntityManager.getSettlements();
		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local vars = [
			[
				"SPEECH_ON",
				"\n\n[color=#bcad8c]\""
			],
			[
				"SPEECH_OFF",
				"\"[/color]\n\n"
			],
			[
				"companyname",
				this.World.Assets.getName()
			],
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomnoblehouse",
				nobleHouses[this.Math.rand(0, nobleHouses.len() - 1)].getName()
			],
			[
				"randomnoble",
				this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)]
			],
			[
				"randomtown",
				villages[this.Math.rand(0, villages.len() - 1)].getNameOnly()
			],
			[
				"name",
				bro.Bro.getNameOnly()
			]
		];

		if (_isPositive)
		{
			return "\n\n" + this.buildTextFromTemplate(bro.Bro.getBackground().getGoodEnding(), vars);
		}
		else
		{
			return "\n\n" + this.buildTextFromTemplate(bro.Bro.getBackground().getBadEnding(), vars);
		}
	}

	function removeSuccessor( _brothers )
	{
		local highest_bravery = 0;
		local highest_bravery_bro;

		foreach( i, bro in _brothers )
		{
			if (bro.getCurrentProperties().getBravery() > highest_bravery)
			{
				highest_bravery = bro.getCurrentProperties().getBravery();
				highest_bravery_bro = i;
			}
		}

		_brothers.remove(highest_bravery_bro);
	}

	function buildGameFinishText( _text )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local villages = this.World.EntityManager.getSettlements();
		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local text;
		local vars = [
			[
				"SPEECH_ON",
				"\n\n[color=#bcad8c]\""
			],
			[
				"SPEECH_OFF",
				"\"[/color]\n\n"
			],
			[
				"companyname",
				this.World.Assets.getName()
			],
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomnoblehouse",
				nobleHouses[this.Math.rand(0, nobleHouses.len() - 1)].getName()
			],
			[
				"randomnoble",
				this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)]
			],
			[
				"randomtown",
				villages[this.Math.rand(0, villages.len() - 1)].getNameOnly()
			]
		];

		if (brothers.len() != 0)
		{
			local brother1 = this.Math.rand(0, brothers.len() - 1);
			local brother2 = this.Math.rand(0, brothers.len() - 1);

			if (brothers.len() >= 2)
			{
				while (brother1 == brother2)
				{
					brother2 = this.Math.rand(0, brothers.len() - 1);
				}
			}

			brother1 = brothers[brother1].getName();
			brother2 = brothers[brother2].getName();
			local highest_bravery = 0;
			local highest_bravery_bro;

			foreach( bro in brothers )
			{
				if (bro.getCurrentProperties().getBravery() > highest_bravery)
				{
					highest_bravery = bro.getCurrentProperties().getBravery();
					highest_bravery_bro = bro;
				}
			}

			vars.extend([
				[
					"randombrother",
					brother1
				],
				[
					"randombrother2",
					brother2
				],
				[
					"highestbravery_bro",
					highest_bravery_bro.getName()
				],
				[
					"successor",
					highest_bravery_bro.getName()
				]
			]);
		}

		return this.buildTextFromTemplate(_text, vars);
	}

	function getScore()
	{
		local s = this.m.Score;
		local namedItems = 0;
		local legendaryItems = 0;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null)
			{
				s = s + item.getValue() * 0.002;

				if (item.isItemType(this.Const.Items.ItemType.Named))
				{
					namedItems = ++namedItems;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Legendary) && item.getID() != "armor.head.fangshire")
				{
					legendaryItems = ++legendaryItems;
				}
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			s = s + bro.getLevel() * 4;
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null)
			{
				s = s + item.getValue() * 0.002;

				if (item.isItemType(this.Const.Items.ItemType.Named))
				{
					namedItems = ++namedItems;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Legendary))
				{
					legendaryItems = ++legendaryItems;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

			if (item != null)
			{
				s = s + item.getValue() * 0.002;

				if (item.isItemType(this.Const.Items.ItemType.Named))
				{
					namedItems = ++namedItems;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Legendary))
				{
					legendaryItems = ++legendaryItems;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

			if (item != null)
			{
				s = s + item.getValue() * 0.002;

				if (item.isItemType(this.Const.Items.ItemType.Named))
				{
					namedItems = ++namedItems;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Legendary) && item.getID() != "armor.head.fangshire")
				{
					legendaryItems = ++legendaryItems;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null)
			{
				s = s + item.getValue() * 0.002;

				if (item.isItemType(this.Const.Items.ItemType.Named))
				{
					namedItems = ++namedItems;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Legendary))
				{
					legendaryItems = ++legendaryItems;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null)
			{
				s = s + item.getValue() * 0.002;

				if (item.isItemType(this.Const.Items.ItemType.Named))
				{
					namedItems = ++namedItems;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Legendary))
				{
					legendaryItems = ++legendaryItems;
				}
			}

			for( local i = 0; i < bro.getItems().getUnlockedBagSlots(); i = ++i )
			{
				local item = bro.getItems().getItemAtBagSlot(i);

				if (item != null)
				{
					s = s + item.getValue() * 0.002;

					if (item.isItemType(this.Const.Items.ItemType.Named))
					{
						namedItems = ++namedItems;
					}
					else if (item.isItemType(this.Const.Items.ItemType.Legendary))
					{
						legendaryItems = ++legendaryItems;
					}
				}
			}
		}

		s = s + 25 * namedItems;
		s = s + 100 * legendaryItems;
		s = s + (this.getBusinessReputation() - 100) * 0.25;

		if (this.World.Statistics.getFlags().has("GreaterEvilsDefeated") && this.World.Statistics.getFlags().get("GreaterEvilsDefeated") >= 1)
		{
			s = s * this.Math.pow(1.25, this.World.Statistics.getFlags().get("GreaterEvilsDefeated"));
		}

		s = s / this.Math.maxf(10.0, this.World.getTime().Days);
		return this.Math.max(0, this.Math.round(s * 10));
	}

	function onSerialize( _out )
	{
		_out.writeU16(this.m.Stash.getCapacity());
		this.m.Stash.onSerialize(_out);
		_out.writeI32(this.m.CampaignID);
		_out.writeString(this.m.Name);
		_out.writeString(this.m.Banner);
		_out.writeU8(this.m.BannerID);
		_out.writeU8(this.m.Look);
		_out.writeU8(this.m.EconomicDifficulty);
		_out.writeU8(this.m.CombatDifficulty);
		_out.writeBool(this.m.IsIronman);
		_out.writeBool(!this.m.IsPermanentDestruction);
		_out.writeString(this.m.Origin.getID());
		_out.writeString(this.m.SeedString);
		_out.writeF32(this.m.Money);
		_out.writeF32(this.m.Ammo);
		_out.writeF32(this.m.ArmorParts);
		_out.writeF32(this.m.Medicine);
		_out.writeU32(this.m.BusinessReputation);
		_out.writeF32(this.m.MoralReputation);
		_out.writeF32(this.m.Score);
		_out.writeU16(this.m.LastDayPaid);
		_out.writeU8(this.m.LastHourUpdated);
		_out.writeF32(this.m.LastFoodConsumed);
		_out.writeBool(this.m.IsCamping);
		_out.writeBool(this.m.IsExplorationMode);
	}

	function onDeserialize( _in )
	{
		this.m.Stash.resize(_in.readU16());
		this.m.Stash.onDeserialize(_in);

		if (this.m.OverflowItems.len() != 0)
		{
			foreach( item in this.m.OverflowItems )
			{
				this.m.Stash.add(item);
			}

			this.m.OverflowItems = [];
		}

		this.m.CampaignID = _in.readI32();
		this.m.Name = _in.readString();
		this.m.Banner = _in.readString();
		this.m.BannerID = _in.readU8();
		this.m.Look = _in.readU8();
		this.m.EconomicDifficulty = _in.readU8();
		this.m.CombatDifficulty = _in.readU8();
		this.m.IsIronman = _in.readBool();
		this.m.IsPermanentDestruction = !_in.readBool();

		if (_in.getMetaData().getVersion() >= 46)
		{
			this.m.Origin = _in.readString();
			this.m.Origin = this.Const.ScenarioManager.getScenario(this.m.Origin);
		}

		if (this.m.Origin == null)
		{
			this.m.Origin = this.Const.ScenarioManager.getScenario("scenario.tutorial");
		}

		if (_in.getMetaData().getVersion() >= 41)
		{
			this.m.SeedString = _in.readString();
		}
		else
		{
			_in.readI32();
			this.m.SeedString = "未知的";
		}

		if (_in.getMetaData().getVersion() < 64 && this.m.Origin != null && this.m.Origin.getID() == "scenario.manhunters")
		{
			this.m.Stash.add(this.new("scripts/items/misc/manhunters_ledger_item"));
		}

		this.m.Money = _in.readF32();
		this.m.Ammo = this.Math.max(0, _in.readF32());
		this.m.ArmorParts = this.Math.max(0, _in.readF32());
		this.m.Medicine = this.Math.max(0, _in.readF32());
		this.m.BusinessReputation = _in.readU32();
		this.m.MoralReputation = _in.readF32();
		this.m.Score = _in.readF32();
		this.m.LastDayPaid = _in.readU16();
		this.m.LastHourUpdated = _in.readU8();
		this.m.LastFoodConsumed = _in.readF32();
		this.m.IsCamping = _in.readBool();
		this.updateAverageMoodState();
		this.updateFood();
		this.updateFormation();
		this.m.IsExplorationMode = _in.readBool();
		this.m.Origin.onInit();
	}

};
