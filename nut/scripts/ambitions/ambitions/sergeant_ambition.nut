this.sergeant_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.sergeant";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们作战情况不错，但还需要更好的组织来应对恶劣情况。\n我得命名一位军士在战场上集结你们。";
		this.m.RewardTooltip = "你将获得一个独特配饰，它能给佩戴者额外的决心。";
		this.m.UIText = "有一人点出“集结部队”特技";
		this.m.TooltipText = "至少一人点出“集结部队”特技。 你还需要在仓库中留出足够的空间来存放一个新物品。";
		this.m.SuccessText = "[img]gfx/ui/events/event_64.png[/img]你起初对于让%sergeantbrother%担任这个重要任务有些犹豫，因为他和其他人一样沉迷于饮酒作乐。但是%sergeantbrother%对于他的职责表现出了可嘉的热情，也可能是过于热情了。\n\n拂晓时分是滋生懦弱和动摇的温床，%sergeantbrother%要求每个人都早早起来。完成切磋对练和装备检查还远远不够，他还对拆装营帐，队形训练，包夹操典，负重强行军制定了严格的规范，为胆敢掉队的人制定了详尽的惩罚制度。\n\n当%sergeantbrother%不在附近时，他的名字会被诸如“痛苦至极”，“冷酷无情”，“铁石心肠”，“毫不怜悯”等十几个诨号代替，嗡嗡响个不停。他睡觉的时候除外，大伙都知道%sergeantbrotherfull%从不真的睡觉。";
		this.m.SuccessButtonText = "这对今后的日子大有好处。";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		this.m.Score = 3 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return false;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("perk.rally_the_troops"))
			{
				return true;
			}
		}

		return false;
	}

	function onReward()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local highestBravery = 0;
		local bestSergeant;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("perk.rally_the_troops"))
			{
				if (bro.getCurrentProperties().getBravery() > highestBravery)
				{
					bestSergeant = bro;
					highestBravery = bro.getCurrentProperties().getBravery();
				}
			}
		}

		if (bestSergeant != null && bestSergeant.getTitle() == "")
		{
			bestSergeant.setTitle("军士(the Sergeant)");
			this.m.SuccessList.push({
				id = 90,
				icon = "ui/icons/special.png",
				text = bestSergeant.getNameOnly() + " 现在被称为 " + bestSergeant.getName()
			});
		}

		local item = this.new("scripts/items/accessory/sergeant_badge_item");
		this.World.Assets.getStash().add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local highestBravery = 0;
		local bestSergeant;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("perk.rally_the_troops") && bro.getCurrentProperties().getBravery() > highestBravery)
			{
				bestSergeant = bro;
				highestBravery = bro.getCurrentProperties().getBravery();
			}
		}

		_vars.push([
			"sergeantbrother",
			bestSergeant.getNameOnly()
		]);
		_vars.push([
			"sergeantbrotherfull",
			bestSergeant.getName()
		]);
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
