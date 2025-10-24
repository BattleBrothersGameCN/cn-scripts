this.alp_nightmare1_event <- this.inherit("scripts/events/event", {
	m = {
		Victim = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.alp_nightmare1";
		this.m.Title = "露营时……";
		this.m.Cooldown = 300.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{伙计们正围坐在营火旁交谈，%spiderbro%却突然猛地跳起来尖叫。他踉跄后退，在火光照耀下，你看见一只头盔大小的蜘蛛正附在他的靴子上！}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "剁了那玩意！",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "用火烧它！",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]{你刚拔出剑来，%otherbro%却已抢先出手。他大喊着让%spiderbro%站着不动。对方勉强照做。然而持剑的佣兵这一挥竟高高扬起，利刃径直掠过那人的脖颈。无头身躯应声倒地，战团其余成员在惊骇与暴怒中咆哮不止。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "他妈的！",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.Characters.push(_event.m.Other.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Victim.getName() + "死了"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Victim.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_39.png[/img]{你冲向%otherbro%想要掐死他，双手却如穿透雾气般掠过他的身体，整个人因惯性栽倒在地。%SPEECH_ON%呃，你没事吧队长？%SPEECH_OFF%你回过头，只见%spiderbro%完好无损地坐在篝火旁。远处树后有个苍白矫健的身影悄然隐没。你眨眼的功夫，那影子便消失无踪。你吩咐队员们加强守夜，揉着发胀的太阳穴走回帐篷。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "只是做了个噩梦。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%spiderbro%僵硬地走向营火，那只幼蛛竟用异常温顺的眼神仰望着他。他将小生物抛进火坑，火焰瞬间包裹了它。正当你以为危机解除时，着火的蜘蛛竟顺着裤腿急速上爬，点燃衣裤直扑面门。浑身着火的男人张开双臂疯狂奔逃，蜘蛛将毒牙埋入他的头颅——惨叫在骤然僵直中戛然而止，这名佣兵如同木板般直挺挺栽进了营火堆。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "把他挪走！",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Victim.getName() + "死了"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Victim.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_39.png[/img]{你朝佣兵们厉声下令，但当你扑向营火旁的%spiderbro%时，骤然迸发的火星与灰烬迷蒙了视线——待烟尘散去，只见这名佣兵安然坐在火焰旁。%SPEECH_ON%啊，队长，你说什么？%SPEECH_OFF%环顾四周，战团成员们仍在闲谈。当你再度望向%spiderbro%时，似乎有抹白影在他身后掠过，定睛看去却已无踪。你吩咐众人保持警觉，随即回到了自己的帐篷。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我得多休息一些。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		foreach( i, bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				brothers.remove(i);
				break;
			}
		}

		if (brothers.len() < 3)
		{
			return;
		}

		this.m.Victim = brothers[this.Math.rand(0, brothers.len() - 1)];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Victim.getID())
			{
				other_candidates.push(bro);
			}
		}

		this.m.Other = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"spiderbro",
			this.m.Victim.getName()
		]);
		_vars.push([
			"otherbro",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Victim = null;
		this.m.Other = null;
	}

});
