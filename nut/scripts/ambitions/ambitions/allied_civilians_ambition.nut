this.allied_civilians_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.allied_civilians";
		this.m.Duration = 21.000000 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们需要盟友。与其中一个城镇建立友谊和信任的纽带\n将使战团获得更好的价格，更多的志愿者和更稳定的工作。";
		this.m.UIText = "与一个平民派系达到“友好”关系";
		this.m.RewardTooltip = "有良好的关系会使你得到更好的价格和更多可雇佣的人。";
		this.m.TooltipText = "通过履行与世界上一个村庄或城镇的平民派系的合同，将其关系提升到“友好”级别。违反合同或背叛他们会降低你们的关系。增加与城邦的关系比增加与小村庄的关系需要更长的时间。贵族家族不算平民派系。";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]在决定%friendlytown%是一个值得投入努力的好地方后，你决定对其提供战团的保护，接受适合你才能的工作。你在与当地人交易时表现得像个绅士，并鼓励兄弟们在定居点里注意自己的行为举止。一开始当然有些人会有埋怨。%brawler%对放弃与农民干架感到非常失望，尤其是在%companyname%在%friendlytown%待了那么长时间后。\n\n但你让兄弟们相信在他们的工作中拥有一个友好的行动基地是非常重要的，因为这意味着在市场上得到更好的价格，更多的人愿意加入你的杂乱战团。而且不用一直躲避民兵也不那么累了。你甚至征召了兄弟来完成一些小任务，单纯用以交换人们的好意。%SPEECH_ON%我找到了那个走失的小顽童，把他直接拖回了家。%SPEECH_OFF%%randombrother%吹嘘道，很快被%randombrother2%所超过。%SPEECH_ON%我去市场替那个老处女买东西，劈好了她冬天的木柴，还帮她晾衣服，但我绝不会去救那些困在树上的猫。%SPEECH_OFF%";
		this.m.SuccessButtonText = "这对我们有帮助。";
	}

	function onUpdateScore()
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && (f.getType() == this.Const.FactionType.Settlement || f.getType() == this.Const.FactionType.OrientalCityState) && f.getPlayerRelation() >= 70.000000)
			{
				this.m.IsDone = true;
				return;
			}
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && (f.getType() == this.Const.FactionType.Settlement || f.getType() == this.Const.FactionType.OrientalCityState) && f.getPlayerRelation() >= 70.000000)
			{
				return true;
			}
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && (f.getType() == this.Const.FactionType.Settlement || f.getType() == this.Const.FactionType.OrientalCityState) && f.getPlayerRelation() >= 70.000000)
			{
				_vars.push([
					"friendlytown",
					f.getName()
				]);
				break;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() > 1)
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
			if (bro.getBackground().getID() == "background.brawler")
			{
				_vars.push([
					"brawler",
					bro.getName()
				]);
				return;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getBackground().isCombatBackground())
			{
				_vars.push([
					"brawler",
					bro.getName()
				]);
				return;
			}
		}

		_vars.push([
			"brawler",
			brothers[this.Math.rand(0, brothers.len() - 1)].getName()
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
