this.defeat_undead_location_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		Defeated = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_undead_location";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "行尸对人们来说是一种可怕的诅咒。\n让我们把他们的一些巢穴烧成灰烬，赢得所有厚道人的尊重！";
		this.m.RewardTooltip = "你将获得一件特殊的配饰，它能使佩戴者在抵御恐惧和精神控制效果时的决心翻倍。";
		this.m.UIText = "摧毁亡灵营地";
		this.m.TooltipText = "摧毁四个亡灵营地来证明战团的实力，通过合同或自己寻找均可。你还需要在仓库中留出存放一件新物品的空间。";
		this.m.SuccessText = "[img]gfx/ui/events/event_46.png[/img]得益于%companyname%，%recently_destroyed%的蹒跚怪物永远不会再威胁无辜的人。但兄弟们需要数天的时间、大量的酒来摆脱所面临的恐怖。%SPEECH_ON%光天化日之下，如此亵渎的东西怎么会敢于现身？%SPEECH_OFF%%randombrother%问道，温和地凝视着远方。%SPEECH_ON%它直接倒塌成一堆腐烂的骨头和灰尘。这些东西能维持形状，肯定是受到了诅咒。%SPEECH_OFF%%fearful_brother%甚至产生了更深邃的恐惧。%SPEECH_ON%我在%randomtown%的时候听说过，任何一个被这些东西杀死的好人都注定要自己从坟墓里复活，永远不能坐在众神面前。%SPEECH_OFF%部分人大声反对这一点，不是因为他们更懂，而是因为他们不希望这是真的。在有人开始讲鬼故事之前，你下令把火堆生起来。这些人今晚可能难以入睡，但随着黎明的到来，士气会再次高涨。";
		this.m.SuccessButtonText = "尽管如此，但我们又胜利了！";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.Defeated + "/4)";
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.FactionManager.getFaction(_location.getFaction()).getType() == this.Const.FactionType.Undead || this.World.FactionManager.getFaction(_location.getFaction()).getType() == this.Const.FactionType.Zombies)
		{
			++this.m.Defeated;
			this.World.Ambitions.updateUI();
		}
	}

	function onUpdateScore()
	{
		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 2 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return false;
		}

		if (this.m.Defeated >= 4)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local fearful = [];
		local lowborn = [];

		if (brothers.len() > 1)
		{
			for( local i = 0; i < brothers.len(); i = ++i )
			{
				if (brothers[i].getSkills().hasSkill("trait.player"))
				{
					brothers.remove(i);
					break;
				}
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.superstitious"))
			{
				fearful.push(bro);
			}
			else if (bro.getBackground().isLowborn())
			{
				lowborn.push(bro);
			}
		}

		local fear;

		if (fearful.len() != 0)
		{
			fear = fearful[this.Math.rand(0, fearful.len() - 1)];
		}
		else if (lowborn.len() != 0)
		{
			fear = lowborn[this.Math.rand(0, lowborn.len() - 1)];
		}
		else
		{
			fear = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		_vars.push([
			"fearful_brother",
			fear.getName()
		]);
		_vars.push([
			"recently_destroyed",
			this.World.Statistics.getFlags().get("LastLocationDestroyedName")
		]);
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		item = this.new("scripts/items/accessory/undead_trophy_item");
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
		_out.writeU8(this.m.Defeated);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.Defeated = _in.readU8();
	}

});
