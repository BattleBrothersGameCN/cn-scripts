this.rf_old_swordmaster_scenario_old_age_event_4 <- this.inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.rf_old_swordmaster_scenario_old_age_4";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]黎明时分，趁着学生们都在睡觉，你悄悄溜到了离战团远一点的地方，想要自己呆一会。坐在初升的太阳下，许多思绪从你脑海中闪过。虽然壮年早已不再，但你依然活跃在战场上。手中的利剑，汗湿的额头，一呼一吸间，你正在战斗的最中心，和野兽战斗，和人类战斗，和绿皮战斗……但，这一切都有代价。过去最多算是有点恼人的旧伤疤，每走一步都会传来阵阵刺痛。每挥剑一次，那酸痛都能让你今夜的睡眠再晚一分……\n\n太多故友或战死沙场，或解甲归田。从军时的军士%randomname%受封骑士，获得了%randomtown%乡间一块不小的封地。如今他无力打理，把家业都托付给了儿子。可是越往下看你越是发现，没有几封信是本人回复 —— 多是遗属告知故人已殁于疾病、战乱或谋杀，剩下的直接音讯全无，看来也是死了。\n\n练剑的伙伴死于盗匪，授业恩师死于瘟疫，就连你求爱过的姑娘，也早就成家，在老伴和儿孙的陪伴下死去了。大多数人都扛不过岁月的侵袭……你也不例外,就连你的学徒们也都注意到了。%randombrother%和%randombrother2%最先发觉，开始用担忧的目光打量着你。你的步伐不再有剑客的优雅，而是像枯树般蹒跚。握餐具的手开始颤抖，挣扎着把食物送到嘴边。\n\n剑术依然能技惊四座，身体却不免日渐衰朽。每当比试结束后，你总是喘也喘不匀，站也站不直。\n\n直到夕阳西下，你才意识到，整整一天，你都在回顾自己的一生，还有那些和你生命有交集的人的一生。长空血染，夕阳垂空，归巢倦鸟，阵阵哀鸣……你冷冷地叹了口气，朝着营地走去，走回到悦耳的金铁交鸣声中。",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "日升日落……",
					function getResult( _event )
					{
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
						icon = "ui/backgrounds/rf_old_swordmaster_background.png",
						text = _event.m.Swordmaster.getName() + "会随时间变得虚弱，逐渐失去疲劳值、生命值和主动值"
					}
				];
			}

		});
	}

	function onPrepare()
	{
		this.m.Title = "余晖";

		foreach( bro in this.World.getPlayerRoster().getAll() )
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
