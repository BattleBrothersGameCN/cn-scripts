this.anatomist_reflects_on_webknechts_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		OtherBro = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_reflects_on_webknechts";
		this.m.Title = "露营时……";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{%anatomist%正平伸着手臂，观察一只长腿蜘蛛在他皮肤上爬行。当这小生物爬到手臂尽头时，解剖学家便转动手腕引导它另寻去路。如此反复数次后，他终于将手指垂向地面让蜘蛛彻底离开——或许这小东西始终没意识到自己刚才在活物身上爬行。解剖学家在笔记上记下数页。%SPEECH_ON%之前我看见一只蜘蛛跳了二十个身长那么远，直接把苍蝇给逮住了。而刚才放走的这家伙，要是发现猎物跑起来比猎狗还快。看来旧神还是可怜咱们，流氓，至少这两种本事没让那些蛛魔给沾上。%SPEECH_OFF%你表示虽然被扑倒撕扯很可怕，但被裹成茧慢慢吸干显然更糟。解剖学家竖起食指。%SPEECH_ON%这是常见的误区，流氓。蛛魔其实更喜欢等你死透了再开饭。它们的毒液专门对付肚子，把里面器官都化成汤水——所以它们才把猎物倒挂着，让毒液能把五脏六腑都泡透，把你变成个人肉汤包。最后进食阶段不过是喝汤罢了。唯一不吃的情况是他们要在你的身体里产卵，毕竟小蜘蛛破壳时总得有点存粮。%SPEECH_OFF%这听起来仍然比被狩猎蜘蛛捅死可怕千万倍，你后悔开启这个话题便不再多言。不幸的是，%otherbro%就在近旁听得一清二楚......}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "别再散布恐慌了，见鬼。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.OtherBro.getImagePath());
				local trait = this.new("scripts/skills/traits/fear_beasts_trait");
				_event.m.OtherBro.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.OtherBro.getName() + "现在害怕野兽"
				});
				_event.m.OtherBro.worsenMood(1.0, "害怕蜘蛛");

				if (_event.m.OtherBro.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.OtherBro.getMoodState()],
						text = _event.m.OtherBro.getName() + this.Const.MoodStateEvent[_event.m.OtherBro.getMoodState()]
					});
				}

				_event.m.Anatomist.improveMood(1.0, "迷恋蜘蛛");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.beast_slayer" && bro.getBackground().getID() != "background.wildman" && !bro.getSkills().hasSkill("trait.brave") && !bro.getSkills().hasSkill("trait.fearless") && !bro.getSkills().hasSkill("trait.fear_beasts") && !bro.getSkills().hasSkill("trait.hate_beasts"))
			{
				other_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0 || other_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.OtherBro = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = 2 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"otherbro",
			this.m.OtherBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.OtherBro = null;
	}

});
