this.defeat_goblin_location_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		Defeated = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_goblin_location";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "只有最勇敢的人才敢对抗大规模的地精。 \n我们要把他们的一些臭气熏天的营地夷为平地，让消息传出去！";
		this.m.RewardTooltip = "你将获得一件独特的配饰，使佩戴者免疫定身。";
		this.m.UIText = "摧毁地精营地";
		this.m.TooltipText = "摧毁四个地精营地来证明战团的实力，无论是作为合同的一部分，还是通过自己发现。 你还需要在仓库中留出足够的空间来存放一个新物品。";
		this.m.SuccessText = "[img]gfx/ui/events/event_83.png[/img]你的人零零散散地分布在战场上，一场恶战之后，人们气踹嘘嘘。你打扫战场的时候，%randombrother%和%randombrother2%也正在地面上搜寻贵重物品。%SPEECH_ON%我们前进，他们就后退。我们后退，他们就骚扰我们。用弓箭齐射，他们就躲藏起来。架起盾墙，它们就用浸毒的刀锋刺穿。发起冲锋，他们就四散开来。他们朝你扔的那些该死东西肯定会出现在我今晚的梦里。%SPEECH_OFF%%randombrother2%用他的武器戳穿一个死去的地精，确信他已经死了，跪下来仔细查看他的东西。%SPEECH_ON%但是战斗越激烈，胜利就更让人舒坦。%SPEECH_OFF%他站起来，撞上了%randombrother%的目光。%SPEECH_ON%战斗越激烈，我感觉越带劲。尽管来吧。%SPEECH_OFF%他们逐渐和其他人会合，在这里或那里驻足，寻找能在战团的下一站卖上一两个克朗的物件。";
		this.m.SuccessButtonText = "胜利！";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.Defeated + "/4)";
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.FactionManager.getFaction(_location.getFaction()).getType() == this.Const.FactionType.Goblins)
		{
			++this.m.Defeated;
			this.World.Ambitions.updateUI();
		}
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 20)
		{
			return;
		}

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
		_vars.push([
			"recently_destroyed",
			this.World.Statistics.getFlags().get("LastLocationDestroyedName")
		]);
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		item = this.new("scripts/items/accessory/goblin_trophy_item");
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
	}

	function onClear()
	{
		this.m.Defeated = 0;
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
