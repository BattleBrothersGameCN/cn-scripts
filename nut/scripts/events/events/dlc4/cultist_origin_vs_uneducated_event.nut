this.cultist_origin_vs_uneducated_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Uneducated = null
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_vs_uneducated";
		this.m.Title = "露营时……";
		this.m.Cooldown = 13.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]有几个兄弟来找你，看上去很着急。他们说%cultist%和%uneducated%坐在一起已经几个小时了。当你问他们担心什么时，他们提醒你那个邪教徒额头有伤疤，还会说些令人难以置信的怪事。是的。这些都是达库尔的要求，一个某人奉献的范例。你不明白这有什么不对。\n\n你去见那两人。%uneducated%抬头看着你，微笑着，说这个邪教徒有很多东西要教他。也许他确实有，但你知道并不是所有人都需要感受到达库尔的存在，如果强迫其降临到世界上，那将是对达库尔目的的误解。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "向他展示黑暗吧。",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "达库尔并不想要他。",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Uneducated.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]你点头，转身走开了。第二天早上，%uneducated%的额头上多了个新伤口，那是皈依达库尔所需付出的代价和奉献的鲜血。你问他感觉如何，他只说了几句话。%SPEECH_ON%达库尔即将降临。%SPEECH_OFF%摇着头，你纠正他。%SPEECH_ON%达库尔不是要降临。达库尔在*等待*我们所有人。%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "达库尔在等待。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Uneducated.getImagePath());
				local background = this.new("scripts/skills/backgrounds/converted_cultist_background");
				_event.m.Uneducated.getSkills().removeByID(_event.m.Uneducated.getBackground().getID());
				_event.m.Uneducated.getSkills().add(background);
				background.buildDescription();
				background.onSetAppearance();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Uneducated.getName() + "已经转化为了邪教徒"
					}
				];
				_event.m.Cultist.getBaseProperties().Bravery += 2;
				_event.m.Cultist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Cultist.getName() + " 获得 [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] 决心"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]你把这两人分开，叫%uneducated%去清点一些存货。当他离开时，%cultist%对你露出了冷笑。%SPEECH_ON%达库尔在等待。你在梦中看到他。你在夜晚看到他。他的黑暗即将降临。没有永远燃烧的火光。%SPEECH_OFF%那人停下来，凝视着你的灵魂。而你则从非身体的某个地方凝视回去。你只能看到你周围无尽的黑暗和一个通过%cultist%那里能看到的光点。慢慢地，你飘回到光亮处，发现自己正眨着眼睛盯着那个人。他鞠了一躬。%SPEECH_ON%致歉，队长，我不知道达库尔还有这样的计划。%SPEECH_OFF%他又眨了眨眼睛，你只能点头。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "达库尔等待着我们所有人。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Uneducated.getImagePath());
				_event.m.Cultist.worsenMood(1.0, "被剥夺了转化他人为邪教徒的机会，本将转化" + _event.m.Uneducated.getName());

				if (_event.m.Cultist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local cultist_candidates = [];
		local uneducated_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().get("IsSpecial") || bro.getFlags().get("IsPlayerCharacter") || bro.getBackground().getID() == "background.slave")
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				cultist_candidates.push(bro);
			}
			else if (bro.getBackground().isLowborn() && !bro.getSkills().hasSkill("trait.bright") || !bro.getBackground().isNoble() && bro.getSkills().hasSkill("trait.dumb") || bro.getSkills().hasSkill("injury.brain_damage"))
			{
				uneducated_candidates.push(bro);
			}
		}

		if (cultist_candidates.len() == 0 || uneducated_candidates.len() == 0)
		{
			return;
		}

		this.m.Cultist = cultist_candidates[this.Math.rand(0, cultist_candidates.len() - 1)];
		this.m.Uneducated = uneducated_candidates[this.Math.rand(0, uneducated_candidates.len() - 1)];
		this.m.Score = cultist_candidates.len() * 9;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist.getName()
		]);
		_vars.push([
			"uneducated",
			this.m.Uneducated.getName()
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.Uneducated = null;
	}

});
