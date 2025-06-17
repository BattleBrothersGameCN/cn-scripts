this.miasma_flail_spooks_bro_3_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.miasma_flail_spooks_bro_3";
		this.m.Title = "在途中……";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{一个声音溜进了黑暗当中：你的妈妈在哪里……她就故意把你遗弃……我在哪里……我就给你她缺失带来的伤害那么多的爱。我会把你养育得很强大，佣兵，我会用生命的乳汁哺育你……\n\n 你猛然惊醒，只见眼前一片绿光，赶快一巴掌把它扇到了一边。%hauntedbrother%跌坐在地上，大先知的链枷咣地一声落在他的身边。佣兵摇摇头，眼睛睁得大大的，疑惑地环顾着四周。%SPEECH_ON%什，什么？我怎么跑到这里来了？%SPEECH_OFF%你盯着那链枷，看着它青绿的的光逐渐消散，一阵怪异的笑声随之回响起来。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "这噩梦……真是阴魂不散。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.worsenMood(1.0, "被大先知的链枷蛊惑");

				if (_event.m.Dude.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local haveFlail = false;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			candidates.push(bro);
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && item.getID() == "weapon.miasma_flail")
			{
				haveFlail = true;
			}
		}

		if (!haveFlail)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && item.getID() == "weapon.miasma_flail")
				{
					haveFlail = true;
					break;
				}
			}
		}

		if (!haveFlail)
		{
			return;
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hauntedbrother",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});
