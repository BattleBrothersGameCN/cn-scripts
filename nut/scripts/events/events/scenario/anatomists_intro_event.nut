this.anatomists_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.anatomists_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_181.png[/img]{你刚开始以为他们是赏金猎人，但他们很快就更正了你的想法声称他们是“研究者”，而不是“搜索者”。 你正在一头雾水的时候，他们解释说他们其实是“解剖学家”不过这其实一点也不能帮助你理解他们的身份。 感到解释徒劳无功，他们说你是个“聊天黑洞”，你自豪地反驳道你至少听懂了“聊天”这个词是什么意思，不过他们都笑了起来说你听错了他们这是在鸡同鸭讲。 感觉到他们在嘲笑你，你拔出了你的剑而他们此刻却把双手高高举起以示没有恶意，每只手都拿着一个装满克朗的钱包。\n\n又深入谈了一会儿，你发现他们是一群对尸体有着强烈兴趣的学者。 既然你很擅长制造尸体，他们觉得雇你帮他们制造尸体就挺合适的。 你要穿过大陆，雇佣一支强大的雇佣军，并且帮这群怪人完成他们的科学研究。 你唯一的要求就是如果你不幸死掉他们可不许对你的尸体做那些奇奇怪怪的勾当。 这些解剖学家面上带着温暖的笑容做出保证说绝不会对有生意往来的人做这种事。 每个人笑得都好难看就好像是跟死人学的怎么笑一样，不过你也只好相信他们。}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "转念一想，你必须承诺我活着的时候你们也不许动我的身体，必须。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "解剖学家";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});
