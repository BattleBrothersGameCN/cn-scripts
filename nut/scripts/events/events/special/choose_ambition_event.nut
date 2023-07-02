this.choose_ambition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.choose_ambition";
		this.m.Title = "露营时……";
		this.m.HasBigButtons = true;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			Banner = "",
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";

				if (this.World.Assets.getOrigin().getID() == "scenario.paladins")
				{
					this.Text = "[img]gfx/ui/events/event_183.png[/img]{在过去的几天里，我们一直在思考小安瑟姆的誓言中该选哪一个。 你能从骨子里感觉到正确的选择是… | 白昼来了又去，在夜晚，你大多独自坐着沉思。 但你并不总是孤独的。 正当你自省的时候，宣誓者小安瑟姆来了，他给了你目的和责任，在刚刚过去的这个晚上，他明确地告诉你，%companyname%的下一个誓言应该是… | 在内部和外部的斗争中，有一场永恒的战争，那就是遵循小安瑟姆的誓言。 在这些考验中，你必须把自己隔离起来，独自思考，直到最后，它来到你身边！ %companyname%的下一个誓言无疑是… | 独自坐着思考不仅仅是一项体力工作。 你必须清除你头脑中所有的阻碍和干扰，去除每一个元素，直到你处于最纯粹的黑暗状态，在那里，微弱的微光可以成为占卜，明亮地屹立在黑暗之中。 它就在那里，顷刻之间向你走来，在小安瑟姆的手的光芒中，真理在它闪烁的明澈中沸腾！ 你的真实目的，以及 %companyname%的未来，它必须承诺一个誓言… | 一些宣誓者喜欢沉默，另一些人喜欢唱歌和民谣。 你自己静静地站在那里，尽管营地里传来了 %companyname%的嘈杂声。 如果你想寻求小安瑟姆的指导，那么他肯定需要知道你不是一个人来的。 当你开始认为宣誓者不会出现时，一个想法闪过你的脑海。 %companyname% 的目的和使命现在比以往任何时候都更加明确。 瞬间，小安瑟姆的预言浮现在你的脑海中，你知道战团只会承诺一个誓言… | %companyname% 会因为没有目标而沮丧。 感觉到他们的需求，你会让自己安静下来，坐下来理清思绪。 小安瑟姆从不让自己分心你觉得这对你也有好处。 随着时间的流逝，一个想法萦绕在你的脑海中。 你相信它是轻浮的，很快就会消失，但相反，它只会不断成长，直到你最终意识到它是小安瑟姆指引的核心。 而且那个指引只说了一件事，%companyname%的誓言应该是…}";
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_58.png[/img]{今天吹起了一阵清新凉爽的微风，你觉得这是一个%companyname%开始新事物的好时机。你叫大家围过来…\n\n你会告诉他们什么呢？ | 你今天感觉很好，准备领导 %companyname% 完成任何挑战。 你开始把周围的人都召集起来，你踢了 %randombrother% 脚一下并且告诉 %randombrother2% 晚些时候再剃他脖子上的毛。 当所有人的抱怨都停止了之后，你就开始和他们说话。\n\n你会告诉他们战团要怎么做？ | 按照惯例，你将会告诉这些人战团下一步的计划。%SPEECH_ON%兄弟们，%companyname% 必须向世界表明，我们是由比其他雇佣兵团更炽烈的火焰锻造而成的。 随着我们声誉的增长，克朗也会流入我们的金库中。 让我们锻造一条通向伟大的道路！%SPEECH_OFF%你会告诉他们战团要怎么做？ | 当战团休息的时候，你决定向他们讲话。%SPEECH_ON%兄弟们，我想让每个人都知道 %companyname% 不只是杀手和跑腿的男孩，而是熟练的一流战士。 我们的名声必须传播出去，这样商人和贵族就会恳求我们接受他们的合同。%SPEECH_OFF%你会告诉他们战团接下来要怎么做？ | 当战士们检查装备，磨光刀锋，修补盔甲时，你坐在那里和他们开玩笑，你的思绪就会转移到思考如何改进战团，提高战团在世界各地的名誉。\n\n你的结论是什么，你对他们说了什么？ | 这是你的责任，指挥官，战团要取得成功并不能只在战场上还要在名誉和财富上。 于是你整个晚上都呆在帐篷里，想着为 %companyname% 制定一个更大的计划，而周围的人则围坐在火炉边说笑。 你们永远不可能仅仅因为追赶强盗而成为传奇。\n\n你要向众人宣告什么，他们要去做什么呢？}";
				}

				local selection = this.World.Ambitions.getSelection();
				this.Options = [];

				foreach( i, s in selection )
				{
					this.Options.push(_event.createOption(s));
				}
			}

		});
	}

	function createOption( _s )
	{
		return {
			Text = _s.getButtonText(),
			Tooltip = _s.getButtonTooltip(),
			Icon = "ui/icons/ambition.png",
			function getResult( _event )
			{
				this.World.Ambitions.setAmbition(_s);
				return 0;
			}

		};
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});
