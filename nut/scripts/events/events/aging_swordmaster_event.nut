this.aging_swordmaster_event <- this.inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.aging_swordmaster";
		this.m.Title = "在途中……";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]你看到%swordmaster%费力地想要坐在树墩上。 当他慢慢蹲下时，他的双腿因难以弯曲而剧烈颤抖。好不容易坐下后，他不由得长出了一口气。他的剑就在身旁。它比拥有它的手还年轻，是一个替代品的替代品的替代品。他对它没有特殊的偏好，但一旦他摸到剑，剑就成了他想法的延伸，如何把剑变成自己身体的一部分，如何用它的锋刃砍杀别人。你转身离开，想让剑术大师独自静一静，但他已经注意到了你，开口喊道。%SPEECH_ON%嗨，队长，不是有意让你看到的。%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "你还好吗？",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "好吧，但我已经看到了。我们走吧。",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_17.png[/img]他颓然后仰，粗糙的手不停按摩着膝盖。斑白的头发随风舞动。%SPEECH_ON%老了，我越来越老了。不是年龄的问题，那么算的话我早就老了。我是说，我已经是一把老骨头了。我已经是名不副实了。%SPEECH_OFF%你立刻反对，告诉他他是你见过的最致命的人之一。%SPEECH_ON%把这些甜言蜜语用在女人身上吧，队长。我老眼昏花。你可能不愿意听这些话，但这是事实。我不再健步如飞，双脚像灌了铅一样。膝盖也不再灵活，咔哒作响。总有一天，我会失去在战场上自保的能力。我的副手已经失去知觉了。%SPEECH_OFF%剑术大师握了握他空着的手。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "感觉怎么样？",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_17.png[/img]%SPEECH_ON%什么感觉都没有。我想我的神经已经不行了。有时我会忘记一些事情。不是把鞋子扔到了什么地方，而是忘了自己背后有人。眼观六路耳听八方才是我真正的本事，但现在不行了，这才是最致命的。我速度再快，直觉再好，也终究是躲不过时间。时间缓慢但从不停下，不冷不热，丈量着过去现在和将来。我一直以为我会被另一个剑客，某个天才打败。但我想我做得太好了。%SPEECH_OFF%剑术大师玩笑似地笑了起来。你问他是否害怕默默死去。%SPEECH_ON%很久之前，遇到你的时候，我就意识到，怎样的死法都不会让我满意。那些人会在书上大书特书，一个小人物如何杀死了伟大的剑术大师。一派胡言。我实话告诉你。我害怕我想象的结局就要到了。我的身体会在最后时刻背叛我。我的身体早晚要害死我。膝盖变得僵硬，肩膀变得疲惫，握剑的双手也没了力气。我不怕死，死了反而是种解脱。死神本人来了也要排队，我的身体会抢先杀了我，死神只能带走剩下的东西，一副长毛发黑的倒霉皮囊。作家和历史学家？去他们的吧。如果我想要永恒的荣耀，那我早就去单挑一支军队了。%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "据我所知，你已经做到了。",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_17.png[/img]老剑术大师开怀大笑。%SPEECH_ON%别拿我寻开心了，队长。扶我一把，我们继续赶路。%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "时光流逝。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				local old_trait = this.new("scripts/skills/traits/old_trait");
				_event.m.Swordmaster.getSkills().add(old_trait);
				_event.m.Swordmaster.setHitpoints(this.Math.min(_event.m.Swordmaster.getHitpoints(), _event.m.Swordmaster.getHitpointsMax()));
				this.List = [
					{
						id = 13,
						icon = old_trait.getIcon(),
						text = _event.m.Swordmaster.getName() + "变老了"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_17.png[/img]你转身时听到了老剑术大师的叹息。 看来，仅仅是跟上战团的步伐，对他来说就已经是一场战斗了。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "时光流逝。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				local old_trait = this.new("scripts/skills/traits/old_trait");
				_event.m.Swordmaster.getSkills().add(old_trait);
				_event.m.Swordmaster.setHitpoints(this.Math.min(_event.m.Swordmaster.getHitpoints(), _event.m.Swordmaster.getHitpointsMax()));
				this.List = [
					{
						id = 13,
						icon = old_trait.getIcon(),
						text = _event.m.Swordmaster.getName() + "变老了"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 9 && bro.getBackground().getID() == "background.swordmaster" && !bro.getSkills().hasSkill("trait.old") && !bro.getFlags().has("IsRejuvinated"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Swordmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = this.m.Swordmaster.getLevel() - 5;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"swordmaster",
			this.m.Swordmaster.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Swordmaster = null;
	}

});
