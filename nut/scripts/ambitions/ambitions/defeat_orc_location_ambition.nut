this.defeat_orc_location_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		Defeated = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_orc_location";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "在战斗中击败兽人，烧毁它们的营地\n能让人们认识到战团的能力。就这么干吧。";
		this.m.RewardTooltip = "你将获得一件独特配饰，它能使佩戴者免疫昏迷。";
		this.m.UIText = "摧毁兽人营地";
		this.m.TooltipText = "摧毁四个兽人营地来证明战团的实力，通过合同或自己寻找均可。你还需要在仓库中留出存放一件新物品的空间。";
		this.m.SuccessText = "[img]gfx/ui/events/event_81.png[/img]%recently_destroyed%仍在你身后阴烧，一群人从他们藏身的灌木丛附近钻了出来，他们刚刚从远处观看了战斗。一个老妇人走上前来。%SPEECH_ON%那些绿皮肤的恶魔把我们从%nearesttown%郊外的农场赶出来，但多亏了你们这些壮实的小伙子，我们能再次繁荣起来。这是给你们的。%SPEECH_OFF%她递过来一袋苹果。虽然这算不上什么奖励，但随着兽人毁灭的消息传开，这种情绪会一次又一次地重复。%highestexperience_brother%吠笑着咬着其中一个多汁的苹果%SPEECH_ON%兽人这种东西，大的太慢了，小的太笨了。谋略每次都能战胜暴力。那些大个的绿皮畜生利用恐惧来行事。只要有勇气，他们就能像其他人一样被打败！%SPEECH_OFF%农民们对%highestexperience_brother%的演讲、技巧和力量大为赞叹，拍着他的后背，一时间鼓掌声称赞声不绝于耳。虽然这些话都是真话，但并不适用于这些观众。你把手放在%highestexperience_brother%的肩膀上，好像在说要低调一些，以免农民下次看到绿皮时逞英雄。";
		this.m.SuccessButtonText = "让所有人都知道，是%companyname%取得了胜利！";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.Defeated + "/4)";
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.FactionManager.getFaction(_location.getFaction()).getType() == this.Const.FactionType.Orcs)
		{
			++this.m.Defeated;
			this.World.Ambitions.updateUI();
		}
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 25)
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
		item = this.new("scripts/items/accessory/orc_trophy_item");
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
