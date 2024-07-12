this.have_z_renown_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_z_renown";
		this.m.Duration = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "历史上少有传奇雇佣兵战团。我\n们的名字将列入其中，成为不朽！";
		this.m.UIText = "名望达到“举世无双”";
		this.m.TooltipText = "以“举世无双”（8000名望）闻名，在历史上留下你的印记。你可以通过完成合同和赢得战斗来提高自己的名望。";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]什么‘战斗之后鲜血流成了河’，‘有一百座堡垒被你们烧毁’，‘一万只肥壮的乌鸦在你的背后欢宴’，关于你战团有多强大的故事总也没个完。在这个世界已知的每个角落，提起“%companyname%”，人们都会发出欢呼或是肃然起敬。父亲们用你们最勇敢的手下给他们的儿子取名，而这些孩子会在模仿你们参加过的许多著名战役中长大。\n\n你现在名声大噪，只要不是在小村庄里都会带来不便。无论旅行到哪里，你都被日夜不停地骚扰。妙龄少女们为了争夺男人们的注意力，最终互相拳脚相向。店主们认为你财大气粗，随时会来向你推销商品。最糟糕的是，每个自大狂都会来挑战你的人，而民兵正等着结果，希望在街头斗殴的那点罚款会上升到血债的程度。\n\n你实现了你的目标，尽管结果与你预期的不完全一样。不管你个人的命运如何，%companyname%已经在世界历史上成为不朽。";
		this.m.SuccessButtonText = "%companyname%的名字将永垂不朽！";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 60)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() <= 4000 || this.World.Assets.getBusinessReputation() >= 7800)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBusinessReputation() >= 8000)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		if (!this.World.Assets.getOrigin().isFixedLook())
		{
			if (this.World.Assets.getOrigin().getID() == "scenario.southern_quickstart")
			{
				this.World.Assets.updateLook(15);
			}
			else
			{
				this.World.Assets.updateLook(3);
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
