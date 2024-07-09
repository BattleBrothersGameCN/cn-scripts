this.defeat_civilwar_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_civilwar";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "如果我们能为一个贵族家族赢得这场战争，我们将名冠天下。\n让我们选择一方，沐浴在战斗的荣光里，并借此发家致富吧！";
		this.m.UIText = "结束贵族家族之间的战争";
		this.m.TooltipText = "选择一个贵族家族，与他们合作，粉碎他们的敌人。每摧毁一支军队，每履行一份合同，都将加速战争的结束。";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]在%winninghouse%的授意下，%companyname%与其他家族的武装军队对抗，这似乎是一项无法征服的挑战。对手训练有素、纪律严明、装备精良，真是一场恶战，你战胜了%winninghouse%的敌人，并代表它取得了胜利。\n\n在随后的庆祝活动中，%randomnoble%，%winninghouse%的小贵族之一，提议你应该提前结束庆祝活动。你的人开始惹起了麻烦，他担心你们的人可能会利用他家人的好客，偷走银制餐盘，与工作人员斗殴。他已经注意到有一扇窗户被打破，并指了指地板上的一些碎玻璃。\n\n你回答虽然%winninghouse%取得了胜利，但在这一刻，它比以往任何时候都更加脆弱。现在这个时刻疏远朋友…或树立新敌愚蠢至极。\n\n他将你的建议牢记在心，庆祝活动一直持续到黎明。";
		this.m.SuccessButtonText = "不管是喜欢我们还是憎恨我们，%companyname%的名字传遍了每一个人！";
	}

	function getUIText()
	{
		local f = this.World.FactionManager.getGreaterEvil().Strength / this.Const.Factions.GreaterEvilStartStrength;
		local text;

		if (f >= 0.95)
		{
			text = "短兵相接";
		}
		else if (f >= 0.5)
		{
			text = "激战正酣";
		}
		else if (f >= 0.25)
		{
			text = "难解难分";
		}
		else
		{
			text = "尘埃落定";
		}

		return this.m.UIText + " (" + text + ")";
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1500)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.FactionManager.getGreaterEvil().Type == 0 && this.World.FactionManager.getGreaterEvil().LastType == 1)
		{
			return true;
		}

		this.World.Ambitions.updateUI();
		return false;
	}

	function onPrepareVariables( _vars )
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);
		local bestRelations = -1.0;
		local best;

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() > bestRelations)
			{
				bestRelations = f.getPlayerRelation();
				best = f;
			}
		}

		if (best == null)
		{
			return;
		}

		_vars.push([
			"winninghouse",
			best.getName()
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
