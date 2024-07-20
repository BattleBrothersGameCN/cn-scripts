this.hammer_mastery_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.hammer_mastery";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "战团面对重甲对手缺乏准备。我们要训练两\n名战锤专家，让骑士也逃不出我们的手掌心。";
		this.m.UIText = "拥有掌握锤精通特技的队员";
		this.m.TooltipText = "拥有2名掌握锤精通特技的队员。";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]啪－啪－啪，%hammerbrother%正拿一棵松树练习着他的击打技术。人们聚了过来，想要看看他有多大本事。%SPEECH_ON%看那锤头！别说是打穿头盔，我都能看到头盖骨里的脑花了！%SPEECH_OFF%他又挥了一下，树干从中间裂开，上半部分直接朝营地倒了过去。%nothammerbrother%赶紧从座位上爬了起来，把汤洒了一身，差点就被压扁了。 %SPEECH_ON%我原以为这世上没什么新鲜的东西，但我从来没有用倒下的树杀过人！%SPEECH_OFF%%hammerbrother%笑着喊道。可以预见的是，下次遇到重甲的敌人时，你会很好过。";
		this.m.SuccessButtonText = "盔甲，什么盔甲？";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(2, this.getBrosWithMastery()) + "/2)";
	}

	function getBrosWithMastery()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local count = 0;

		foreach( bro in brothers )
		{
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInHammers)
			{
				count = ++count;
			}
		}

		return count;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 30)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local count = this.getBrosWithMastery();

		if (count >= 2)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local count = this.getBrosWithMastery();

		if (count >= 2)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local not_candidates = [];

		if (brothers.len() > 2)
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
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInHammers)
			{
				candidates.push(bro);
			}
			else
			{
				not_candidates.push(bro);
			}
		}

		if (not_candidates.len() == 0)
		{
			this.candiates = not_candidates;
		}

		_vars.push([
			"hammerbrother",
			candidates[this.Math.rand(0, candidates.len() - 1)].getName()
		]);
		_vars.push([
			"nothammerbrother",
			not_candidates[this.Math.rand(0, not_candidates.len() - 1)].getName()
		]);
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});
