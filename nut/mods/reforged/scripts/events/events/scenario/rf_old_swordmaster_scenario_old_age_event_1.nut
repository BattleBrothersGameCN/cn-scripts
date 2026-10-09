this.rf_old_swordmaster_scenario_old_age_event_1 <- this.inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.rf_old_swordmaster_scenario_old_age_1";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]{%SPEECH_START%劈！挡！反刺！逼出破绽，一击决胜！%SPEECH_OFF%你向学徒们喊出口令，看着他们反复打磨连击动作，直到完全掌握为止。看到%randombrother%精准完成斜斩，后撤调整架势格开反击，挑剑穿过对手的护手，精准点向对手的胸膛时，一股自豪感在你的胸中涌动。他和不同的学徒反复对练，直到对上了你的目光。%SPEECH_ON%师父！可以让我和您过过招吗？我觉得我已经完全掌握了！%SPEECH_OFF%呵呵一笑，你点了点头，迈步上前。接过另一名学徒手中的训练剑，找了个合适的位置，把双手举过头顶，摆出了顶势。弓起咯吱作响的膝盖，耐心地等待他的攻击。短暂对峙之后，他把木剑直向你的胸口刺来，你迅速放低架势，把他的武器格开，并尝试用刺击反击。%randombrother%设法抬起他的武器，把你的剑撞向了高位，制造了一个短暂的破绽 ―― 膝盖偏偏在这时候打起了颤，搞得你措手不及！\n\n眼看反击就要命中，你及时侧身避线，轻轻斩出一个半弧，把他的攻击弹开。钝剑同时击中了他的武器和暴露的持剑手。折回手腕干净利落的完成了收势。活泼的学徒退后一步，笑出声来%SPEECH_START%中了！%SPEECH_OFF%这番示范让你喘起了粗气。明明是个简单的动作，却让一丝酸意攀上了你的胳膊。要是以前，这动作做很多次你都不会出汗。试图掩饰疲惫，你示意%randombrother%凑近一些，而你则坐在树桩上，指导他如何更好地防御长剑挥击。}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我还能行！",
					function getResult( _event )
					{
						_event.m.Swordmaster.getSkills().removeByID("perk.rf_swordmaster_juggernaut");
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
						icon = "ui/backgrounds/ptr_old_swordmaster_background.png",
						text = _event.m.Swordmaster.getName() + "更老了"
					},
					{
						id = 16,
						icon = ::Const.Perks.findById("perk.rf_swordmaster_juggernaut").Icon,
						text = _event.m.Swordmaster.getName() + "失去了巨力特技"
					},
					{
						id = 16,
						icon = "ui/backgrounds/ptr_old_swordmaster_background.png",
						text = _event.m.Swordmaster.getName() + "会随时间变得虚弱，逐渐失去疲劳值、生命值和主动值"
					}
				];
			}

		});
	}

	function onPrepare()
	{
		this.m.Title = "简单动作";

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
