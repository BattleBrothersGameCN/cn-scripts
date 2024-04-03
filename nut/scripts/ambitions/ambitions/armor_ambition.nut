this.armor_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.armor";
		this.m.Duration = 40.000000 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "我们要装备出一支至少三人的重装部队\n作为抵御危险对手的堡垒。";
		this.m.UIText = "拥有230耐久以上的铠甲头盔各3件";
		this.m.TooltipText = "拥有230耐久以上的铠甲3件，头盔3顶。无论是市场来的还是战场来的，带来的防护都是实实在在的。";
		this.m.SuccessText = "[img]gfx/ui/events/event_35.png[/img]获得更多的重型铠甲和头盔令 %companyname%精神振奋。%SPEECH_ON%感觉到了吗？这就是手艺。%SPEECH_OFF%%randombrother% 一边说着，一边用木柄敲打他兄弟刚套上头盔的头。%SPEECH_ON%想想我们之前因为烂盔甲和破装备而错过的那些高薪合同吧。%SPEECH_OFF%从现在起，后防线可以在战斗中放松呼吸，因为他们知道他们的重装甲兄弟将在战斗中首当其冲。 万一他们倒下，他们笨重的身躯至少还能迟滞敌人，给他们的轻甲同伴一个迅速撤退的机会。";
		this.m.SuccessButtonText = "它们会在今后的战斗中派上用场。";
	}

	function getArmor()
	{
		local ret = {
			Armor = 0,
			Helmet = 0
		};
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null)
			{
				if (item.isItemType(this.Const.Items.ItemType.Armor) && item.getArmorMax() >= 230)
				{
					++ret.Armor;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Helmet) && item.getArmorMax() >= 230)
				{
					++ret.Helmet;
				}
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

			if (item != null)
			{
				if (item.getArmorMax() >= 230)
				{
					++ret.Helmet;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null)
			{
				if (item.getArmorMax() >= 230)
				{
					++ret.Armor;
				}
			}
		}

		return ret;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 40)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local armor = this.getArmor();

		if (armor.Armor >= 3 || armor.Helmet >= 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local armor = this.getArmor();

		if (armor.Armor >= 3 && armor.Helmet >= 3)
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
