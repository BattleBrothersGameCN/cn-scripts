this.lone_wolf_origin_depressing_lady_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.lone_wolf_origin_depressing_lady";
		this.m.Title = "在%townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_91.png[/img]{路过某个贵族房子的时候，你遇见了一位老妇人。她打量你就像打量着过去的自己。你觉得有点好笑，就问她想要做什么。老妇人微笑着说道。%SPEECH_ON%你觉得自己挺有本事吧？当个雇佣骑士，这逛逛那逛逛，打一辈子架，搞一辈子女人？%SPEECH_OFF%尽可能礼貌地，你告诉他你并不是一个东奔西走，赶着打竞技赛的无赖，而是个正儿八经的雇佣兵。她耸了耸肩，手往贵族房子那边一甩%SPEECH_ON%那又能怎样？他们可不会接纳你的。你是很能打，但你永远也进不去那里，永远。他们让你进，那你才能进。出身是什么样，你就该是什么样。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我会改变这个世界的。",
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
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.lone_wolf")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});
