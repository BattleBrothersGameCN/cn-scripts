this.rf_old_swordmaster_scenario_old_age_event_3 <- this.inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.rf_old_swordmaster_scenario_old_age_3";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]你坐在一块大石头上，看着学徒们做着他们的日常训练，把同样的动作，步伐和招式练了一遍又一遍。金属碰撞声如战歌般回荡，让你干裂的嘴唇扬起了笑意。这般技巧，速度和耐力，或许有一天能追上你的影子……\n\n不过，现在还差得远！他们要学的东西还多着呢！你走近了正在比试的%randombrother%和%randombrother2%。他们的武器翻飞交缠，尽显防守、格挡和精准打击的技巧。但随着你走得越来越近，许多问题暴露在你的眼前。脚步凌乱，手腕绵软，没留任何后手就让出了太多空间。你举起手中止了比试，看向%randombrother%，示意他给你武器。%SPEECH_START%来，把它给我……%SPEECH_OFF%轻轻一握，你拿过了武器，站在了他的位置上。%SPEECH_ON%你一味后退，却没有考虑怎么夺回。所谓久守必失，如果只顾防守，你的敌人只要不停试探，就能让你精疲力尽，破绽百出。除非你肺如风炉，心如钢铁，他%OOC%早晚会%OOC_OFF%胜过你。看好了，什么叫做攻防一体！%SPEECH_OFF%你调整握法，右脚前探，看向“对手”时武器便已经就位。%SPEECH_ON%接招！%SPEECH_OFF%你率先发起突刺，试图拉近距离，威胁对手。突然，左腿膝盖受不住重压，一股剧痛涌上胸口，让你瞪大了眼睛。攻击的势头顿时受挫，自然被化解。%randombrother2%挑起你的武器，谨慎地踏向了一侧。他把武器高举过头顶，左手提到胸前，朝你的胸口劈来。这样的攻击很容易就能弹开……你便这么做了。你的胳膊却突然不听使唤，正在你尝试挡住的时候 —— \n\n他击中了你。\n\n你跟不上反应，他的木剑顺着你的剑格，刺向了你的软肋。随着%OOC%咔嚓！%OOC_OFF%一声，剧痛像潮水般淹没了你，你踉跄着后退，肺中的空气仿佛抓住了机会，四相逃散出去。你试着重新恢复平衡，把腿定在地上，膝盖却又一次软了下去。一处旧伤终究没有放过你，脆弱的关节再也支撑不住你的身体。终于，你瘫倒在地，像一条上钩的鱼，痛苦地扭动着。\n\n几分钟后，痛苦渐渐消退了，对你来说，却像是过了几个小时。空气总算又在你的肺里哼哧了起来。在几名学徒的帮助下，你痛苦地呻吟着站立。迅速向%randombrother2%点了点头，你转过身，手搭在%randombrother%的肩上，一瘸一拐地走回了帐篷。",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我还有多少时日？",
					function getResult( _event )
					{
						_event.m.Swordmaster.getSkills().removeByID("perk.rf_swordmaster_precise");
						_event.m.Swordmaster.getSkills().removeByID("perk.rf_swordmaster_blade_dancer");
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				local injuries = [
					{
						ID = "injury.fractured_ribs",
						Threshold = 0.25,
						Script = "injury/fractured_ribs_injury"
					}
				];

				if (_event.m.Swordmaster.getSkills().hasSkill("injury.fractured_ribs"))
				{
					injuries = [
						{
							ID = "injury.broken_ribs",
							Threshold = 0.5,
							Script = "injury/broken_ribs_injury"
						}
					];
				}

				local injury = _event.m.Swordmaster.addInjury(injuries);
				this.List = [
					{
						id = 16,
						icon = "ui/backgrounds/rf_old_swordmaster_background.png",
						text = _event.m.Swordmaster.getName() + "更老了"
					},
					{
						id = 16,
						icon = ::Const.Perks.findById("perk.rf_swordmaster_precise").Icon,
						text = _event.m.Swordmaster.getName() + "失去了精准特技"
					},
					{
						id = 16,
						icon = ::Const.Perks.findById("perk.rf_swordmaster_blade_dancer").Icon,
						text = _event.m.Swordmaster.getName() + "失去了刀锋舞者特技"
					},
					{
						id = 16,
						icon = "ui/backgrounds/rf_old_swordmaster_background.png",
						text = _event.m.Swordmaster.getName() + "会继续随时间变得虚弱，逐渐失去疲劳值、生命值和主动值"
					}
				];

				if (injury != null)
				{
					this.List.push({
						id = 16,
						icon = injury.getIcon(),
						text = _event.m.Swordmaster.getName() + "身受" + injury.getNameOnly()
					});
				}

				_event.m.Swordmaster.addLightInjury();
				this.List.push({
					id = 16,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Swordmaster.getName() + "受了轻微伤"
				});
			}

		});
	}

	function onPrepare()
	{
		this.m.Title = "如鱼离水";

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
