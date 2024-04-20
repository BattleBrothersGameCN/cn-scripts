this.taxidermist_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.taxidermist";
		this.m.Duration = 21.000000 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "没什么能比冻土野兽的战利品更让人尊敬。让我们去狩猎一些然后请剥制师干点活！";
		this.m.UIText = "在剥制师那里制作物品";
		this.m.TooltipText = "拥有至少12件剥制成品。剥制师主要分布在被沼泽和森林覆盖的定居点，他们能把野兽掉落的东西制成有用的物品，比如罕见的大型恐狼掉落的狼皮。";
		this.m.SuccessText = "[img]gfx/ui/events/event_97.png[/img]一个年轻男孩招呼你，问你是不是%companyname%的队长。你环顾四周，问他这对他来说意味着什么。他耸了耸肩。%SPEECH_ON%啊，先生，这并不是我的意思。如果我找到并带来这个所谓的队长，我会得到三枚金币的报酬。就这样。%SPEECH_OFF%你感到好奇，问他谁给你的这笔赏金。男孩在挖鼻子，抬头看着你。%SPEECH_ON%赏金？我还没有见到那些赏金！得先找到那个人！%SPEECH_OFF%你叹了口气，把男孩的手，连带着鼻涕什么的，掰到一边，又问了他一编。男孩皱起眉头看着地上的蚯蚓，想了想。%SPEECH_ON%是剥皮的人，不是收税的那种，我爸爸说那些人就是长手指的恶魔，他才不会付给我钱。我是说剥动物皮的人。他剥下兽皮，做成很厉害的衣服、毯子、毒药、饮料。他们聊天的时候说%companyname%给他们带来了最多的生意，他们都迫不及待地想再见到那个战团！%SPEECH_OFF%啊，他在说剥制师 。微笑着，你拍了拍男孩的头，祝他好运。他吐了口痰，清了清嗓子。%SPEECH_ON%不是运气的问题，我打算用聪明才智找到那个人。张大眼睛擦亮耳朵，提起腰带扎紧裤子的方式。%SPEECH_OFF%";
		this.m.SuccessButtonText = "%companyname% 自豪地展示他们的战利品。";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(12, this.World.Statistics.getFlags().get("ItemsCrafted")) + "/12)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Statistics.getFlags().get("ItemsCrafted") >= 12)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		return this.World.Statistics.getFlags().get("ItemsCrafted") >= 12;
	}

	function onPrepareVariables( _vars )
	{
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});
