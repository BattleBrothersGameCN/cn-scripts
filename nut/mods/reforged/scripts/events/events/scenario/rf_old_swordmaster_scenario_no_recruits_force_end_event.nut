this.rf_old_swordmaster_scenario_no_recruits_force_end_event <- ::inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.rf_old_swordmaster_scenario_no_recruits_force_end";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]岁月是个驱不散的幽灵，朝你步步紧逼而来。%OOC%正因如此%OOC_OFF%，你踏上了这段旅途，好不辜负师父传给你的技艺。可是到了夜晚，你只是孑孑一人，等着雕琢的学徒却不见踪影。你的新“流派”的传人，要靠其精湛的剑法被歌颂传唱的那个人呢？如果不是要教授别人，你这一趟又是为了什么？\n\n意识到自己的失败，你再次收起武器，转回你的破屋子里去了。也许这些都只是白费时间，只是孤独和愚蠢的浪迹天涯的教训罢了。只要有几个能传承你的传奇的学生的话……哎呀，一切都被你错过了。你不过是个垂垂老矣的老头子，你的所有知识都只能陪着你埋进坟墓。",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我当初到底是图什么……（结束战役）",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Combat.abortAll();
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				this.List = [
					{
						id = 16,
						icon = "ui/backgrounds/rf_old_swordmaster_background.png",
						text = _event.m.Swordmaster.getName() + "放弃了把毕生所学传下去的梦想"
					}
				];
			}

		});
	}

	function onPrepare()
	{
		this.m.Title = "失败";

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
