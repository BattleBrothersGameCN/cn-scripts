this.aging_swordmaster_preview_event <- this.inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.aging_swordmaster_preview";
		this.m.Title = "在途中……";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]你看到%swordmaster%坐在树桩上，眺望着远处。%SPEECH_ON%知道吗，我这种在杀人行当里混了大半辈子的老家伙，总算想明白了一些事。现在我是比以前聪明多了，懂得多了，多到终于知道自己有多少不懂的东西。回头想想，年轻时真是个蠢货。然后我就琢磨，那些死在我手里的人呢？他们年纪轻轻、正憋着劲要大干一场的时候，就被我断了命。%SPEECH_OFF%你坐下来耸耸肩，他继续说道。%SPEECH_ON%现在我算明白了，我杀的不只是人，是把人家活成老狐狸的机会都掐断了。多少老家伙被我送走，带着他们肚子里的学问和见识。我毁了多少个世界啊——那些家伙要是活着，能继续活下去，说不定能做成连他们自己都没想到的大事。要是当年第一个跟我动手的人把我宰了，他能救下多少条命？留下多少智慧？抱歉，我不该在这儿絮絮叨叨的。%SPEECH_OFF%他站起来拍拍发抖的腿。你抓住他胳膊。%SPEECH_ON%那你有没有想过，说不定你也救了几个世界？那些死在你手里的人，要是活下来可能变成祸害呢？%SPEECH_OFF%他笑了笑，但你知道他早想过这问题，只是不想拿答案来烦你。他点点头就走了，去找其他弟兄了。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "希望他能振作起来。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				_event.m.Swordmaster.worsenMood(1.0, "意识到他老了");

				if (_event.m.Swordmaster.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Swordmaster.getMoodState()],
						text = _event.m.Swordmaster.getName() + this.Const.MoodStateEvent[_event.m.Swordmaster.getMoodState()]
					});
				}

				_event.m.Swordmaster.getFlags().add("aging_preview");
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.swordmaster" && !bro.getFlags().has("aging_preview") && !bro.getSkills().hasSkill("trait.old") && !bro.getFlags().has("IsRejuvinated"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Swordmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = this.m.Swordmaster.getLevel();
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"swordmaster",
			this.m.Swordmaster.getName()
		]);
	}

	function onClear()
	{
		this.m.Swordmaster = null;
	}

});
