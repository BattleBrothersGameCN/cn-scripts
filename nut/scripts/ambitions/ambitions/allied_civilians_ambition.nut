this.allied_civilians_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.allied_civilians";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们需要盟友。与某个城镇建立友谊和信任的纽带\n将使战团获得更好的出价，更多的志愿者和更稳定的工作。";
		this.m.UIText = "与一个平民派系达成“友好”关系";
		this.m.RewardTooltip = "建立良好的关系有助于得到更好的出价和更多可雇佣的人。";
		this.m.TooltipText = "通过履行村庄或城镇平民派系的合同，将其关系提升到“友好”级别。半途而废或背叛他们会降低你们的关系。与增进和村庄的关系相比，增进和城邦的关系需要更长的时间。贵族家族不算平民派系。";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]在认定%friendlytown%就是那个值得投入的好地方后，你决定对其提供战团的保护，接受任何适合你能胜任的工作。你在与当地人交易时表现得像个绅士，并鼓励兄弟们在定居点里注意自己的行为举止。一开始当然有些人会有埋怨。%brawler%对不能与农民干架感到非常失望，特别是%companyname%在%friendlytown%待了那么久的情况下。\n\n但你成功让兄弟们相信，干这行没个友好的基地是不行的，因为这意味着在市场上能得到更好的出价，更多的人愿意加入你的杂乱战团。也不用费老大劲躲避民兵了。你甚至征召了兄弟来完成一些小任务，单纯用以博取人们的好意。%SPEECH_ON%我找到了那个走失的小顽童，把他直接拖回了家。%SPEECH_OFF%%randombrother%吹嘘道，很快又被%randombrother2%盖过。%SPEECH_ON%我帮那个老处女去市场买东西，劈过冬用的木柴，甚至还帮她晾衣服，但我和她约法三章，绝不会去救那些困在树上的猫。%SPEECH_OFF%";
		this.m.SuccessButtonText = "我们会从中受益。";
	}

	function onUpdateScore()
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && (f.getType() == this.Const.FactionType.Settlement || f.getType() == this.Const.FactionType.OrientalCityState) && f.getPlayerRelation() >= 70.0)
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

			if (f != null && (f.getType() == this.Const.FactionType.Settlement || f.getType() == this.Const.FactionType.OrientalCityState) && f.getPlayerRelation() >= 70.0)
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

			if (f != null && (f.getType() == this.Const.FactionType.Settlement || f.getType() == this.Const.FactionType.OrientalCityState) && f.getPlayerRelation() >= 70.0)
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
