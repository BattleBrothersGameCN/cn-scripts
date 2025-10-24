this.webknecht_exposition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.webknecht_exposition";
		this.m.Title = "在路上……";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{你在路边发现一个男子正在用研钵捣鼓树叶，他自己也嚼着些绿色植物，抬头朝你露出满嘴绿乎乎的笑容。%SPEECH_ON%我一直与爬虫和飞虫打交道，可那帮蛛魔可完全是另一码事。从没见过爬这么快的玩意儿，咔嚓咔嚓地窜过来，抓狗逮猫什么的，把猎物全拖走。你们最好离那些天杀的蜘蛛远点，听见没？%SPEECH_OFF%这有个农妇倚在门框上，端着酒杯朝战团连连点头。她指着你时含糊说话，杯里的酒撒的满地都是。%SPEECH_ON%呵，蜘蛛饲料送上门了？听着，那帮八条腿的杂种可不会跟你玩捉迷藏，它们一饿就能找着你，而且它们永远都饿着肚子，没错先生，永远满嘴冒毒沫，千真万确。%SPEECH_OFF%她仰头灌完酒，哐当一声瘫倒在门框里。 | 你遇见个待在白杨树上的年轻人。他竟在树顶搭了间茅厕大小的木棚。年轻人低头朝你点头。%SPEECH_ON%你们觉得我和这棵树很离谱是吧？告诉你们，那些蛛魔来得飞快。像狗那么大的蜘蛛！知道我怎么应对吗？去他妈的。从今往后我就在树上过日子，要是那些该死的畜生长出翅膀，我干脆自我了断算了！%SPEECH_OFF%蛛魔似乎把当地人都逼疯了——不过这倒也情有可原。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "看来会有人掏钱请我们对付这些东西。",
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

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});
