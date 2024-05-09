this.cultist_origin_flock_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_flock";
		this.m.Title = "在路上……";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_03.png[/img]{%joiner%，一个流浪的达库尔信徒，已经来加入%companyname%。战团成员们聚集在他周围，他点头，他们也点头回应，就这样他加入了你们。 | %joiner%，一个衣衫褴褛但身披达库尔的黑暗的人，加入了%companyname%。 | 一个名叫%joiner%的人向你展示了他对达库尔的奉献，一系列的精神仪式在他的头骨上形成了可怕的伤疤。他被欢迎加入%companyname%。 | %joiner%在直接找上你之前已经跟踪了战团一些时间。他是达库尔目的的拥护者，随着这一点，他的论点已经得到确认，并使你自己也同样参与其中。这个人加入了战团。 | 达库尔肯定在一个名叫%joiner%的人加入%companyname%时监督着你。他表示他只有一个目的，那就是找到你，并确保这个世界见证它所等待的一切。 | %joiner%说他看到你身体后面的影子闪烁，好像是“火焰”。他说他会加入你的事业，因为达库尔肯定在你身上植入了黑暗和无限的一面。 | %joiner%走在你身边。他称你为达库尔黑暗的一面，那永恒的眼睛一定会守护你的整个团队。%companyname%的名字把他带到了它的许多阴影羽翼之下。 | %joiner%找到了正在行军的%companyname%并加入了它的行列，就好像他根本不是陌生人。没有人说话，你只是简单地指引他去库存处，让他的目的在那儿变得具体明确。 | %joiner%露出他那伤痕累累的脑袋，表示他是达库尔目标的先锋。你点头并欢迎他进入%companyname%。 | 行走在达库尔的阴影中，你一定会发现像%joiner%这样的人。他渴望加入这个战团，尤其是因为你是这个战团的掌舵人，更重要的是，他相信达库尔选择了你。 | %joiner%加入了战团，至于为什么，几乎没有争论。当被问到他来自哪里时，他耸耸肩并提到了达库尔，同时向你有意地点点头。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "是的，加入我们。",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
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
					"cultist_background"
				]);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		this.m.Score = 75;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"joiner",
			this.m.Dude.getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});
