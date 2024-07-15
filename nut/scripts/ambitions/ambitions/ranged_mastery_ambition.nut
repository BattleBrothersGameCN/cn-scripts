this.ranged_mastery_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.ranged_mastery";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "战团缺乏老练射手，限制了咱们的战术选择。\n我们得训练三名弓弩大师，从远处给予致命威胁！";
		this.m.UIText = "有1人点出弓精通或弩精通特技";
		this.m.TooltipText = "有3人点出弓精通或弩精通特技。";
		this.m.SuccessText = "[img]gfx/ui/events/event_10.png[/img]一有机会，你就会让你的人射上几箭。每个人都要参与，哪怕是那些笨手笨脚，穿着盔甲都能睡着的家伙也不例外。什么东西都能当成标靶来用：一段小树的树干，一头赶早吃草的母鹿，或是一个逃命的地精侦察兵。%SPEECH_ON%没错，我们就是全世界干草捆的公敌！%SPEECH_OFF%%randombrother%说道，他说的是你们常用练习目标中的一种。他忽然闪了下头，原来是战友的箭从他头边上呼啸而过，他继而骂骂咧咧起来。\n\n经过大量练习，箭支的落点离靶心越来越近。战团里有了训练有素的弓箭手，前排也能松一口气，至少能活得久一点。";
		this.m.SuccessButtonText = "这对我们很有帮助。";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(3, this.getBrosWithMastery()) + "/3)";
	}

	function getBrosWithMastery()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local count = 0;

		foreach( bro in brothers )
		{
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInBows)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInCrossbows)
			{
				count = ++count;
			}
		}

		return count;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 25)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local count = this.getBrosWithMastery();

		if (count >= 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local count = this.getBrosWithMastery();

		if (count >= 3)
		{
			return true;
		}

		return false;
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
