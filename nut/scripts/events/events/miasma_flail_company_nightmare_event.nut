this.miasma_flail_company_nightmare_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.miasma_flail_company_nightmare";
		this.m.Title = "在途中……";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{你梦到了你的母亲。你有好一阵子没见过她了，甚至都觉得自己快要忘了这张脸，你的大部分记忆都已经被世界磨灭了。她和你印象中的一样慈爱，她把你搂到怀里，轻声细语间，手指穿过你的头发。片刻之后，她把乳房伸到了你跟前。你回过神来，有些迟疑，抬起头，大先知正对你疯笑着。%SPEECH_ON%无巢之母，我早告诉过你了，佣兵！万物的哺育者……%SPEECH_OFF%一头血肉傀儡卷起肩膀上的附肢，用它那黏糊糊触手把你捆绑在半空。%SPEECH_ON%在我的怀抱里见着这个世界本源的力量吧，佣兵！我会好好把你养育成那个你该成为的人的。%SPEECH_OFF%在一声惊叫中，你从睡梦里挣脱出来，滚下了小床，狠狠摔在地上，大口大口喘着气，反复抽打自己的脸，确保自己不再陷回到梦里去。战团里的其他人也都狼狈不堪，所有佣兵都经历了同样的噩梦。你瞥了一眼战团的东西，只见大先知的链枷漫射出淡绿色的光，那光芒慢慢褪去，若隐若现的笑声随之传出……}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "妈了个巴子。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.worsenMood(0.75, "做了个跟大先知有关的噩梦");

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local haveFlail = false;

		foreach( bro in brothers )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && item.getID() == "weapon.miasma_flail")
			{
				haveFlail = true;
			}
		}

		if (!haveFlail)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && item.getID() == "weapon.miasma_flail")
				{
					haveFlail = true;
					break;
				}
			}
		}

		if (!haveFlail)
		{
			return;
		}

		this.m.Score = 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});
