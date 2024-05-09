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
			Text = "[img]gfx/ui/events/event_17.png[/img]你看到%swordmaster%坐在树桩上，眺望着远处的土地。%SPEECH_ON%你知道吗，作为一个长年刀口舔血的老头，我明白了一些事情。这些日子我聪明多了。知道的太多太多，以至于知道自己不知道什么。回首过去，我年轻时候真是个蠢蛋。我又想，我杀了那么多人，在他们正要开始自己美好青春的时候结束了他们的生命。%SPEECH_OFF%你坐下来耸耸肩，他继续说道。%SPEECH_ON%我意识到，我杀死了智慧。我让这个世界上少了很多老人，他们的知识和学问也随之消散。我毁了很多人的世界。那些他们活着的世界里，不知他们会有怎样的壮举。如果第一个和我战斗的人杀了我，他能拯救多少生命？又能拯救多少智慧？抱歉，我不是故意唠叨的。%SPEECH_OFF%他站了起来，拍了拍打颤的腿。你扶住了他的胳膊。%SPEECH_ON%你有没有想过，你也可能拯救了世界，那些人会活成可怕的怪物？%SPEECH_OFF%他笑了笑，看来他那么想过了，只是不想再啰嗦回答。他只是点了点头，去和其余人会合。",
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
