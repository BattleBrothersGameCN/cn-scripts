this.make_nobles_aware_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.make_nobles_aware";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们要获得某个贵族家族的青睐，以期得到回报更丰厚的工\n作。他们老是惹火上身，但只要给得够多，那又有什么关系呢？";
		this.m.RewardTooltip = "解锁贵族签发的新类型合同，这些合同的报酬更高";
		this.m.UIText = "达到“行家里手”名望";
		this.m.TooltipText = "以“行家里手”（1050名望）闻名，吸引贵族家族的注意。你可以通过完成合同和赢得战斗来提高自己的名望。";
		this.m.SuccessText = "[img]gfx/ui/events/event_31.png[/img]为了让%companyname%出出名，进而在贵族圈子里找点存在感，你鞭策着你的人，做了不少大事，展现了杰出的勇气，制造了不少伤亡。在完成了数个合同，打了几场遭遇战之后，你们的时间和努力，终于足以让一些领主注意到战团的能力。\n\n这些所谓的绅士们，能成为这片土地的统治者，全靠他们早死完了的祖先征服了一帮手无寸铁的农民的英勇事迹。按照%highestexperience_brother%的说法，现在这些娇生惯养、近亲繁殖的纨绔子弟对你的印象已经够深，随时准备把战团投入到他们的争斗中当炮灰了。没错，如果你好好把脸洗干净，礼貌地问上一问的话，他们就会不时地赏你一份有利可图的合同。你得好好为自己庆祝一番！";
		this.m.SuccessButtonText = "我们要从贵族的口袋里掏钱了！";
	}

	function onUpdateScore()
	{
		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 800)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() >= 1050 && this.World.FactionManager.isGreaterEvil())
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBusinessReputation() >= 1050)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "贵族开始向你派发合同了"
		});

		if (!this.World.Assets.getOrigin().isFixedLook())
		{
			if (this.World.Assets.getOrigin().getID() == "scenario.southern_quickstart")
			{
				this.World.Assets.updateLook(14);
			}
			else
			{
				this.World.Assets.updateLook(2);
			}

			this.m.SuccessList.push({
				id = 10,
				icon = "ui/icons/special.png",
				text = "你在世界地图上的形象已经更新了"
			});
		}
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
