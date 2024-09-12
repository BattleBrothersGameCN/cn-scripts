this.cripple_vs_injury_event <- this.inherit("scripts/events/event", {
	m = {
		Cripple = null,
		Injured = null
	},
	function create()
	{
		this.m.ID = "event.cripple_vs_injury";
		this.m.Title = "露营时……";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]最近的战斗在%injured%身上留下了可怕的永久创伤。当他闷闷不乐地坐在营火旁时，%cripple%坐到了他的身旁。%SPEECH_ON%原来你在这儿坐着，为一些无关紧要的事情烦恼。看着我。看我就行了！看看我的处境！我失去了很多无法挽回的东西，但你看我深陷其中了吗？不。我挺过去了。我加入了%companyname%。正因如此，这儿的这些伤，就算是过去了。至于……%SPEECH_OFF%瘸子轻轻敲着他的头。%SPEECH_ON%这儿，这儿的一切都可以重来。这才是决定了你的想法的地方，没错，不幸的事确实发生了，但我还是个男子汉，我还活在这个世界上。如果这个世界想要置我于死地，它就必须一点一点的带走我，直到我消失到最后一丁点为止，我都绝对不会放弃！%SPEECH_OFF%%injured%点了点头，似乎他的心情好了很多。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "很好地鼓舞了那个人。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cripple.getImagePath());
				this.Characters.push(_event.m.Injured.getImagePath());
				_event.m.Injured.improveMood(1.0, "精神振奋，来自 " + _event.m.Cripple.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Injured.getMoodState()],
					text = _event.m.Injured.getName() + this.Const.MoodStateEvent[_event.m.Injured.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local cripple_candidates = [];
		local injured_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cripple")
			{
				cripple_candidates.push(bro);
			}
			else if (bro.getSkills().hasSkillOfType(this.Const.SkillType.PermanentInjury))
			{
				foreach( n in bro.getMoodChanges() )
				{
					if (n.Text == "Suffered a permanent injury")
					{
						injured_candidates.push(bro);
						break;
					}
				}
			}
		}

		if (cripple_candidates.len() == 0 || injured_candidates.len() == 0)
		{
			return;
		}

		this.m.Cripple = cripple_candidates[this.Math.rand(0, cripple_candidates.len() - 1)];
		this.m.Injured = injured_candidates[this.Math.rand(0, injured_candidates.len() - 1)];
		this.m.Score = (cripple_candidates.len() + injured_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cripple",
			this.m.Cripple.getNameOnly()
		]);
		_vars.push([
			"injured",
			this.m.Injured.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Cripple = null;
		this.m.Injured = null;
	}

});
