this.allied_nobles_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.allied_nobles";
		this.m.Duration = 40.000000 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们应赢得一个贵族家族的信任，成为他们的盟友。\n他们自然会与好朋友分享他们丰富的军械库。";
		this.m.RewardTooltip = "你将被授予与你结盟的贵族家族独有的装备";
		this.m.UIText = "与一个贵族家族达到“盟友”关系";
		this.m.TooltipText = "通过履行派系成员的合同，将与任何贵家族族的关系提升至“盟友”。不履行合同或背叛他们的信任会降低你们的关系。";
		this.m.SuccessText = "[img]gfx/ui/events/event_78.png[/img]你早就听说贵族是一群难以相处、善变的人，而且你的经历也证明了这一点，但你与%noblehouse%的关系证明了它是有益的，最终甚至是愉快的。尽管在宴会上他们可能不会把你当作平等的人，但在战场上他们也不是你的对手。通过辛勤的工作和一贯的忠诚赢得他们的信任，%companyname%终于被认为是%noblehouse%可信赖的盟友。\n\n这种地位的好处之一是你的士兵被允许浏览贵族们的军械库。一些激进的与贵族意见相左者可能会因你们与贵族结盟、在盾牌上整上他们的旗帜而称你们为贵族的走狗，但从不当着你的面。";
		this.m.SuccessButtonText = "Excellent.";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 30)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local hasFriend = false;
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse)
			{
				if (f.getPlayerRelation() >= 90.000000)
				{
					return;
				}
				else if (f.getPlayerRelation() >= 60.000000)
				{
					hasFriend = true;
				}
			}
		}

		if (!hasFriend)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() >= 90.000000)
			{
				return true;
			}
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() >= 90.000000)
			{
				_vars.push([
					"noblehouse",
					f.getName()
				]);
				break;
			}
		}
	}

	function onReward()
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);
		local banner = 1;

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() >= 90.000000)
			{
				banner = f.getBanner();
				break;
			}
		}

		local item;
		local stash = this.World.Assets.getStash();
		item = this.new("scripts/items/helmets/faction_helm");
		item.setVariant(banner);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/armor/special/heraldic_armor");
		item.setFaction(banner);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/shields/faction_heater_shield");
		item.setFaction(banner);
		item.setVariant(2);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/shields/faction_heater_shield");
		item.setFaction(banner);
		item.setVariant(2);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/shields/faction_kite_shield");
		item.setFaction(banner);
		item.setVariant(2);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/shields/faction_kite_shield");
		item.setFaction(banner);
		item.setVariant(2);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
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
