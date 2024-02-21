this.golden_goose_event <- this.inherit("scripts/events/event", {
	m = {
		Observer = null
	},
	function create()
	{
		this.m.ID = "event.location.golden_goose";
		this.m.Title = "当你接近时……";
		this.m.Cooldown = 999999.000000 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_125.png[/img]{船只搁浅在树林之中，有些树木已经长穿而过。据你所知，方圆数英里内，既无海洋也无河流。%observer%走近，目睹此景，不禁驻足。%SPEECH_ON%天哪，那是艘船吗？%SPEECH_OFF%你轻叹一声，命令战团在此等候，而你和那位目光敏锐的佣兵前去探查。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "让我们看看里面藏有什么秘密。",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "现在不是探查的时候。",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_125.png[/img]{你踏入船舱深处。里面除了一个插着斧头的树桩，别无他物。%observer%看着它。%SPEECH_ON%那有个斧头。%SPEECH_OFF%你点头确认。但斧头的金属上，有着金色的纹理。走近树桩，你能看到一缕缕的余烬从楔子上飘散。%observer%轻拍你的肩膀，指向黑暗的角落说。%SPEECH_ON%骷髅。死的。%SPEECH_OFF%你勉强能看到苍白的骨头。随着你走近，一身皇家服饰逐渐显现。他一手握着破碎的啤酒角杯，另一手拿着霉变的面包。外衣被木刺撕成碎片。仔细观察，一些木头嵌入了他的颅骨。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "检查那树桩。",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "我们走吧。",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_125.png[/img]{既然骷髅和他的啤酒、面包不会动，就随它去了。然而，那斧头再次吸引了你的眼球。%observer%走到树桩和发光的楔子旁。他试图将其拔出。发现无济于事，他愤怒地后退并踢了一脚。树桩裂成两半，佣兵猛然倒飞，斧头射穿天花板，你能听到它在右舷砰砰作响。碎屑和烟尘缓缓飘散。佣兵起身，拍拍身上的灰尘。%SPEECH_ON%那到底是什么鬼东西？%SPEECH_OFF%你让他安静并指给他看。一只小金鹅蹲在树桩的原址处。它的金属光泽闪烁流转着。你听说过金鹅的故事，但从没想过它真的存在！}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "真的吗？",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_125.png[/img]{%observer%踉跄着向前。%SPEECH_ON%先生，您在做什么？%SPEECH_OFF%你挥手让他退后，然后捡起了金鹅。双手捧着它，感觉异常温暖。而且它既没有爆炸也没有融化你的脸。你能感觉到它的金属在你的指尖微微波动。甚至可能在长大？你把宝藏安全地夹在肘下，心中疑惑那具骷髅为什么没有好运。%observer%走上前来触摸金鹅的头，但很快就缩回了手。你问他是否被烫伤了。佣兵抿紧嘴唇。%SPEECH_ON%真的，先生？这不是显而易见的吗？%SPEECH_OFF%他把手指放进嘴里。你告诉他不许对指挥官这么无礼，否则你会把金鹅扔向他，看看金鹅能否像对付骷髅那般迅速解决掉他。佣兵耸了耸肩。%SPEECH_ON%哦，看看这个被闪亮玩意选中的人，把剑放在翅膀下让它封你为骑士吧，或者为什么不直接戴在头上，自封为王呢？%SPEECH_OFF%你低头看着金鹅。一滴红色的血顺着它的长度流下，变成金色，然后落到地上，发出轻微的叮当声。你捡起来咬了一口。金子在你的牙齿间满足地变形，然后你把它扔给了%observer%。这次没有烫伤他，你意识到你可能真的找到了传说中的金鹅！}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "传说是真的！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/special/golden_goose_item");
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
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getBackground().isNoble() && !bro.getSkills().hasSkill("trait.bright") && !bro.getSkills().hasSkill("trait.short_sighted") && !bro.getSkills().hasSkill("trait.night_blind"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Observer = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		else
		{
			this.m.Observer = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"observer",
			this.m.Observer != null ? this.m.Observer.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Observer = null;
	}

});
