this.aging_swordmaster_paycut_event <- this.inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.aging_swordmaster_paycut";
		this.m.Title = "露营时……";
		this.m.Cooldown = 100.000000 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]%swordmaster%进入你的帐篷。你挥手让他坐到对面的椅子上。他坐得慢而无力，你担心他站起来要花上两倍的时间。他合起双手，胳膊肘撑在桌子上，嘴里嘟囔着挪动身子，什么都不做就让他很不舒服。他的嘴唇是干的，他的脸皮是皱的。他的头上长满斑痕，连鼻子和耳朵周边的毛发都变得灰白。\n\n不管多忙，你都不会怠慢%swordmaster%，你问他有什么事。%SPEECH_ON%从佣兵嘴里说出这话可能很奇怪，但我一定要说，这样我才能睡得安心。我就直说了：我已经不是你很久以前雇用的那个人了。你知道，我知道，有些队员也知道，但他们都是好人，很尊重我。%SPEECH_OFF%你同意，但没有点头。相反，你应该问这人他到底想说什么。%SPEECH_ON%我希望降低我的工资。不要拒绝，你没必要骗我。我要打个对折。钱从来都不是问题。这些克朗可以用来武装这些人，给他们更好的报酬。谁都知道，年轻人总是要多用上一两个克朗。%SPEECH_OFF%你还没来得及说一个字，那人就以惊人的速度跳了起来。他点了点头，调皮地笑了笑，走出帐篷，大声嚷嚷起来%SPEECH_ON%我同意你的决定，好心的长官。我应该减薪！%SPEECH_OFF%又马上走了进来。你哈哈大笑。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "他是个值得尊敬的人，一如既往。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				_event.m.Swordmaster.getBaseProperties().DailyWage -= _event.m.Swordmaster.getDailyCost() / 2;
				_event.m.Swordmaster.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Swordmaster.getName() + "的日薪现在为" + _event.m.Swordmaster.getDailyCost() + "克朗"
				});
				_event.m.Swordmaster.getFlags().add("aging_paycut");
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.swordmaster" && !bro.getFlags().has("aging_paycut") && !bro.getSkills().hasSkill("trait.old"))
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
