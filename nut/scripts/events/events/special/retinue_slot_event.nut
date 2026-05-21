this.retinue_slot_event <- this.inherit("scripts/events/event", {
	m = {
		LastSlotsUnlocked = 0
	},
	function create()
	{
		this.m.ID = "event.retinue_slot";
		this.m.Title = "在途中……";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%companyname%的威信和名望不断提高。无论你走到哪里，都有人想要加入——不仅仅是佣兵，还有能在其他方面派上用场的追随者！ | 随着每一场战斗的胜利，战团的名望不断提升。名声越响，想要加入%companyname%的人就越多——不限于佣兵。或许是时候考虑吸纳新的追随者了？ | %companyname%的追随者不必都是战士——随着战团名望和威信的增长，似乎也有人愿意依附于我们。即使这些人不能在战场上效力，或许也能为战团提供重要帮助。}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "看看能招募到什么随从！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local unlocked = this.World.Retinue.getNumberOfUnlockedSlots();

		if (unlocked > this.m.LastSlotsUnlocked && this.World.Retinue.getNumberOfCurrentFollowers() < unlocked)
		{
			this.m.Score = 400;
		}
	}

	function onPrepare()
	{
		this.m.LastSlotsUnlocked = this.World.Retinue.getNumberOfUnlockedSlots();
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU8(this.m.LastSlotsUnlocked);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);
		this.m.LastSlotsUnlocked = _in.readU8();
	}

});
