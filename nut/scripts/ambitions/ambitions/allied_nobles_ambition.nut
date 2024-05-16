this.allied_nobles_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.allied_nobles";
		this.m.Duration = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们应赢得一个贵族家族的信任，成为他们的盟友。\n他们自然会与好朋友分享他们殷实的军械库里的宝贝。";
		this.m.RewardTooltip = "你将被授予结盟的贵族家族独有的装备";
		this.m.UIText = "与一个贵族家族达成“盟友”关系";
		this.m.TooltipText = "通过履行派系成员的合同，将与任一贵族家族的关系提升至“盟友”。半途而废或背叛他们会降低你们的关系。";
		this.m.SuccessText = "[img]gfx/ui/events/event_78.png[/img]你早就听说过，贵族是一群难以相处、反复无常的家伙，实际打过交道以后也确实如此，但终究和%noblehouse%的关系有利可图，甚至令人愉快。在宴会上，他们不会和你平起平坐，但在战场上，他们也休想比得过你。通过辛勤的工作和一贯的忠诚，%companyname%终于被%noblehouse%看作值得信赖的盟友。\n\n这种地位的好处之一是你的士兵获得了浏览贵族们的军械库的许可。一些与贵族意见相左者的激进分子可能会因你们与贵族结盟、在盾牌上整上他们的旗帜而称你们为贵族的走狗，好在没人会当面这么做。";
		this.m.SuccessButtonText = "好极了。";
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
				if (f.getPlayerRelation() >= 90.0)
				{
					return;
				}
				else if (f.getPlayerRelation() >= 60.0)
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

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() >= 90.0)
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

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() >= 90.0)
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

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() >= 90.0)
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
