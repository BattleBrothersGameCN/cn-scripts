this.manhunters_origin_capture_prisoner_event <- this.inherit("scripts/events/event", {
	m = {
		LastCombatID = 0,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.manhunters_origin_capture_prisoner";
		this.m.Title = "战斗之后……";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "Nobles",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use. | %SPEECH_ON%Slaving shit, do your worst.%SPEECH_OFF%Despite being the last man standing, the northerner\'s still got some fight in him. He may do well in the %companyname%. | You find the last man standing, hurt but alive. He\'s a northerner and would look good in chains. Perhaps fetch a solid price in the south, or serve as fodder on the frontlines? | The northern troop has been cut down to its last, a pale man who seems to not dwell long in defeat.%SPEECH_ON%Southern shits, your \'Gilder\' can suck my balls. C\'mon, give me a weapon, I\'ll show you how a northerner dies!%SPEECH_OFF%You can\'t help but like his gusto. Instead of serving worms in the grave, perhaps he could serve the company as one of the indebted?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "将他作为镀金者的负债者这样他可以赢得他的救赎。",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.000000, "战败被俘");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "我们不需要他。",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "以前是一个忠于贵族的士兵，他的战团被你们的人屠杀了，而 %name% 成为了负债者。 没花多少时间他就精神崩溃了，强迫他为你而战。";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Civilians",
			Text = "[img]gfx/ui/events/event_53.png[/img]{幸存者艰难的爬离你。他在咕哝这什么。 你听不清，但语言还是很明显的：他知道你是谁，你是什么。 | 战斗结束了，你在战场找到一个幸存者。 他有点伤但是还有用。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "将他作为镀金者的负债者这样他可以赢得他的救赎。",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.000000, "战败被俘");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "我们不需要他。",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% 在和你的人的战斗中勉强幸存下来后成为了负债者。 他的精神崩溃了，他被迫为你而战，这样做他就可以偿还镀金者的债务了。";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Bandits",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use. | The lone bandit survivor yells out for the old gods as you weigh a chain in your hand, wondering how it will fit around his neck. | %SPEECH_ON%Is this the penalty for banditry?%SPEECH_OFF%The northerner asks as you weigh a chain in your hand. You\'re still not sure yet of how you\'ll handle him, but answer anyway.%SPEECH_ON%This isn\'t punitive at all, it\'s merely business.%SPEECH_OFF% | The bandit tries to hide, but as the last survivor he\'s about as easy to spot as a white rabbit on a bloodslaked battlefield. He yells out that the old gods wouldn\'t abide by men such as yourself. You shrug.%SPEECH_ON%The old gods aren\'t standing where I am, now are they?%SPEECH_OFF%And you hold out the chain, sizing it with his neck.%SPEECH_ON%But I wonder, how much would you give up, to swap spots with one of your gods, hm?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "将他作为镀金者的负债者这样他可以赢得他的救赎。",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.000000, "战败被俘");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "我们不需要他。",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% 在和你的人的战斗中勉强幸存下来后成为了负债者。 他的精神崩溃了，他被迫为你而战，这样做他就可以偿还镀金者的债务了。";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Nomads",
			Text = "[img]gfx/ui/events/event_172.png[/img]{幸存者艰难地爬离你。他在咕哝这什么。 你听不清，但语言还是很明显的：他知道你是谁，你是什么。 | 战斗结束了，你在战场找到一个幸存者。 他有点伤但是还有用。 | 你向游牧民伸出锁链，在远处用它的闭锁抓住了他的头。%SPEECH_ON%有时候在沙漠里，一个人可能经过了一些他不该打扰的人。 有时候他能走开。%SPEECH_OFF%你紧紧的抓住锁链。%SPEECH_ON%有时候他只是走着。%SPEECH_OFF% | 沙漠滑动着，一个受伤的游民试着逃跑。 你轻松的把靴子踩在他身上并按住他，你的另只手用奴隶锁链圈住他的脖子。 | 游牧民恳求原谅。%SPEECH_ON%通过远离你的阴暗，镀金者的光辉将我们都照亮！%SPEECH_OFF%你举起锁链并告诉他不是所有阴暗都是我们生来的一部分。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "将他作为镀金者的负债者这样他可以赢得他的救赎。",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.000000, "战败被俘");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "我们不需要他。",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% 在和你的人的战斗中勉强幸存下来后成为了负债者。 他的精神崩溃了，他被迫为你而战，这样做他就可以偿还镀金者的债务了。";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CityState",
			Text = "[img]gfx/ui/events/event_172.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use. | %SPEECH_ON%The Gilder wouldn\'t have it.%SPEECH_OFF%He is the last of the southern troop, a wounded pitiful man begging for his life. You hold up the chain.%SPEECH_ON%Just because this is on you does not mean your path is shadowed, fellow traveler. Just means mine is a little bit brighter.%SPEECH_OFF% | %SPEECH_ON%Ah, please don\'t!%SPEECH_OFF%You have your boot on the last of the southern troop, and you are sizing him up to join the indebted. He begs for his life, or for freedom, and eventually to simply die free. You shake your head.%SPEECH_ON%Gold cannot live or die, traveler, it is merely weighed. Heavy. Or light. My considerations do not concern you. You beg about something you lost the moment you crossed paths with me.%SPEECH_OFF% | The last of the southern troop is at your feet. He\'s praying to the Gilder to bring light to his path. Unfortunately, the only one with say here is yourself, and you\'ve got a spot in chains for the man if you wish him to \'join\' the %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "将他作为镀金者的负债者这样他可以赢得他的救赎。",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.000000, "战败被俘");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "我们不需要他。",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% 在和你的人的战斗中勉强幸存下来后成为了负债者。 他的精神崩溃了，他被迫为你而战，这样做他就可以偿还镀金者的债务了。";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Barbarians",
			Text = "[img]gfx/ui/events/event_145.png[/img]{幸存者艰难的爬离你。他在咕哝这什么。 你听不清，但语言还是很明显的：他知道你是谁，你是什么。 | 战斗结束了，你在战场找到一个幸存者。 他有点伤但是还有用。 | 啊，最后的幸存者。 他挺大个儿的，这个野蛮人，而且可以为你效劳。 当然，戴着锁链。 | %companyname% 很少过手这些北方野蛮人。 当最后一个幸存者留在战场上时，你思索把他作为负债者会不会对你有利。 | 最后一个野蛮人站立着。 他用一种你从没有时间去学习的语言向你说话。 嘟囔着，低吼着，一些其他语言会当做威胁的东西，但是这里你知道他在试图说什么比较重要的事情。 但是，你的回应只有锁链，还有这个野人可能会是个非常棒的负债者在 %companyname%。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "将他作为镀金者的负债者这样他可以赢得他的救赎。",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.000000, "战败被俘");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "我们不需要他。",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_barbarian_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% 在和你的人的战斗中勉强幸存下来后成为了负债者。 他的精神崩溃了，他被迫为你而战，这样做他就可以偿还镀金者的债务了。";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function isValid()
	{
		if (!this.Const.DLC.Desert)
		{
			return false;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.manhunters")
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("LastCombatID") <= this.m.LastCombatID)
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 5.000000 || this.World.Statistics.getFlags().getAsInt("LastCombatResult") != 1)
		{
			return false;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return false;
		}

		local f = this.World.FactionManager.getFaction(this.World.Statistics.getFlags().getAsInt("LastCombatFaction"));

		if (f == null)
		{
			return false;
		}

		if (f.getType() != this.Const.FactionType.NobleHouse && f.getType() != this.Const.FactionType.Settlement && f.getType() != this.Const.FactionType.Bandits && f.getType() != this.Const.FactionType.Barbarians && f.getType() != this.Const.FactionType.OrientalCityState && f.getType() != this.Const.FactionType.OrientalBandits)
		{
			return false;
		}

		this.m.LastCombatID = this.World.Statistics.getFlags().get("LastCombatID");
		return true;
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		local f = this.World.FactionManager.getFaction(this.World.Statistics.getFlags().getAsInt("LastCombatFaction"));

		if (f.getType() == this.Const.FactionType.NobleHouse)
		{
			return "Nobles";
		}
		else if (f.getType() == this.Const.FactionType.Settlement)
		{
			return "Civilians";
		}
		else if (f.getType() == this.Const.FactionType.Bandits)
		{
			return "Bandits";
		}
		else if (f.getType() == this.Const.FactionType.Barbarians)
		{
			return "Barbarians";
		}
		else if (f.getType() == this.Const.FactionType.OrientalCityState)
		{
			return "CityState";
		}
		else if (f.getType() == this.Const.FactionType.OrientalBandits)
		{
			return "Nomads";
		}
		else
		{
			return "Civilians";
		}
	}

	function onClear()
	{
		this.m.Dude = null;
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU32(this.m.LastCombatID);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 54)
		{
			this.m.LastCombatID = _in.readU32();
		}
	}

});
