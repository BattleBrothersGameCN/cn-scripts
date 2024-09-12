local gt = this.getroottable();

if (!("Contracts" in gt.Const))
{
	gt.Const.Contracts <- {};
}

gt.Const.Contracts.IntroNobleHouseNeutral <- [
	{
		ID = "Intro",
		Title = "谈判",
		Text = "[img]gfx/ui/events/event_20.png[/img]{一个男人突然挤了过来，让你大吃一惊。你刚要抽出武器，他就快速解释说，有个叫%employer%的人要找你。你将武器放回鞘中，叫这陌生人带你去找他 —— 如果他真有事，他应该亲自告诉你。信使点点头，带路去了一个贵族的府邸。 | 一个信使 —— 一个跟一把长剑齐高的年轻小伙子 —— 从你身边冲过，呼啸而过的同时将一个卷轴抛在了空中。你伸手抓住它，当你想找那孩子时，他已经消失得无影无踪了。你耸耸肩，打开卷轴看到了%employer%的名字。看起来他需要你的帮助。这位贵族住所的方向就写在卷轴底部。 | 你漫步在%townname%，一个信使悄无声息地靠近了你。你瞥了他一眼，那可怜家伙将一卷卷轴扔到你手中，然后匆匆跑开。你打开卷轴，发现一位当地贵族要求与你见面。 | %townname%看上去祥和极了，但事实肯定没这么简单，要不然不会有信使给你带来当地贵族的便条。哪里有财富，哪里就有麻烦…… | 一位信使和你打招呼。他自称是个龙套角色，因为你也很快就忘记了他叫什么。然而，他带来的信息非常重要：一位当地贵族要求与你见面。 | 一只鸟飞上你的肩头，停在了那儿。它对着你咕咕叫，抬起了一只拴着便条的爪子。在你接过这张纸条的瞬间，鸟儿就飞走了，它只关心自己的投递服务，对其他事物并不感兴趣。这张纸条揭示了一位当地贵族，据信是鸟类的朋友，要求与你见面。 | 一只绳子拴着的狗朝你跑来，汪汪地叫个不停。绳子另一头的人朝狗点了点头。你看到它的脖圈上挂着一卷卷轴，这小畜生似乎是只传信的杂种犬。要么就是有人在开玩笑。\n\n拿起便条，上写着一位当地贵族需要你的服务。也许这并不是个笑话。那只狗再次吠叫并摇摇尾巴，乖乖地坐下，看起来相当得意。 | 一个男人挺直了腰板朝你走来。其中一只手举着一张卷轴，简直像是高跷上的布告板。他什么也没说，只是把手伸了过来，你也便直接取下了卷轴。上面写道一位当地贵族正在找你，兴许还包括你的服务。你向信使致谢，但他什么也没说，只是转过身，像踩高跷般沿路走开了。 | 你走在%townname%的路上，只听当地酒馆里传出了一阵笑声，几个人一边狂笑着一边朝你挥手。他们笑得前仰后合，几乎说不出话来：显然某位贵族正在寻找佣兵。有趣，但你忍不住要询问他们为什么发笑。男人们沉默了一会儿，其中一位耸耸肩，另一个人咳嗽着讲出答案。%SPEECH_ON%可能是喝多了？%SPEECH_OFF%男人们紧绷了脸，但不到一秒钟，笑声又爆发了出来。 | 一位当地贵族的仆人表示，他受主人之命，让你随他而去。他将你带到了%townname%富人区，那的建筑更高，街道上也没有马粪味。最终，你来到了一座庄园，看上去曾经应该是座庙。猫头鹰装饰点缀着屋檐，在你经过时盯着你看。一只愁眉苦脸的猫在前台阶上懒洋洋地晃荡。你通过一扇奢华的前门，门轴和门大幅度摆动的声音回荡在门厅里。你的嘴巴张得大大的，几乎无法用言语形容里面的壮丽景象。}",
		Image = "",
		List = [],
		ShowEmployer = false,
		ShowDifficulty = true,
		Options = [
			{
				Text = "谈谈正事吧。",
				function getResult()
				{
					return "Task";
				}

			}
		]
	}
];
gt.Const.Contracts.IntroNobleHouseFriendly <- [
	{
		ID = "Intro",
		Title = "谈判",
		Text = "[img]gfx/ui/events/event_20.png[/img]{几个乡民走上前来，其中一个甚至伸出手要拥抱你。你婉拒了。%SPEECH_ON%很高兴再次见到你，佣兵。%employer%一直在找你。%SPEECH_OFF% | 你走进镇子，一个女人给了你一朵花。这与平时人们关上门窗藏起孩子的反应大相径庭。你接过花，她摆动着裙摆欢快地离开。一个男人走向你。%SPEECH_ON%打扰了，先生，镇上的居民似乎对您很感兴趣。%employer%也是，自从得到您来到镇上的消息后，他就一直在找您。%SPEECH_OFF% | 一群狗沿路跑来，几个孩子在后追赶。他们一个接一个的从你身边绕开，狗欢快地叫着，孩子们尖叫着问候。一个女人走过来，一手拿着煎锅，一手拿着抹布。%SPEECH_ON%你好，佣兵。本来着应该是信使的事儿，但反正我都知道了，干脆直接告诉你得了。%employer%在找你。%SPEECH_OFF%她眨巴着眼睛。你微笑着点头。%randombrother%笑了起来。%SPEECH_ON%先生，看到你中意的了？%SPEECH_OFF%你让他滚开。 | 几只山羊咩咩叫着，被人领着走在路上。它们拖着脚步走在泥里，用鼻子在泥里翻找，不知怎地就找到了可以吃的东西。他们的牧人把手杖插在土里。%SPEECH_ON%你好，佣兵。%employer%正在找你。%SPEECH_OFF% | 一个男人坐在门廊上，一见到你就探出了身子。他伸出一根手指。%SPEECH_ON%看啊，这不就是大伙嘴里的佣兵嘛。%SPEECH_OFF%你环顾四周，点了点头。他又笑又叫。%SPEECH_ON%我操，看到你真他妈太好了！要是我不告诉你%employer%正在找你，那我可就太不够意思了。去找他吧。告诉他是我告诉你的，或许我能拿到赏钱。那混球，或许就会送束花。要么就是只猫。谁想要猫？干嘛要送我猫？我告诉过他我讨厌猫了……%SPEECH_OFF%当他仍在喋喋不休的时候，你一声不响地离开了。 | 一个女人向你跑来。她还带着孩子，看来对佣兵没有太多戒备心。其中一个小孩抱住了你的腿。%SPEECH_ON%他回来了！%SPEECH_OFF%你低头咧开笑容，试图甩开这小兔崽子，但他以为你这是在哄他玩。母亲抱走了小孩，然后伸手指出了方位。%SPEECH_ON%%employer%在找你。告诉他是我把你叫去的，如果他知道是我帮的忙，没准会来修好我们的井。%SPEECH_OFF%她看起来疲惫极了，孩子们闹腾得她不得安宁。 | 你走进%townname%，一人把你招呼到了他的花园里。他在料理植物，用一只沉稳的手修剪蔬菜或水果之类的东西，不是园丁的你并不能辨识。%SPEECH_ON%过得怎么样，佣兵？如果你在找活，%employer%一直有谈到你。我猜他应该也想见见你，如果你还想继续和他合作的话。给你，接住。%SPEECH_OFF%他转身朝你扔来一颗{卷心菜 | 洋葱 | 土豆 | 西红柿}。%SPEECH_ON%接得好。%SPEECH_OFF%你咬了一大口，点了点头。%SPEECH_ON%味道还不错。%SPEECH_OFF% | 一名年迈的店主朝你挥手。%SPEECH_ON%再见到你真好，佣兵。这话你听过好几十次了吧？%SPEECH_OFF%他伸手指向路。%SPEECH_ON%要是你还想再干点好事，%employer%一直在找你呢。%SPEECH_OFF% | 一个正在剪羊毛的人看着你，那只瘦小的羊正在扭来扭去。%SPEECH_ON%我就该吃了这小畜生。瞧她这德行。别折腾了，好吗？%SPEECH_OFF%他用胳膊肘捅了捅那羊，它发出一声咩叫，用羊所能发挥的智慧咒骂回去。那人又看向你。%SPEECH_ON%你应该就是大伙嘴里的那个佣兵吧。我得跟你说，嗯，我想我会，呃，那个，%employer%一直在找你。%SPEECH_OFF%羊弹跳着想逃跑，但是被那人按倒在地。%SPEECH_ON%小王八蛋，再折腾我就把你的奶给挤干！%SPEECH_OFF%}",
		Image = "",
		List = [],
		ShowEmployer = false,
		ShowDifficulty = true,
		Options = [
			{
				Text = "那就说正事吧。",
				function getResult()
				{
					return "Task";
				}

			}
		]
	}
];
gt.Const.Contracts.IntroNobleHouseCold <- [
	{
		ID = "Intro",
		Title = "谈判",
		Text = "[img]gfx/ui/events/event_20.png[/img]{你小心翼翼地走进%employer%的一位联络人的家。他坐在火堆旁，一手拿着卷轴，一手拿着高脚杯。%SPEECH_ON%就不必坐了吧，佣兵。你也不想让我的舒适被寒意破坏了，对吧？如果你在找%employer%，我可以替你传话给他。他对你不太满意，但生意就是生意，就像我们常说的。%SPEECH_OFF%他笑着举起酒杯向你示意。 | %employer%的几名保镖叉着手站在你面前。%SPEECH_ON%我们要怎么对付他来着？%SPEECH_OFF%你紧紧握住剑柄。其中一人笑了。%SPEECH_ON%放他过去。就这样。不知道为什么，%employer%还想继续和他做生意，依我看，我们现在就应该把他干掉。%SPEECH_OFF%虽然他们放你通过了，但你仍然留心着周围的环境。 | 虽然无法确切指出，但%townname%最近似乎颇具敌意。你走到哪里，那里的窗户就纷纷合上，仿佛你的脚步带来了风。当门一扇扇关上、乡民们纷纷逃散时，一名民兵走了过来。%SPEECH_ON%%employer%想见见你，但是你得规矩点。他现在心情可不太好。%SPEECH_OFF% | 当你走过的时候，几个民兵吹着口哨大喊。%SPEECH_ON%某些人居然还敢来，胆儿真肥啊。嘿，佣兵！要是还想做生意的话，%employer%乐意再聊聊。就是，你懂的，这次别再搞砸了！%SPEECH_OFF% | 一个男人紧握着战犬们的链子，它们朝你的腿咬了过来，差点距离咬空了。它们的驯养者看着你，一瞬间似乎准备松开链子。%SPEECH_ON%哦，是你。好吧，%employer%一直在找你。%SPEECH_OFF% | 你走过几名民兵。他们口吐唾沫，把剑鞘摇地叮当作响，但是你毫不在意。一名穿着华丽斗篷的人向你走来。%SPEECH_ON%如果你想做生意，就跟我来吧。%employer%想和你谈谈。%SPEECH_OFF% | 你从她身边走过时，一个女人朝你扔了一棵烂菜。它飞得很偏，你回以恶毒的眼神。而她对你冷嘲热讽。%SPEECH_ON%我说你下次得瞄准点！%SPEECH_OFF%你拍了拍剑柄，她飞快跑开。一个男人走上前来，这一幕令他笑出了声。%SPEECH_ON%佣兵，你在镇上可不怎么受欢迎。跟我来吧，好找%employer%谈谈。%SPEECH_OFF% | 几名正在磨剑的民兵瞥见了你。%SPEECH_ON%他的脑袋是不是值几个钱？%SPEECH_OFF%另一人猛拍了下他的肩膀。%SPEECH_ON%你他妈声音是不是太大了点？嘿，佣兵！%employer%挺想和你聊聊！%SPEECH_OFF%呃，好吧，当然了。 | 你走近一个牵着许多战犬的男人。它们坐得笔直，听从命令，没有一只伸着舌头。它们的驯养者盯着你，牵狗绳的手虚握着。%SPEECH_ON%你知道吗，%employer%说要我一见到你就任这些畜生扑出去。然后他又说，不，还是算了。他就这样犹豫不决，一会儿说让狗吃顿好的，一会儿说让你活着。%SPEECH_OFF%你问驯犬师最后是怎么决定的。他扭头吐了口唾沫。%SPEECH_ON%上去见%employer%吧。他只想谈谈。%SPEECH_OFF% | 你经过一颗挂着绳子的树。旁边一人大喊道。%SPEECH_ON%小心，死人在走路！%SPEECH_OFF%当你转头看向他时，他大笑起来。%SPEECH_ON%别担心，我觉得他们只是把东西挂那儿演习而已。还没到用它的时候。去见%employer%吧。%SPEECH_OFF% | 你路过一个正在看通缉令的人。他盯着它，然后盯着你，再盯着海报，然后又盯着你。%SPEECH_ON%该死。长得真像。嘿，佣兵！我听说%employer%想找你聊聊！%SPEECH_OFF%}",
		Image = "",
		List = [],
		ShowEmployer = false,
		ShowDifficulty = true,
		Options = [
			{
				Text = "那就谈谈吧。",
				function getResult()
				{
					return "Task";
				}

			}
		]
	}
];
gt.Const.Contracts.IntroSettlementNeutral <- [
	{
		ID = "Intro",
		Title = "谈判",
		Text = "[img]gfx/ui/events/event_20.png[/img]{一个罩着斗篷的人朝你吹了声口哨，在兜帽遮掩下，你只能短暂看到他的牙齿和鼻子。你没空理会麻风病人或者小丑，让那家伙把路让开。他却说起话来。%SPEECH_ON%我的主人需要你的服务，他听说过你的事。跟我来，我带你去见他。%SPEECH_OFF%你把手放在剑柄上，点了点头。 | 你独自坐着，仔细研究着一张地图，一阵强风吹来，你费力地把纸按在桌子上，这时，你的一名手下%randombrother%走了过来，把酒杯拍在了地图的一角。只见他张着嘴巴，满嘴酒气。他解释说，他与一个名叫%employer%的当地人分享了一些见闻，那人提出要和你谈谈。地图和上面的土地又不会飞走，你同意见见他。 | 刚踏进%townname%，就有人蹚着泥朝你走来。他自称受雇于%employer% —— 一个在镇上有一定权势的人物，他与其它人决定请你为他们的服务，保护他们的财产。 | 一人朝你走近，递来一个卷轴。%SPEECH_ON%我的名字是%randomname%，%employer%以及%townname%正派人的代表。我们需要你的服务，佣兵。%SPEECH_OFF% | 一人从路边走了过来。他穿得像个乡下人，却跟着两名装备精良的护卫。他称自己是一名议员，受雇于%employer% —— %townname%的领袖。他让你去见他。 | 一个兜帽男示意你跟他走。他紧张地看着身后，把你带到了当地一家酒馆的后屋。他朝窗外望了望才开口 —— 以防隔墙有耳。%SPEECH_ON%一个叫%employer%的重要人物想见你一面。 他在这镇子里颇有名望，所以你应当能理解我的谨慎。%SPEECH_OFF%他推来一张纸 —— 上面写着如何找到他。 | 一个醉酒的女人向你扑来。她满口下流之辞，口水都快流到你耳朵里了，你用棍子将她打开。一个旁观者冲到你身边，把那个妇人拉到一边。%SPEECH_ON%滚，婊子！跟你说多少次了？%SPEECH_OFF%那女士大摇大摆地走了，在经过的男人身上搭来搭去，像只树丛间晃荡的动物。你的“救命恩人”伸出手。%SPEECH_ON%我是%randomname%。一位大人物，%employer%，一直在找你。跟我来，我带你去见他。%SPEECH_OFF% | 趁着你的人在镇子里晃悠的功夫，你在酒馆找了个位置坐了下来。屁股还没坐热，一个陌生人就凑了过来。%SPEECH_ON%你是%companyname%的？%SPEECH_OFF%你点点头。那人也点了点头，把手伸进了口袋。你伸手去够匕首。他又把手拿了出来。%SPEECH_ON%放轻松。我身上带着把剑。如果我想要你命，坐下可不是个好办法。%SPEECH_OFF%那人掀起剑鞘，磕了磕桌子底。他歪着头，好像在说“明白了？”，你点点头，那人又把手伸进口袋，掏出一张纸条递给你。%SPEECH_ON%一位叫%employer%的当地议员想见你。%SPEECH_OFF% | 你在%townname%四处闲逛，拦住一个人，问他附近有没有什么有趣的事情。他一边想着，把一根滴水的臭草叉扛在了肩上。%SPEECH_ON%这个嘛。有马子啊，嗯 ——%SPEECH_OFF%他被自己的话逗乐了。%SPEECH_ON%她们很好。还有%employer%。等等，你不是那个佣兵伙计吗？%SPEECH_OFF%那陌生人眯起眼睛看着你，然后迅速继续说道。%SPEECH_ON%哦靠，当然了。没错，%employer%谈到过你。他说……“%randomname%，去清理马厩里的屎蛋。如果你看到人们说到的佣兵，就让他来找我。”%SPEECH_OFF%他停了下来，指着路边的一栋建筑。%SPEECH_ON%啊，没错。要是你想赚点钱花花，那儿那家伙很愿意付钱。我觉得他用不着另找人来铲屎，别惦记这活儿了。这屎我已经包圆了！%SPEECH_OFF% | 你走进一间酒馆，吸引了一些人的目光。男人们交头接耳，女人们则像往常一样瞟来瞟去。酒保将一块布塞进杯子里，招呼你过来。%SPEECH_ON%你就是人们谈论的那个佣兵吧。%SPEECH_OFF%你好奇地问他是如何知道的，毕竟你并不是唯一一个随身带剑的人。他笑了。%SPEECH_ON%眼睛。我从眼睛就能看出来。你狩猎着那些最为危险的猎物，以取人性命为生，构筑了自己的世界。你狩猎的是那些与众不同，死后能增值他人财富的人。一旦交易落成，你便化身为交易的代行者。没错吧，我的朋友，一位亡魂收割者，一位预收了报酬的掘墓人。%SPEECH_OFF%你点头，表示理解。突然，一人向你走来，说当地的大人物%employer%有事要说。你回头时，酒保已经走开了。 | 你撞见一个靠在门廊柱上的男人，他叫住了你。%SPEECH_ON%%employer%一直在找你，佣兵。他就在村里的集会所那边。%SPEECH_OFF%那陌生人向着路边稍远处的一座大建筑点了点头。%SPEECH_ON%我希望你能好好表现，佣兵。%townname%的居民对你们这类人持谨慎态度，但这不代表他们的心无法被征服。%SPEECH_OFF% | 一个男人摆弄着他的琴，你从边上走过，他弹出一记刺耳的和弦，转过身去，正见他在笑。%SPEECH_ON%嘿，我就知道这会引起你的注意。%employer%说我们应该留心你……这样职业的人。如果你在找活儿的话，找他准没错。%SPEECH_OFF%你问他，这个大人物是否大方。那男人点点头。%SPEECH_ON%当然。他曾经把这柄鲁特琴作为报酬给我。现在我只等和那些老鬼们比上一曲。%employer%说，如果在弹奏比赛中赢了他们，那他们就会给我一把金鲁特琴。这才是我所说的好报酬，不是么？%SPEECH_OFF%男人转身继续弹奏乐器，从琴弦上拉出一段悲鸣的曲调。远处，狗开始嚎叫起来。 | 当你正在盘点库存时，一个看起来生活条件不错的男人注意到了你，并朝你走来。他自称为%townname%的大人物%employer%工作，而那人想与你见面。你将活儿交给%randombrother%，让那人带路。 | %randombrother%走近你，身边跟着个小跑着的男孩。当他们走到你面前时，这对人同时开口说话，停下，然后再开始。你举起手，然后指向小男孩，他立马说，%employer%想见见你。然后你指向那个兄弟，他说当地的一只母狗生了一窝小狗，也许%companyname%可以领养其中一只。你撅起嘴唇，告诉男孩带你去找他那已经在等着你的主人。}",
		Image = "",
		List = [],
		ShowEmployer = false,
		ShowDifficulty = true,
		Options = [
			{
				Text = "洗耳恭听。",
				function getResult()
				{
					return "Task";
				}

			}
		]
	}
];
gt.Const.Contracts.IntroSettlementFriendly <- [
	{
		ID = "Intro",
		Title = "谈判",
		Text = "[img]gfx/ui/events/event_20.png[/img]{几个乡民走上前来，其中一个甚至伸出手要拥抱你。你婉拒了。%SPEECH_ON%很高兴再次见到你，佣兵。%employer%一直在找你。%SPEECH_OFF% | 你走进镇子，一个女人给了你一朵花。这与平时人们关上门窗藏起孩子的反应大相径庭。你接过花，她摆动着裙摆欢快地离开。一个男人走向你。%SPEECH_ON%打扰了，先生，镇上的居民似乎对您很感兴趣。%employer%也是，自从得到您来到镇上的消息后，他就一直在找您。%SPEECH_OFF% | 一群狗沿路跑来，几个孩子在后追赶。他们一个接一个的从你身边绕开，狗欢快地叫着，孩子们尖叫着问候。一个女人走过来，一手拿着煎锅，一手拿着抹布。%SPEECH_ON%你好，佣兵。本来着应该是信使的事儿，但反正我都知道了，干脆直接告诉你得了。%employer%在找你。%SPEECH_OFF%她眨巴着眼睛。你微笑着点头。%randombrother%笑了起来。%SPEECH_ON%先生，看到你中意的了？%SPEECH_OFF%你让他滚开。 | 几只山羊咩咩叫着，被人领着走在路上。它们拖着脚步走在泥里，用鼻子在泥里翻找，不知怎地就找到了可以吃的东西。他们的牧人把手杖插在土里。%SPEECH_ON%你好，佣兵。%employer%正在找你。%SPEECH_OFF% | 一个男人坐在门廊上，一见到你就探出了身子。他伸出一根手指。%SPEECH_ON%看啊，这不就是大伙嘴里的佣兵嘛。%SPEECH_OFF%你环顾四周，点了点头。他又笑又叫。%SPEECH_ON%我操，看到你真他妈太好了！要是我不告诉你%employer%正在找你，那我可就太不够意思了。去找他吧。告诉他是我告诉你的，或许我能拿到赏钱。那混球，或许就会送束花。要么就是只猫。谁想要猫？干嘛要送我猫？我告诉过他我讨厌猫了……%SPEECH_OFF%当他仍在喋喋不休的时候，你一声不响地离开了。 | 一个女人向你跑来。她还带着孩子，看来对佣兵没有太多戒备心。其中一个小孩抱住了你的腿。%SPEECH_ON%他回来了！%SPEECH_OFF%你低头咧开笑容，试图甩开这小兔崽子，但他以为你这是在哄他玩。母亲抱走了小孩，然后伸手指出了方位。%SPEECH_ON%%employer%在找你。告诉他是我把你叫去的，如果他知道是我帮的忙，没准会来修好我们的井。%SPEECH_OFF%她看起来疲惫极了，孩子们闹腾得她不得安宁。 | 你走进%townname%，一人把你招呼到了他的花园里。他在料理植物，用一只沉稳的手修剪蔬菜或水果之类的东西，不是园丁的你并不能辨识。%SPEECH_ON%过得怎么样，佣兵？如果你在找活，%employer%一直有谈到你。我猜他应该也想见见你，如果你还想继续和他合作的话。给你，接住。%SPEECH_OFF%他转身朝你扔来一颗{卷心菜 | 洋葱 | 土豆 | 西红柿}。%SPEECH_ON%接得好。%SPEECH_OFF%你咬了一大口，点了点头。%SPEECH_ON%味道还不错。%SPEECH_OFF% | 一名年迈的店主朝你挥手。%SPEECH_ON%再见到你真好，佣兵。这话你听过好几十次了吧？%SPEECH_OFF%他伸手指向路。%SPEECH_ON%要是你还想再干点好事，%employer%一直在找你呢。%SPEECH_OFF% | 一个正在剪羊毛的人看着你，那只瘦小的羊正在扭来扭去。%SPEECH_ON%我就该吃了这小畜生。瞧她这德行。别折腾了，好吗？%SPEECH_OFF%他用胳膊肘捅了捅那羊，它发出一声咩叫，用羊所能发挥的智慧咒骂回去。那人又看向你。%SPEECH_ON%你应该就是大伙嘴里的那个佣兵吧。我得跟你说，嗯，我想我会，呃，那个，%employer%一直在找你。%SPEECH_OFF%羊弹跳着想逃跑，但是被那人按倒在地。%SPEECH_ON%小王八蛋，再折腾我就把你的奶给挤干！%SPEECH_OFF%}",
		Image = "",
		List = [],
		ShowEmployer = false,
		ShowDifficulty = true,
		Options = [
			{
				Text = "洗耳恭听。",
				function getResult()
				{
					return "Task";
				}

			}
		]
	}
];
gt.Const.Contracts.IntroSettlementCold <- [
	{
		ID = "Intro",
		Title = "谈判",
		Text = "[img]gfx/ui/events/event_20.png[/img]{当你走进小镇时，一个老人正坐在小屋的门廊上。他一看到你便吐了口唾沫。%SPEECH_ON%敢在这儿抛头露面，你可真有种，佣兵。%SPEECH_OFF%他用袖子擦了擦嘴。%SPEECH_ON%虽然不想承认，但我不会嘴硬说我们用不着你。自便吧，你知道想赚钱该找谁。%employer%还在老地方。%SPEECH_OFF% | 你走进%townname%，一男人冲你大喊。%SPEECH_ON%见鬼，这不是%companyname%和他们的毒蛇头头嘛。%SPEECH_OFF%你挑起眉毛，手握向剑柄。男人笑了起来。%SPEECH_ON%我们不喜欢你，佣兵，但我们确实有求于你。来吧，往这儿出溜，我们好谈正事。这才是你真正关心的，对吧？见见%employer%准没错。%SPEECH_OFF% | 你走进%townname%，镇民一个个躲得远远的。许多百叶窗砰地关上，孩子们安静下来，匆匆离去。一个男人站在路中间，双手叉腰。%SPEECH_ON%哟，是你啊。%SPEECH_OFF%你环顾四周，确保不会有埋伏落到你头上。男人笑了。%SPEECH_ON%我们不是来要你命的，佣兵。我是来撮合交易的，仅此而已。如果你感兴趣，就来找%employer%吧。%SPEECH_OFF%他吐了口唾沫，转身走开了。你又花了一些时间确认没有埋伏。 | 你才一现身，妇女儿童就惊慌跑开了。只留下了几个男人，紧握着草叉或其他贴身武器。一名老者走上前来，上下打量着你。%SPEECH_ON%%employer%找你有事。你知道自己干过什么好事儿，我不知道他为什么还敢找你，但我犯不着从中作梗。%SPEECH_OFF% | 你走进%townname%时，几个衣衫褴褛的民兵正对你侧目而视。其中一人吐了口唾沫大喊。%SPEECH_ON%%employer%找你有事，佣兵。%SPEECH_OFF%他的声音逐渐淡去，似乎在在说什么粗言秽语。 | 一名妇女匆匆赶到路中抱起自己的孩子。她把孩子转了个圈，手紧紧护住小孩后脑勺。%SPEECH_ON%佣兵，我不知道你又来这里干什么，但是%employer%一直在找你。%SPEECH_OFF%她快步跑开，虽然时不时眼睛仍谨慎地瞥向身后。 | 你走在路上，孩子们围在你的脚边转圈。他们的父母尖叫着冲出来，让自家孩子赶紧离你远点。一位母亲拉走自己的女儿，同时用敌视的眼神盯着你。%SPEECH_ON%别想碰我的孩子。如果你想找活的话，就去找%employer%。%SPEECH_OFF% | 一个男人正修理着他家的屋顶，他看到了你。%SPEECH_ON%啊，见鬼，又是你？%SPEECH_OFF%你环顾四周，然后又看向那个人。他笑了。%SPEECH_ON%乡亲们都不喜欢你来这儿。我想我在这件事上是中立的，不过话说回来，站在十尺高的地方，很难不当骑墙派。%SPEECH_OFF%他咧嘴笑了笑，却踩了个空，差点从屋顶上滑下来。他紧紧抓住茅草屋顶。%SPEECH_ON%哇！唔，总之，%employer%在找你。别在意人们的憎恨，他们天生就这样。%SPEECH_OFF% | 人们一看到%companyname%就四处跑开。一个男人在窗户后面大声喊道。%SPEECH_ON%诶，雇佣兵！%employer%一直想见你们呢！%SPEECH_OFF%你还没来得及回应，他就迅速关上了窗户。}",
		Image = "",
		List = [],
		ShowEmployer = false,
		ShowDifficulty = true,
		Options = [
			{
				Text = "让我们一探究竟。",
				function getResult()
				{
					return "Task";
				}

			}
		]
	}
];
