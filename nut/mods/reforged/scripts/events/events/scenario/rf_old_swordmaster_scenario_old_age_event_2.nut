this.rf_old_swordmaster_scenario_old_age_event_2 <- this.inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.rf_old_swordmaster_scenario_old_age_2";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]{伴随着学徒们的喧闹声，你再次从简陋的帐篷里醒来。炖菜的味道激活了你麻木的鼻子 —— 那是野菜根，打来的肉，还有一些说不清道不明的食物的味道。本来这还是平常的一天，但你刚一起身，顿时觉得眼冒金星，天旋地转，平日矫健的双腿此刻竟突然摇摇晃晃，不听使唤。好在这眩晕来得快去得也快，可是等你掀开门帘，走进清晨的阳光的时候……\n\n几名学徒已经开始了今天的活动。拉伸，推举，奔跑乃至是招式的训练。他们又笑又闹，身体里的能量好像总也用不完。在你的管教和指导下，他们之间亲密无间。%randombrother%看着你，投来了微笑，招呼你坐在营火边。%SPEECH_ON%师父！早安！快来坐！%SPEECH_OFF%你微微一笑，像往常一样精神地走过去坐下。沉浸在学生们的喧闹和交谈中。%SPEECH_ON%看到您起来了真好，我们还以为您就要一直睡下去了呢！%SPEECH_OFF%%randombrother2%笑着，俏皮地向你挤了挤眼。你咂了下舌，停下了盛菜的手，转过头去，挑起了眉毛。%SPEECH_ON%什么意思？%SPEECH_OFF%他耸了耸肩，斟酌着措辞%SPEECH_ON%就是……您平常比我们起得都要早，罢了。我们担心您是不是要睡得久一些。%SPEECH_OFF%他坐在原木上，局促地扭了扭，吞吞吐吐地说道。\n\n你哼了一声，摇了摇头。%SPEECH_ON%我还没那么老呢，说话小心点。我就和你们这帮小子一样硬朗。给我记住！%SPEECH_OFF%你晃了晃拳头，盛了一勺炖菜，一声不吭地吃了起来。而在内心深处，你正一遍遍地回想着你学生那轻巧玩笑背后的残酷现实。}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "时间会带走一切……",
					function getResult( _event )
					{
						_event.m.Swordmaster.getSkills().removeByID("perk.rf_swordmaster_reaper");
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				this.List = [
					{
						id = 16,
						icon = "ui/backgrounds/rf_old_swordmaster_background.png",
						text = _event.m.Swordmaster.getName() + "更老了"
					},
					{
						id = 16,
						icon = ::Const.Perks.findById("perk.rf_swordmaster_reaper").Icon,
						text = _event.m.Swordmaster.getName() + "失去了收割者特技"
					},
					{
						id = 16,
						icon = "ui/backgrounds/rf_old_swordmaster_background.png",
						text = _event.m.Swordmaster.getName() + "会继续随时间变得虚弱，逐渐失去疲劳值、生命值和主动值"
					}
				];
			}

		});
	}

	function onPrepare()
	{
		this.m.Title = "轻巧玩笑";

		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getSkills().hasSkill("effects.rf_old_swordmaster_scenario_avatar"))
			{
				this.m.Swordmaster = bro;
				break;
			}
		}
	}

	function onClear()
	{
		this.m.Swordmaster = null;
	}

});
