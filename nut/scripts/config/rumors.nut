local gt = this.getroottable();

if (!("Strings" in gt.Const))
{
	gt.Const.Strings <- {};
}

gt.Const.Strings.PayTavernRoundIntro <- [
	"战士们欢呼着你的名字畅饮了起来。",
	"人们举杯向牺牲的战友们致敬。",
	"人们高喊着战团的名字举杯畅饮起来。",
	"人们为美女和她们的温柔乡干杯。",
	"人们为忠诚的战犬干杯。",
	"人们开怀畅饮，欢声笑语和诙谐故事充满了整个酒馆。",
	"艰苦的佣兵生活暂且放到一边，大家分享过去的故事，享受这片刻的欢愉。",
	"“指挥官万岁！”人们喊道。",
	"你的人边喝酒边夸耀着自己的功绩。",
	"烈酒暂时让人忘却了战斗的恐惧。",
	"你的人为财富和长寿干杯。",
	"一杯啤酒下肚，一天的辛劳仿佛烟消云散。"
];
gt.Const.Strings.PayTavernRumorsIntro <- [
	"酒客们一边碰杯，一边高喊着你的名字。酒精让他们口无遮拦。",
	"酒客们赞许地点了点头。",
	"人们举杯表示感谢。",
	"众人低声赞许。",
	"旅店老板摇响了铃铛，让每个人都知道，下轮酒你请了。"
];
gt.Const.Strings.RumorsLocation <- [
	"这儿%direction%边的%terrain%上有个叫%location%的地方。我想大多数人都知道它，但很少有人去那里冒险。",
	"前几天%randomname%跟我提到了一个叫%location%的地儿，他说那儿都是宝藏，就在这儿%direction%边，离这儿%distance%，当然，也可能是我记错了。",
	"如果你想来点冒险，有个叫%location%的地方，就在%direction%边的%Terrain%上。就是不清楚现在谁住在那儿了。",
	"听说%location%了吗？人们说那地方正在闹鬼，遍地都是行走的死人。就在这儿%direction%边。估计%townname%的人更清楚那儿的情况……",
	"你知道……天哪，叫什么来着？就在这%direction%边%distance%处的%Terrain%上。我怎么就想不起来那儿叫什么了呢......",
	"来的时候路过%location%了吗？你问我为什么这么说？那地方就在%direction%边的%terrain%上。会有人雇你把它烧成灰的。我敢肯定，那儿可没有好东西。",
	"我们在来这里的路上发现了一些隐藏在路上的东西，就在 %townname% 的 %terrain% %distance% %direction% 附近。或许当地人会知道怎样称呼它，那里真值得去瞧瞧。"
];
gt.Const.Strings.RumorsContract <- [
	"我听说 %settlement% 的议会正在招聘雇佣兵, 只是不知道是为了何事。",
	"几天前，一群年轻小伙子去了%settlement%。那儿的人愿意花大价钱，专门雇佣武装人员。但愿他们能活着回来吧。",
	"如果你们正在找工作，我听说他们正在 %settlement% 招聘佣兵。",
	"听说了吗？有人在%settlement%招募战士呢。",
	"%settlement% 的某个人前几天来过这里，想聘请强壮的小伙子来解决他们在那里遇到的问题。不过我想没多少人会跟他们走的。",
	"雇佣兵，嗯？这些天我们得到了一些。就在几天前，一群自称 %randommercenarycompany% 的队伍打这经过，往 %settlement% 的方向去了，他们说在那能弄到更多的硬币",
	"如果你是要找工作，%settlement%正准备了一笔钱，打算找点勇士呢。",
	"前几天听说 %settlement% 的一些花哨的胖商人正在寻找雇佣武装警卫。好吧，我才不会为了那些人送命呢，我的老婆和房子都在这呢。"
];
gt.Const.Strings.RumorsGeneral <- [
	"朋友，你要是想把货卖个好价钱，就得奔着大城市或者城堡去，到那些鸟不拉屎的破村子去干什么。",
	"%randomtown%的酒比这儿的猫尿好喝多了！",
	"今天早上来了个商人，声称在这附近的山上看到过僵尸。我才不信那死骗子呢！",
	"世界上有许多长期以来被人遗忘的地方，却蕴藏着巨大的财富。",
	"如果有机会去%randomtown%的酒馆，你一定要尝尝那里的烤全羊，别的地方可吃不上这种好东西！",
	"雇佣兵在这一带是不受欢迎的。他们就像普通强盗一样杀戮、抢掠和抢劫，所以你就别妄想会有欢呼与鲜花了。",
	"如果你需要补给品，去 %townname% 的市场找 %randomname%。告诉他是我让你来的！",
	"明晚著名的 {音乐鸟 | 吟游诗人 | 故事家 | 夜莺 | 诗人} %randomname% 要来这家小酒馆，你最好不要错过！",
	"千万别喝理发师的药！我表哥的朋友的叔叔的朋友就是喝了这么一瓶药水才变成癞蛤蟆的，我发誓！",
	"我听说一支叫做 %randommercenarycompany% 的自由佣军喜欢收集敌人的耳朵并且戴在脖子上！",
	"我告诉你，千万别喝 %randomtown% 的水，那里的水喝了立马就会拉肚子！",
	"我堂兄%randomname%也是个雇佣兵，跟着一支叫%randommercenarycompany%的佣兵团离开了镇子。不过自打他走后，我就再也没有听到过他的消息……",
	"前人的经验：如果你珍惜你的雇佣兵声誉，你最好不要欺骗雇主。不然他们会不遗余力的追捕你，说你坏话让你付出代价。",
	"那些贵族家族就像一对老夫妇；不断的吵架和争吵。要说谁受害最深？怎么可能是那些高居城堡的贵族，当然是咱们这些老百姓！",
	"我才不会靠近那些沼泽和湿地。可怕的恶疾就在那儿等着你呢。",
	"我听说 %randomtown% 的议会中有一名真正的巫士，我也不确定是不是真的。",
	"我喜欢女人，无论是她们的样貌还是谈吐。难以想象没有她们的世界我该怎么办…",
	"这是你和 %companyname%！还记得我吗？我们在 %randomtown% 讨论过...好吧，我也不太记得讨论过什么了，但我们确实见过！来，喝一杯！你们最近怎么样？",
	"死亡是生命的一部分。你越早接受它，就越懂得珍惜当下。",
	"前几天我掉了颗牙齿，你看到没？我觉得其他的牙齿也松了，快要掉了。你看出来的吗？来，摸一下，是不是松了？",
	"神啊，我想去尿尿，你能帮我看着这杯啤酒吗？"
];
gt.Const.Strings.RumorsCivilian <- [
	"朋友，对贵族总是要留个心眼。你永远都不会知道他们到底想干什么。",
	"有没有想过放下武器安定下来呢？雇佣兵生涯往往都是短暂的。",
	"几天前，有人看到老%randomname%的农田被夷成了平地。他们全家都被吊死在了附近的橡树上……",
	"自从某些强盗烧了我家老头的农场我就把干草叉换成啤酒杯了。那些人早晚会有报应的。",
	"我们的民兵真可怜，总拿着生锈的长矛和虫蛀的盾牌。我希望议会能给那些可怜虫买点真正的装备吧。",
	"我们这里不需要佣兵！你们只会带来麻烦。咱们的民兵就一直很好地保护着我们。",
	"昨晚碾磨工的女儿失踪了。人们找到她时却没啥事，但她什么都不肯说。",
	"靠，%randomname% 和他的狗。不论晴雨，昼夜不停地吠叫。我再也受不了了，我真的不能……",
	"我听说老坟场的一些墓碑已经倒了。但无论如何头脑正常的人都不会去那。",
	"前几天我从一名路过的商人手上买了这把撒克逊大刀。这真的便宜，他说男人就该懂得保护自己和家人，明白不。",
	"我才不信这儿的民兵呢。有一次，一伙亡命之徒才刚露了个脸，他们打都没打上一下，掉头就往山上跑了！",
	"我们这里有个杀人犯。一个来自 %randomtown% 的狗杂种用刀子刺进了一名商人的后背。那家伙在星期天会被处以绞刑，你应当也来看看的！",
	"上星期一名叫做 %randomfemalename% 的女人被女巫猎人烧死了。那人只来了一天就指出女巫的罪名然后烧死了她。议会那边也没反对，那名女巫猎人很快就走了。我很想知道他是谁。真庆幸他把我们从女巫手中救了出来，我猜想..."
];
gt.Const.Strings.RumorsMilitary <- [
	"跟兽人交过手吗？据说它们有两人高并且比人类强壮三倍，随手一击就能把人劈开两半！",
	"为你的战团招募啥也不懂的农夫和渔夫是件好事，但你应该在这样的城堡里寻找新兵。在这里，你发现那些真正知道剑的哪一头该指向哪里的人。",
	"我可跟你说啊，结实的盾牌能救命。我肯定得给所有人都整一个。",
	"一名经历过无数战斗的驻军指挥官声称只要耸肩就能用战斧砍中兽人的头部，也不知道他是怎么做到的，管他呢。",
	"外面的世界比强盗更可怕呢。如果你走出边境你很快就会明白我的意思了。",
	"我总是依赖我的斧头来粉碎敌人的盾牌。一旦没了防护，即使最高大的战士也会很快倒下。",
	"要问我在当兵时学到了什么，那就是高地赢得战斗。相信我一次。",
	"我曾经也是一名雇佣兵，直到我的膝盖中了一箭。",
	"最近我看了一场%randomnoble%的巡回赛。天啊，多好啊，他……我是说他比赛的样子。拿到了大奖，所有的女人都在为他疯狂。",
	"我现在老了，但我还记得我的第一场战斗。在第一根箭射出去之前我就尿裤子了，哈哈！",
	"不久之前去了 %randomtown%，那里的人告诉我有一种狼像人一样高大，牙齿像我的手指那么粗。真不想遇见它们。",
	"你知道兽人喜欢剥掉它们击败的敌人身上的东西来做盔甲吗？说真的，我不是在吹水。它们喜欢穿着这些战利品。如果你有机会遇到它们就会明白了。它们看起来就像一两个骑士的合体一样。",
	"我当兵时候，数%townname%第一团这帮混球最好。我说什么也不会出卖他们。",
	"我很想念我的妻子与两个女儿。在 %townname% 驻扎很久了，但作为男人总得为她们的桌子摆上食物啊。",
	"我们很快就要出去巡逻了。有时候我觉得如果不是我们一直守卫着的话，这里早完蛋了。",
	"去他妈的巡逻。我们才刚回来，脚上还起了水泡，现在又要出去了。就该给我们整匹马骑骑！",
	"我数月前与地精的战斗中受了重伤。再也感觉不到我的腿了，但小伙子们硬是扛着我跑回了 %townname%。愿上帝保佑他们。",
	"一看到那些用头颅和长骨立起来的造像，你就知道到了绿皮的领地。用的正是人类的骨头。",
	"十四个。我一共杀了十四个人，男人。女人另算，一共三个。你呢",
	"我经常在岗哨楼站岗。说实在的，向过路的旅客吐唾沫是我一整天唯一的乐趣了。",
	"守卫军的情绪已经很糟糕了。他们说工资已经延迟发放好几次了，现在他们都开始失去耐心了。",
	"我搬到%townname%来的时候没想到生活会如此枯燥与艰苦。但我想这也总比在田里累的直不起腰来要好......",
	"我更喜欢在战斗中使用链枷。即使敌人带着盾牌也很难抵御，我只要挥舞一下链枷就能让他们的脑袋开花！",
	"想找块结实盾牌是真他娘的难，破玩意说成两半就成两半。搞得我总得背上一块备用的。谁要是雇我去对付拿斧子的人，我准要多管他要点钱，哼！",
	"总有一天，我要成为战团的掌旗手。只有那些最勇敢，在战团里待得最久的人才配干这个，对普通人来说，这是再大不过的荣誉了。我甚至亲眼见到骑士和我们的旗手握手了呢。",
	"我曾经训练过民兵，让我告诉你吧，当你的人还不清楚自己在干什么的时候，矛就是最好的武器。又便宜又好打中。要是让几个人组成矛墙，想靠近免不了肚子上挨一下。",
	"和地精打过没？这帮阴险的小杂种，可别让它们的小个子给唬住了。我会带上一面筝形盾，好挡住它们的箭。有钱的话最好再准备上战犬，免得他们四散开去到处射击。"
];
gt.Const.Strings.RumorsMiningSettlement <- [
	"有一天，我的鹤嘴锄敲坏了。飞出来的碎片崩到了我脸上。好在只是没了只眼睛！",
	"矿山就像个死亡陷阱，我们这每星期都有人挂掉。我觉得跟着你冒险还可能更长命点呢，哈哈！",
	"你知道的，挖矿这行其实也有优点。下雨从来都淋不着我们，只不过是吸点尘土折点寿罢了。",
	"另一座矿井里，%randomname%找到了一块金块，足足有拳头那么大！不过还没来得及藏起来，就被工头没收了。"
];
gt.Const.Strings.RumorsFarmingSettlement <- [
	"即使今年收成不好，地主们也不让我们休息！你要知道，那些贵族还要举办盛宴呢...",
	"如果你想囤点食物，那就去市场找%randomname%啊。他那儿的东西又便宜又实惠。",
	"我当了一辈子农民，有时候，真希望当时抓住了机会，加入像你们一样的战团，四处去冒险……唉，现在说这些都晚了。",
	"有太多无知的年轻人梦想着去冒险。我希望你能照顾好他们，并且有天能把他们安全带回家。"
];
gt.Const.Strings.RumorsFishingSettlement <- [
	"大海就像一名喜怒无常的怨妇。前一秒还平静地像镜子一样，后一秒你就发觉自己在暴风雨中拼命了。",
	"没有人知道漆黑的深水里生活着什么，但是老渔民们总是会提起比船还大的巨鱼，砸船就像砸核桃的触手，还有水面下冰冷的邪恶之眼。",
	"一些老渔民会告诉你，那些在海上失踪的人被诅咒只能在海床上行走，只有当他们把其他人拖下去接替他们的位置时才会被释放。牧师说这不是真的，但我不知道为什么长辈们要这么说？",
	"我总会把我抓来最大的鱼放在%randomfemalename%的门前，作为追求她的礼物。总有一天，我会揭开我神秘追求者的身份，直接向她求婚！"
];
gt.Const.Strings.RumorsForestSettlement <- [
	"我做了一辈子伐木工，就像我的父亲一样。但是现在的年轻人都喜欢冒险，喜欢四处看看，你很可能会在市场周围发现一些到处闲逛的人，他们会毫不犹豫地和你一起上路。",
	"森林最深处存在着某种生物…不过没人敢与之对话，它们可能不是普通的动物......",
	"我说，你对木雕感兴趣吗？%randomname% 的作品就像真正的艺术一样闻名全国！",
	"要我说，干你们佣兵这行的，雇个伐木工准没错。他们最懂怎么把大斧子舞起来了。",
	"我一直听到人们说有只眼睛在森林的边缘看着他们。好像是一些卑鄙的生物在树林里筑巢。也许是它们在攻击前估量猎物的大小。",
	"从我记事起，这附近的树林里到处都是野生动物。大量的鹿、野猪、狼和熊在森林中游荡。正因为如此，家庭从小就有教授箭术的传统。你可以尝试着和我们这的年轻人比试一下箭术，你能体会到什么叫耻辱。"
];
gt.Const.Strings.RumorsTundraSettlement <- [
	"你可能认为我们的土地即荒凉又贫瘠，但只要住上一住，你肯定会爱上它！",
	"这地区的贵族和家庭依然十分强大，并决定着我们的命运。那些南方的娘娘腔永远也不会明白北方的彪悍是怎么一回事。",
	"如果你想通过贸易来快速的赚一些硬币，那就去收集兽皮吧。这里附近的兽皮是最好的。",
	"如果你在寻找有能力的人来充实你的战团，那你来对地方了。我们北方的男儿既强壮坚韧又诚实！"
];
gt.Const.Strings.RumorsSnowSettlement <- [
	"抵御刺骨寒风和严寒的最佳良药就在这里：啤酒和蜂蜜酒！",
	"两周前，%randomname% 从酒馆回家的路上失踪了。第二天早上发现他冻得像块石头一样。可以把他当作雕像卖给那些贵族收藏家了，哈哈！",
	"有人说，暴风雪中有人影在若隐若现，也有人说，神秘的嚎叫会随风而至……希望你听了以后不要害怕。",
	"很久以前，有人告诉我，这片土地是绿色的，有许多令人自豪的城堡和令人敬畏的岗哨塔。可到了如今，大部分都已经被夷为平地了，到处都是雪。但他们一定还在某个地方...",
	"四年了。四年前我看到了一个快速赚硬币的机会，袭击了路边的一个小教堂。把烙铁插进了一个试图阻止我的圣人身上；现在，再多的克朗也无法偿还我精神上所欠的债。"
];
gt.Const.Strings.RumorsSteppeSettlement <- [
	"你的人穿着那些盔甲一定汗流浃背了吧。也许你应该在月亮出来的时候再出发？",
	"我告诉你，南方的葡萄酒是世界上最好的。但是你最好在用酒瓶砸别人脑袋前考虑清楚，因为它不便宜。",
	"前几个星期，一个北方的商人在大草原上迷了路。他回来后，经常胡思乱想，他说发现一些湖泊周围都是郁郁葱葱的植物和奇怪的动物。",
	"告诉你的人别打酒馆老板女儿的主意。上一个求爱者的鼻子都被削掉了。",
	"我原来是北方人，几年前刚搬到 %townname%。因为无法忍受寒冷；没完没了的风雪。所以有一天，我对自己说，%randomname%，去有太阳又温暖的地方吧，你就不用每次出去收集柴火时都瑟瑟发抖了。我就这样做了。至此我也没后悔过。"
];
gt.Const.Strings.RumorsSwampSettlement <- [
	"你喜欢吃蘑菇？哼，我肯定是讨厌极了！可这片烂沼泽里再也找不到别的吃的了，我总不能去吃小咬和蜘蛛吧。",
	"商人不常往这里来。他们的马车老是往泥里陷，你猜谁有本事救他们出来……",
	"这地方曾经有一条石板路，商人，游客，各色人等络绎不绝。直到有一天，这条路彻底陷到沼泽里去了，看看这个破地方……",
	"晚上不要在沼泽附近闲逛！你会迷路的，真的。但在沼泽中还有更恐怖的事情呢。你问一下周围的人就知道了。"
];
gt.Const.Strings.RumorsDesertSettlement <- [
	"那些北方人为我们的丝绸和香料花了大价钱，商队的往来也越来越频繁。而商队总是要有人保护，你懂的。",
	"如果我能给你一条建议，那就是：不要在沙漠里探索的太远。世界边缘有比热和沙更糟的事情。",
	"那些北方的狗无权进入我们的土地，他们应该呆在属于他们的地方！"
];
gt.Const.Strings.RumorsItemsOrcs <- [
	[
		"一辆运送仪仗武器的马车，在这儿%direction%边被劫了。听说那些押车的倒霉蛋，一个个骨头被砸得粉碎，臭味隔了老远都能闻到。",
		"最近有一名顾客说他有一件叫做 %item% 的武器想出售。他说来这里的路上被绿皮兽吓了一跳并丢失在这里的 %terrain% %direction%。",
		"前几天有个旅行者告诉我，他亲眼看见一个巨大的人挥舞着一把叫做 %item% 的东西。听起来像废话，但如果你感兴趣的话你可以从这去往 %direction%。"
	],
	[
		"几天前的一个晚上，一个趾高气昂的英俊冒险者来过这里。他往%direction%去了，说是要去猎杀绿皮。他背着一面骑士样儿地盾牌，却说自己并不是骑士。",
		"他们说有一种著名的盾牌，我忘了叫什么了，曾经阻挡了一块从山上砸向营地的大圆石。这听起来这恶心，并不是说我们会知道它现在是不是兽人的战利品，藏在离%distance% %direction% 的某处。",
		"我就这么一说，你就这么一听，听说一群绿色的傻大个正带着一件叫%item%的著名盾牌在%direction%边瞎逛呢。真不知道它们怎么搞到的。",
		"几天前，有个贵族的庄园让绿皮给抢了。抢走了一些著名盾牌和遗物。据说这帮绿皮混蛋跑到%direction%边打洞去了。"
	],
	[
		"熟悉兽人？它们就是强壮如牛的野兽！数周前一支名叫 %randommercenarycompany% 的雇佣兵团朝着 %direction% 狩猎它们去了。然后一去不复返了，不过他们的队长穿着一件令人印象深刻的盔甲！",
		"对了，你听说过%item%吗？据说在数世纪前的兽人入侵时期被偷了。有人说在%direction%边见过它，但是我可不了解具体是什么情况。我希望你不要太抱希望了。",
		"几天前好几个著名的盔甲师被杀了。据说兽人洗劫了他的住所并带走了他的杰作，跑向这里的 %direction% 去了。可能其他人能告诉你更多情况。",
		"带有 %randomnoble% 字样的盔甲被一群绿皮永眠在这里 %direction% 的某处。他虐待仆人是出了名的，所以你在这里是找不到任何人为他哭泣的。对于他曾经吹嘘的精心制作的盔甲来说，这简直是一种耻辱，那件盔甲能买许多猪和牛呢。还有数不尽的鸡！"
	]
];
gt.Const.Strings.RumorsItemsGoblins <- [
	[
		"有一天一位非常生气的贵族跟我说有些矮小的绿皮毒死了他家的看门狗后偷走了他的传家宝。他发誓他们肯定藏在离这里 %distance% 的 %terrain% 附近，但我不认为他说服过任何人帮他找回它。至少肯定不会是我。",
		"害怕绿皮吗？几天前一群久经沙场的士兵来过这里。据说他们想从这里 %direction% 的地精那里争取一件著名的武器，但看起来他们的计划确实没有奏效而不得不撤回来。看来他们的战利品还没到手。"
	],
	[
		"一位%direction%边来的农夫告诉我，他在地里看到了一些又矮又阴险的生物，拿着一件巨大的闪亮盾牌，还不时发出一些邪恶的声音。他说那些是地精，要我说，他肯定是被一群小孩儿给耍了！",
		"他们发现这里 %direction% 最好的制盾匠死了，脖子被一根标枪给刺穿。人们还说一些矮小的生物偷走了他一半的货物。",
		"这的%direction%边住着一群地精。我能知道这事完全是因为那些吊儿郎当的主总会谈起他们是怎么逃出生天的。甚至还有人说他跑路的时候丢了一面精制盾牌呢。"
	],
	[
		"有传言说一些价值连城盔甲被一群邪恶的生物从警卫室偷到 %direction% 去了。%randomname%  说一定是地精，但没人真正看清那些家伙是啥模样的。",
		"有传言说狗头人和地精对所有闪闪发光的东西都有特别的兴趣。我自己并不相信这种说法，但是我多次在%terrain%%direction%处看到阳光下闪闪发光的东西，并听说矮小而粗壮的生物漫游在那个区域。",
		"你可能有兴趣知道昨晚我们镇外的老药剂师被抢劫了，还是在一个富有的骑士拜访他的前提下。他的助手声称一个看起来像畸形小孩的矮小生物杀了骑士，并逃去了 %direction% 的 %terrain%。"
	]
];
gt.Const.Strings.RumorsItemsBandits <- [
	[
		"有消息说一群不知哪来的强盗在这里的 %direction% 通过一次鲁莽的抢劫得到了一件神奇又锋利的武器。",
		"一群贱民企图在 %distance% 的 %terrain% 掠夺一个商队。然后他们都被杀死了，但有传言说有一件价值连城的武器在那次战斗中遗失了。那个商队护卫从那以后发了疯似的到处寻找。",
		"一位糊涂的顾客告诉我他曾经被一群流氓囚禁在 %distance% %terrain%。他说那帮人有一件外形奇怪的武器。",
		"前段时间开小差的那个卫队队长，跑到%direction%边的%Terrain%当土匪去了。我舅舅当时当过他的兵，说他从军械库里带走了一件顶好的装备。"
	],
	[
		"前段时间开小差的那个卫队队长，跑到%direction%边的%Terrain%当土匪去了。我舅舅当时当过他的兵，说他从军械库里带走了一件顶好的装备。",
		"我听说，有人亲眼见到了那面叫%item%的著名盾牌。%randomname%信誓旦旦地说，这玩意现在就在一群彪悍的强盗手里，他们还在%direction%边扎营了呢。不过，%randomname%也吹了不少他一点也不懂的牛。",
		"所有人都在“抱怨”这一带都是该死的掠袭者。“猜想他们是谣言制造者”是因为他们得到了一些类似 %item%  的珍宝才那么猖獗吧。你问我在哪？噢，或许是在 %terrain%。"
	],
	[
		"我的一个朋友的朋友前些天在这里的 %direction% 被一群不法之徒抢劫了。他宣称那个强盗头目穿了一件令人震惊的盔甲！",
		"前段时间开小差的那个卫队队长，跑到%direction%边的%Terrain%当土匪去了。我舅舅当时当过他的兵，说他从军械库里带走了一件顶好的装备。",
		"几天前有一名傲慢的年轻人来过这，估计是个什么贵族，要找一件名叫%item%的老传家宝。我看他最后往%direction%边去了。"
	]
];
gt.Const.Strings.RumorsItemsUndead <- [
	[
		"听好了，我可不是在编故事，我亲眼看到了一只僵尸往%direction%边去了。他那烂手里还攥着一把精美异常的武器呢，可惜我这辈子再也没胆儿去那儿看看了。",
		"昨晚来了好几个醉醺醺的流浪者，告诉我们他曾经在这里 %direction% %distance% 碰到了一只僵尸，想从僵尸手里夺取一把镶着宝石的武器。那头僵尸吼了一下他就吓跑了。他好像被吓的胡言乱语了。",
		"这里流传着许多僵尸重现大陆的传言。甚至%randomname%还说，这儿%direction%边就有一些僵尸。我看这完全是胡说八道。"
	],
	[
		"这里的 %direction% 有许多坟墓可能都被挖空了。有人说盗墓贼在寻找一面埋藏在那里的著名的盾牌。奇怪的是没人确切的见过那些盗墓贼，可能只是谣言吧。",
		"我在翻看管家的书籍时偶然发现了一张陈旧的地图，上面描述了一个古老的贵族的埋骨之地就在 %distance% %terrain%。可惜的是没人能找到那墓穴。好吧，我猜想有些东西是注定找不到的。"
	],
	[
		"可能有一件神秘盔甲永眠在 %direction% 的 %terrain% 。我也不知道那件盔甲叫什么，我只知道很多冒险者去了那里就再也没回来过。我不知道为啥要告诉你这些，但我真的喜欢你的行业。",
		"你听说过%location%吗？你到处打听打听，从我出生起%townname%就深受其害。人们都说，人类在这儿定居之前，就有一件诸神的盔甲被封印在那儿了。"
	]
];
gt.Const.Strings.RumorsItemsBarbarians <- [
	[
		"对那些野蛮人来说，没有什么是神圣的！一个全裸的牧师从 %direction% 跌跌撞撞地来到这里。他正要把一件受人尊敬的遗物带到神殿里，但他们把它拿走了。",
		"一个佣兵战团来这里猎杀野蛮人。首领挥舞着一把我从未见过的武器。他们转向 %direction% 就从此消失无踪了。",
		"当你驶出 %direction% 的 %terrain% 时，注意观察一群凶猛的野人。他们可能会把你带到他们的藏匿处，据说在那里发现了一件著名的被盗武器。"
	],
	[
		"听我说！一个未受教育的野蛮人部落在这里的 %direction% 被看到，他们的脏手拿着一个名为 %item% 的盾牌！杀了他们，把它拿回来！",
		"一个朋友的朋友在这里的 %direction% 发现了一些野人。他发誓他们带着一个精巧的盾牌。我叫马屎，因为每个人都知道他们不像我们那样使用盾牌！",
		"他们说，只有良好的防守才给予有力的进攻。有传言说，一群野蛮人在 %direction% 的 %distance% 拥有一个著名的盾牌……",
		"我曾经和%direction%边一些不那么野蛮的野蛮人做过买卖。上次去的时候，他们的一间小屋里还挂着一面华丽的盾牌呢。他们可能还在那边的%terrain%上。"
	],
	[
		"你看起来需要更好的盔甲，我的朋友。如果你不害怕与凶猛的野蛮人作战，在他们那里有一个强大的精美盔甲，那个营地叫做 %location%，就在 %direction% 的 %terrain%。",
		"著名的 %item% 在军械库中被守卫了几十年，但是当北方的野人来的时候，他们带走了所有的东西。据说他们某处露营的地方在 %terrain% %distance% 离这里。",
		"我来这里，是为了找回我已故祖父的一件传家宝，谁承想，它已经被四处劫掠的野蛮人抢走了。听说，他们就游荡在%direction%边的%Terrain%上，恐怕我再也别想把它给找回来了。",
		"你也是来找 %item% 的吗？据说它在 %direction% 的 %terrain%。如果你要我说的话，除了废话..."
	]
];
gt.Const.Strings.RumorsItemsNomads <- [
	[
		"游牧民抢走了他们想要的东西，躲进了沙漠里。卫兵曾经到%direction%边的%Terrain%上找过他们。我估计就在%distance%处。",
		"南方白天有多亮，到了晚上就有多黑。我肯定是跌跌撞撞间把我的宝贝武器弄丢了，丢在了%direction%边%distance%处的某个地方，估计我是找不到它了。",
		"古代的工匠们真的知道如何制造非凡的武器。有传言说这样的武器被一个游牧部落藏在 %direction%，但谁应该从他们那里拿走－我？哈！"
	],
	[
		"一块像镜子一样反射阳光的盾牌，比在沙漠中正午的时候还要刺眼！我在哪里看到的？如果我没记错的话，那些游牧民在这里 %direction% 的 %distance%",
		"我一生都在%terrain%边境追捕游牧民族，但我从未见过像这个人一样拿着盾牌。他在他们营地的%direction%方向，距离%distance%。",
		"游牧民不仅从活着的人身上拿东西，也从死去的人身上拿！有消息说他们从在这里 %direction% 的一个坟墓里抢掠了所谓的 %item%，那里还有他们的营地。他们真的一点也不体面。"
	],
	[
		"我曾经是维齐尔的第一军需官。当我为一位贵宾订购的著名的盔甲没有到达时，我失去了我的官职。我后来得知，随行的商队在这里的 %direction% 遭到游牧民的伏击。",
		"据说在这里往%direction% %terrain%，有一套华丽的盔甲被隐藏了起来。迄今为止，很多寻宝者都没能找到它，但也许你会更有运气？",
		"最熟练的盔甲师，碰巧是我的一个朋友，被那些该死的游牧民骗了，他们带走了他的一件珍贵的盔甲。如果你在这里的 %direction% 遇到任何游牧民，彻底搜查他们的尸体！"
	]
];
gt.Const.Strings.RumorsGreaterEvil <- [
	[],
	[
		"贵族们又吵起来了，就像菜园里的两个老太婆。依我说，他们就是拉不下那张脸！",
		"贵族们会拿走你所有的克朗，还有你的儿子和丈夫，他们会葬送在他们毫无意义的斗争之火中－会受到上千次的诅咒！",
		"二十年前我在军队服役。失去了一只耳朵，看到了吗？现在我的孩子在行军。从马厩里被抓出来，被迫进入前线。不同的战争，操蛋的老一套。我祈祷他保持低姿态，举起盾牌。"
	],
	[
		"绿色的潮水冲走了一支又一支的军队！我们都要完蛋了！完蛋了！",
		"所有人都在逃离绿皮，但我不会！我会坚守阵地，一手拿棍棒，一手拿瓦罐！送他们上路！",
		"上一次在许多名人之战中，我们几乎没有撞退绿皮，只是勉强成功，现在他们又回来了。",
		"我们每天都听到越来越多的农场和村庄被烧毁的故事。是绿皮在掠夺乡村。"
	],
	[
		"愿老天保佑我们！死者在各地的坟墓里翻腾。他们会来索命生者。忏悔，忏悔和祈祷！",
		"贵族们在处于守势，没有人知道如何阻止对我们造成威胁的亡灵。我得把我的注意力从它身上移开－掌柜的！再来一杯！",
		"也许我应该上吊自杀，结束这一切，加入行军死者的行列。这种等待快把我逼疯了！",
		"一名男子被发现死在路上。他笔直地坐在一辆驴车上，全身干涸，就像一个由皮、卷须和骨头组成的木偶。驴也是。就好像他们的血被吸了一样。",
		"可怕的鬼魂，空荡的坟墓，来自异世界的愚昧奴隶！\n来杯酒，找个女人，在你的牙齿咬紧之前！\n喝掉这杯，不要干渴，只有三天时间直到我们死去！",
		"%randomnoble%的午饭复活了！他正要美美地来上一口，只见那只催肥鹅一跃而起，扑腾着翅膀绕起圈来。把烤苹果撒得满客厅都是。那场面肯定是难忘极了。"
	],
	[
		"你听到消息了吗？军队在 %randomtown% 集结向南进军。我只希望镀金者有一天不要反击....",
		"如果你在找硬币，你应该往南走，给那些太阳崇拜者上一课！",
		"什么…什么！？我听不见你说话！我在神谕所和那些镀金者的追随者战斗，我耳边响起了响亮的声音……",
		"想喝点汤吗？我放了牛肉和土豆在里面。不过，没有香料。它们因为战争都用断货了。",
		"牧师说如果你不能从十字军远征中回来，旧神会接纳你。知道是件好事，对吧？那些镀金狂热分子很危险。",
		"你敢信？%randomnoble%雇了一群游牧民，让他们带着他的军队，穿过这片沙漠。这要是真的，那他可太蠢了，我才不会相信那些蛇，除非我也会嘶嘶嘶地吐信子。",
		"我的一个侄子在沙漠中被杀了。可怜的小伙子。为了去保卫信仰，被一支长矛刺穿了。做这事的混蛋还活着。让他们为此付出代价，我说。让这群受三倍诅咒的人付出代价！"
	]
];
