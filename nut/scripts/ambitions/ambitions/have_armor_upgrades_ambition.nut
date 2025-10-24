this.have_armor_upgrades_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_armor_upgrades";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "对真正的雇佣兵来说，普通的盔甲实在太过乏味。\n我们应该把战利品用上，好好装饰我们的装备！";
		this.m.UIText = "为至少6件盔甲装上附件";
		this.m.TooltipText = "为你拥有的至少6件盔甲装上附件。买来的，抢来的，请剥制师做出来的，统统安到你的人的盔甲上。";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]当你接掌战团时，有的不过是一群苟且求生的乌合之众，一群临时拼凑起来，靠顽固和对常识的绝对蔑视捆绑在一起的佣兵。而现在在你眼前的是，一群四处走动着，狂野得超出了认知的亡命之徒，他们的盔甲上装饰着狰狞的战利品、毛皮和骨头，这种病态的再创作使其他人知道，%companyname%已经摆脱了常识的束缚，不能被简单归类为野兽或人类了。";
		this.m.SuccessButtonText = "这对我们很有帮助。";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().Days <= 20)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local upgrades = 0;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Armor) && item.getUpgrade() != null)
			{
				upgrades = ++upgrades;
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && item.isItemType(this.Const.Items.ItemType.Armor) && item.getUpgrade() != null)
			{
				upgrades = ++upgrades;
			}
		}

		if (upgrades > 6)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local upgrades = 0;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Armor) && item.getUpgrade() != null)
			{
				upgrades = ++upgrades;
			}
		}

		if (upgrades >= 6)
		{
			return true;
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && item.isItemType(this.Const.Items.ItemType.Armor) && item.getUpgrade() != null)
			{
				upgrades = ++upgrades;
			}
		}

		return upgrades >= 6;
	}

	function onPrepareVariables( _vars )
	{
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
