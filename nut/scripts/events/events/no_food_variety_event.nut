this.no_food_variety_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.no_food_variety";
		this.m.Title = "露营时……";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_52.png[/img]{你发现雇佣兵簇拥在营火旁边，只是他们没有把能够被称作食物的东西放在火上。一人将他那碗汤倒了过来。那汤就像污泥一样粘在碗上，没有流出去的迹象，说老实话，这实在是太恶心了。%randombrother%看着你。%SPEECH_ON%先生，拜托了，让我们吃点肉吧！或者任何别的比这种狗屎强的东西！%SPEECH_OFF%有点变化也无妨，你同意。 | %randombrother%来到你身边，把勺子摔在你的桌子上。勺子上有东西，但你不确定那是什么。那佣兵靠在椅背上，双手插在腰间，胸膛随着呼吸而起伏。然后他叹了口气，因为他知道不能在你面前表现得如此无礼。但他确实为自己做了解释。%SPEECH_ON%先生，伙计们在抱怨食物。我想如果我们能在下一个城镇买些肉和其他货物，对战团的士气会很有帮助。当然，这只是一个建议。%SPEECH_OFF%他很快走开了。你拿起勺子，仔细琢磨勺子里的东西是什么。那……那不会是他们在外面吃的东西吧？也许换个口味也无妨…… | %randombrother%手里拿着碗走来。他把碗向前倾斜，露出碗里的东西，它们是无色的，慢慢地沿着碗的边缘滑落。这个佣兵摇了摇头。%SPEECH_ON%先生，弟兄们今晚都不高兴，我也不高兴，因为我们一直在吃的这东西。一个人不可能忍受得了长时间吃同样的东西，特别是在他知道他可以担负起更好的东西的时候。这只是一个建议，先生，既是我的也是其他人的，也许我们应该增加自己的粮食储备，这样就不会每顿饭都……嗯，这样。%SPEECH_OFF%他放下碗走开了。 | 你的几个佣兵围着营火抱怨着。你待在能听到话的位置，仔细听他们可能会说的一些不会当面跟你说的话。值得庆幸的是，这不是一场正在进行的叛乱，而是一系列对食物的批评。战团食品库存的品种实在是太少了。他们早已厌倦了一遍又一遍地吃同样的东西。也许这可以在%companyname%下一个拜访的城镇中得到补救？}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "好吧，他们不会吃上蛋糕",
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
					if (bro.getBackground().isLowborn() || bro.getSkills().hasSkill("trait.spartan"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.gluttonous"))
					{
						bro.worsenMood(1.0, "几天来除了谷粉别的什么也没吃上");
					}
					else
					{
						bro.worsenMood(0.5, "几天来除了谷粉别的什么也没吃上");
					}

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
		if (this.World.getTime().Days < 5)
		{
			return;
		}

		if (this.World.State.getEscortedEntity() != null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local hasBros = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().isLowborn() || bro.getSkills().hasSkill("trait.spartan"))
			{
				continue;
			}

			hasBros = true;
			break;
		}

		if (!hasBros)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local hasOtherFood = false;

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (item.getID() != "supplies.ground_grains")
				{
					hasOtherFood = true;
					break;
				}
			}
		}

		if (hasOtherFood)
		{
			return;
		}

		this.m.Score = 10;
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
