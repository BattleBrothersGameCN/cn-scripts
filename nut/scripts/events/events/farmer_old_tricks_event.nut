this.farmer_old_tricks_event <- this.inherit("scripts/events/event", {
	m = {
		Farmer = null
	},
	function create()
	{
		this.m.ID = "event.farmer_old_tricks";
		this.m.Title = "露营时……";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]你发现%farmhand%坐在战团的货车旁。他用牙间嚼着一些稻草，来回磨蹭，然后吐出碎屑。你问他在想什么，雇农耸了耸肩。%SPEECH_ON%父亲告诉过我关于打捆干草的事。他有一套在抓草和放草时转动手腕的方法。可我总是做不好第二步。%SPEECH_OFF%雇农拿出稻草，轻轻一弹。你问道。%SPEECH_ON%但第一步你能做好吧？就是刺中干草然后猛拉的那个动作？%SPEECH_OFF%他点点头。你告诉他，只要用那个技巧的第一步就够把敌人开膛破肚的了。他恍然大悟。%SPEECH_ON%对啊...太对了！我之前为啥没想到呢？您真是天才，先生！下次出手我试试看！就像打捆干草一样！%SPEECH_OFF%当然，尖叫声和流血会多很多了。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "只是不要尝试把它们丢到你的肩膀上。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Farmer.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				_event.m.Farmer.getBaseProperties().MeleeSkill += meleeSkill;
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Farmer.getName() + " 获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] 近战技能"
				});
				_event.m.Farmer.improveMood(1.0, "意识到他有一些战斗知识");

				if (_event.m.Farmer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Farmer.getMoodState()],
						text = _event.m.Farmer.getName() + this.Const.MoodStateEvent[_event.m.Farmer.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 2 && bro.getBackground().getID() == "background.farmhand")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Farmer = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"farmhand",
			this.m.Farmer.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Farmer = null;
	}

});
