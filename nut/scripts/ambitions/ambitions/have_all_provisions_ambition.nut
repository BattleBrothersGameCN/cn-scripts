this.have_all_provisions_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_all_provisions";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我知道你们已经厌倦了我们日复一日的霉运与陈腐食物。我们\n会从这片大陆上收集各种各样的食物和饮品，举办一场盛宴！";
		this.m.RewardTooltip = "能大大改善你手下的情绪。";
		this.m.UIText = "拥有每种类型的食物";
		this.m.TooltipText = "获得每种类型的食物，举办一场盛宴。";
		this.m.SuccessText = "[img]gfx/ui/events/event_61.png[/img]花大力气奔走在粮商与农夫之间，你收集到了整日山珍海味的贵族也会注目的食物。眼见储藏室被堆得满满当当，你随即为%companyname%举办了一场盛宴，请兄弟们吃个够。你的兄弟们立即投入‘战斗’。礼仪里缺了的就在饭量里补上。%randombrother%利用这个机会分享他对肉类的知识%SPEECH_ON%这只野兽死的时候心里充满了喜悦，这就是为什么它如此嫩滑。%SPEECH_OFF%%strongest_brother%打了个雷鸣般的嗝，引来了他战友们的钦佩。%SPEECH_ON%这么说挺不好意思的，但我接下来只能喝水顺气，喝不下再多酒了。%SPEECH_OFF%在这之后，说话的声音少了许多，但油腻的胡子和饱满的肚子保证了他们会在下次跟你见面时心情愉快。";
		this.m.SuccessButtonText = "这是你们应得的。";
	}

	function getTooltipText()
	{
		if (this.hasAllProvisions())
		{
			return this.m.TooltipText;
		}

		local fish = false;
		local beer = false;
		local bread = false;
		local cured_venison = false;
		local dried_fish = false;
		local dried_fruits = false;
		local goat_cheese = false;
		local ground_grains = false;
		local mead = false;
		local mushrooms = false;
		local berries = false;
		local smoked_ham = false;
		local wine = false;
		local cured_rations = false;
		local dates = false;
		local rice = false;
		local dried_lamb = false;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (item.getID() == "supplies.beer")
				{
					beer = true;
				}
				else if (item.getID() == "supplies.bread")
				{
					bread = true;
				}
				else if (item.getID() == "supplies.cured_venison")
				{
					cured_venison = true;
				}
				else if (item.getID() == "supplies.dried_fish")
				{
					dried_fish = true;
				}
				else if (item.getID() == "supplies.dried_fruits")
				{
					dried_fruits = true;
				}
				else if (item.getID() == "supplies.goat_cheese")
				{
					goat_cheese = true;
				}
				else if (item.getID() == "supplies.ground_grains")
				{
					ground_grains = true;
				}
				else if (item.getID() == "supplies.mead")
				{
					mead = true;
				}
				else if (item.getID() == "supplies.pickled_mushrooms")
				{
					mushrooms = true;
				}
				else if (item.getID() == "supplies.roots_and_berries")
				{
					berries = true;
				}
				else if (item.getID() == "supplies.smoked_ham")
				{
					smoked_ham = true;
				}
				else if (item.getID() == "supplies.wine")
				{
					wine = true;
				}
				else if (item.getID() == "supplies.dates")
				{
					dates = true;
				}
				else if (item.getID() == "supplies.rice")
				{
					rice = true;
				}
				else if (item.getID() == "supplies.dried_lamb")
				{
					dried_lamb = true;
				}
				else if (item.getID() == "supplies.cured_rations")
				{
					cured_rations = true;
				}
			}
		}

		local ret = this.m.TooltipText + "\n\n你还缺少一些食物。\n";

		if (!beer)
		{
			ret = ret + "\n- 啤酒";
		}

		if (!bread)
		{
			ret = ret + "\n- 面包";
		}

		if (!cured_venison)
		{
			ret = ret + "\n- 腌鹿肉";
		}

		if (!dried_fish)
		{
			ret = ret + "\n- 鱼干";
		}

		if (!dried_fruits)
		{
			ret = ret + "\n- 果脯";
		}

		if (!ground_grains)
		{
			ret = ret + "\n- 谷物";
		}

		if (!goat_cheese)
		{
			ret = ret + "\n- 山羊奶酪";
		}

		if (!mead)
		{
			ret = ret + "\n- 蜜酒";
		}

		if (!mushrooms)
		{
			ret = ret + "\n- 蘑菇";
		}

		if (!berries)
		{
			ret = ret + "\n- 根茎和浆果";
		}

		if (!smoked_ham)
		{
			ret = ret + "\n- 熏火腿";
		}

		if (!wine)
		{
			ret = ret + "\n- 葡萄酒";
		}

		if (!cured_rations)
		{
			ret = ret + "\n- 精制口粮";
		}

		if (this.Const.DLC.Desert)
		{
			if (!dates)
			{
				ret = ret + "\n- 枣子";
			}

			if (!rice)
			{
				ret = ret + "- 大米";
			}

			if (!dried_lamb)
			{
				ret = ret + "\n- 羊肉干";
			}
		}

		return ret;
	}

	function hasAllProvisions()
	{
		local beer = false;
		local bread = false;
		local cured_venison = false;
		local dried_fish = false;
		local dried_fruits = false;
		local goat_cheese = false;
		local ground_grains = false;
		local mead = false;
		local mushrooms = false;
		local berries = false;
		local smoked_ham = false;
		local wine = false;
		local cured_rations = false;
		local dates = false;
		local rice = false;
		local dried_lamb = false;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (item.getID() == "supplies.beer")
				{
					beer = true;
				}
				else if (item.getID() == "supplies.bread")
				{
					bread = true;
				}
				else if (item.getID() == "supplies.cured_venison")
				{
					cured_venison = true;
				}
				else if (item.getID() == "supplies.dried_fish")
				{
					dried_fish = true;
				}
				else if (item.getID() == "supplies.dried_fruits")
				{
					dried_fruits = true;
				}
				else if (item.getID() == "supplies.goat_cheese")
				{
					goat_cheese = true;
				}
				else if (item.getID() == "supplies.ground_grains")
				{
					ground_grains = true;
				}
				else if (item.getID() == "supplies.mead")
				{
					mead = true;
				}
				else if (item.getID() == "supplies.pickled_mushrooms")
				{
					mushrooms = true;
				}
				else if (item.getID() == "supplies.roots_and_berries")
				{
					berries = true;
				}
				else if (item.getID() == "supplies.smoked_ham")
				{
					smoked_ham = true;
				}
				else if (item.getID() == "supplies.wine")
				{
					wine = true;
				}
				else if (item.getID() == "supplies.dates")
				{
					dates = true;
				}
				else if (item.getID() == "supplies.rice")
				{
					rice = true;
				}
				else if (item.getID() == "supplies.dried_lamb")
				{
					dried_lamb = true;
				}
				else if (item.getID() == "supplies.cured_rations")
				{
					cured_rations = true;
				}
			}
		}

		if (!this.Const.DLC.Desert)
		{
			return beer && bread && cured_venison && dried_fish && dried_fruits && goat_cheese && ground_grains && mead && mushrooms && berries && smoked_ham && wine && cured_rations;
		}
		else
		{
			return beer && bread && cured_venison && dried_fish && dried_fruits && goat_cheese && ground_grains && mead && mushrooms && berries && smoked_ham && wine && cured_rations && dates && rice && dried_lamb;
		}
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getAverageMoodState() > this.Const.MoodState.Concerned)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		if (this.hasAllProvisions())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.hasAllProvisions())
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.improveMood(1.0, "与战团共享盛宴");
		}
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});
