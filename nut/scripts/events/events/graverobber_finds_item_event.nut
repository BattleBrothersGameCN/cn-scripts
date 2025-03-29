this.graverobber_finds_item_event <- this.inherit("scripts/events/event", {
	m = {
		Graverobber = null,
		Historian = null,
		UniqueItemName = null,
		NobleName = null
	},
	function create()
	{
		this.m.ID = "event.graverobber_finds_item";
		this.m.Title = "在途中……";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]The weather is nice. A fine evening, if any, for the moon to be where it is: an orange rind of it slipping in and out of the clouds - clouds that pass by on the seemingly innocuous gesture that a light breeze can have. So bright is this rim of a moon you wonder if any flowers might bloom, mistaking the evening light for its brighter cousin. You wonder if the millmoths and flies and armor-backed beetles see the moon and dance toward it as they would any candle or torch. Do they have that quiet desperation? That inescapable cruelty of realizing that, when your stock is placed against the greater whole, you have and are nothing... and the hatred that realization can bring, and the jealousy...\n\nSuddenly, %graverobber% the graverobber appears by your side, his smell skewering your thoughts with miasmic proficiency. He\'s hardly a man at all, but a golem, mudslaked and grass-peppered with two white eyes peering out. Sighing, you ask what he wants. He thumbs over one shoulder, the other occupied by a shovel.%SPEECH_ON%Went digging through a grave or three. Found somethin\' and I don\'t mean just what them graves are for. Wanna come take a look?%SPEECH_OFF%Of course you do...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们来看看…",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());

				if (_event.m.Historian != null)
				{
					this.Options.push({
						Text = "叫上 %historian% 吧，他是个历史学者，说不定知道下边埋着什么财宝呢。",
						function getResult( _event )
						{
							return "C";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]%graverobber% 把你带到一个大坑边上。 坑底露出半具骨架，手臂撑在地上，就好像是在打瞌睡。 空洞的眼眶却直勾勾地盯着你。 盗墓贼弯腰捡起什么东西。 甩掉上面的泥土又用衣服擦干净递给你。%SPEECH_ON%这东西我们能用得上。%SPEECH_OFF%你点头，叫他在被人发现之前快把墓填了。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "他不再需要那东西了。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local r = this.Math.rand(1, 8);
				local item;

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/bludgeon");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/falchion");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/knife");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/dagger");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/weapons/shortsword");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/weapons/woodcutters_axe");
				}
				else if (r == 7)
				{
					item = this.new("scripts/items/weapons/scramasax");
				}
				else if (r == 8)
				{
					item = this.new("scripts/items/weapons/hand_axe");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]当你低头检视这些东西时，%historian% 这位相当精明的学者兼历史学家侧身坐在你旁边。 他一边抓耳挠腮，口中喃喃自语。%SPEECH_ON%是的，没错…%SPEECH_OFF%你问他什么意思。 他打了个响指，指着盗墓贼找到的东西。 他说这些东西不是一般的家伙，而是属于一位著名的斗士、贵族和情圣，%noblename%。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "真不错。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local item;
				local i = this.Math.rand(1, 8);

				if (i == 1)
				{
					item = this.new("scripts/items/shields/named/named_bandit_kite_shield");
				}
				else if (i == 2)
				{
					item = this.new("scripts/items/shields/named/named_bandit_heater_shield");
				}
				else if (i == 3)
				{
					item = this.new("scripts/items/shields/named/named_dragon_shield");
				}
				else if (i == 4)
				{
					item = this.new("scripts/items/shields/named/named_full_metal_heater_shield");
				}
				else if (i == 5)
				{
					item = this.new("scripts/items/shields/named/named_golden_round_shield");
				}
				else if (i == 6)
				{
					item = this.new("scripts/items/shields/named/named_red_white_shield");
				}
				else if (i == 7)
				{
					item = this.new("scripts/items/shields/named/named_rider_on_horse_shield");
				}
				else if (i == 8)
				{
					item = this.new("scripts/items/shields/named/named_wing_shield");
				}

				item.m.Name = _event.m.UniqueItemName;
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_graverobber = [];
		local candidates_historian = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				candidates_graverobber.push(bro);
			}
			else if (bro.getBackground().getID() == "background.historian")
			{
				candidates_historian.push(bro);
			}
		}

		if (candidates_graverobber.len() == 0)
		{
			return;
		}

		this.m.Graverobber = candidates_graverobber[this.Math.rand(0, candidates_graverobber.len() - 1)];

		if (candidates_historian.len() != 0)
		{
			this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
		this.m.NobleName = this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)];
		this.m.UniqueItemName = this.m.NobleName + "的盾牌";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"graverobber",
			this.m.Graverobber.getNameOnly()
		]);
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getNameOnly() : ""
		]);
		_vars.push([
			"noblename",
			this.m.NobleName
		]);
		_vars.push([
			"uniqueitem",
			this.m.UniqueItemName
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Graverobber = null;
		this.m.Historian = null;
		this.m.UniqueItemName = null;
		this.m.NobleName = null;
	}

});
