local gt = this.getroottable();
gt.Const.TipOfTheDay <- [
	"我们像兄弟一样战斗，同生共死！",
	"盾牌可以用斧头和一些双手武器摧毁。",
	"不同类型的盾牌更适合对抗近战或远程攻击。",
	"盾牌每次用于抵挡攻击时都会受到轻微的损伤。",
	"灌木林可以隐藏角色，以防从远处被发现。",
	"一个比对手高的角色更难被击中。",
	"站得越高，看的越远。",
	"在你的队伍里有不同背景的人可能会让你在事件中采取不同的行动。",
	"从多方面包围对手可以更容易地击中。",
	"考虑将受伤的角色放到预备队直到伤口愈合为止。",
	"考虑建立一个预备队，轮换队员，这样你可以更容易地处理路上的损失。",
	"远程武器的精度随着距离下降。",
	"你不必成为英雄，你在维持生计。",
	"不同的背景可能会在处理事件和合同时解锁额外的选项。",
	"在队列中，将你的人员拖放到你希望他们在你的队形中的位置。",
	"偏斜的远程攻击可以击中附近的角色，特别是当他们在射击线中时。",
	"在近战中不能射击，也不能重新装载弩矢。",
	"弓在对付无甲目标时表现更好。",
	"匕首可以用来攻击盔甲中的弱点，并直接对生命值造成伤害。",
	"远程武器在向敌群开火时效果最好，他们一定会击中某人。",
	"当被包围时，考虑形成盾墙。",
	"在长时间的交战中要保持体力。",
	"战场兄弟的成功也在于选择正确的战斗。",
	"亡灵不受疲劳值和士气的影响。",
	"弩比弓箭需要更少的技能来精确射击，但使用速度更慢。",
	"每种武器都有优缺点。",
	"一些困难的地形，如沼泽地，会给战斗带来惩罚。",
	"你可以使用 + 和 - 键更改相机高度级别。",
	"棍和棒可以击昏或使目标丧失能力。",
	"当事情变糟时，试着存留一些克朗。",
	"长剑和大剑可以一次击中多个目标。",
	"你可以使用鼠标滚轮或上下翻页键进行放大和缩小。",
	"长矛是很好的防御武器，因为它们可以使用矛墙。",
	"准备好失去队员。",
	"失败也是有趣的。",
	"使用地形和阻塞点对您有利。",
	"级别越高，你的人要求的工资就越多。",
	"在富裕的大城市销售，你的商品将获得更多的克朗。",
	"使用投掷网来限制特别危险的敌人的移动。",
	"利用交易来补充你的收入。",
	"学习“换位”或“步法”在战斗中增加额外的机动性。",
	"夜间视野范围缩小，无论是在战斗中还是在世界地图上。",
	"骷髅对远程攻击有很高的抵抗力。",
	"重型盔甲提供了很好的保护，但也降低了佩戴者的速度，使他更容易疲劳。",
	"重型头盔会让人呼吸困难，还限制了视野。",
	"战锤和军用镐能迅速破坏重型盔甲。",
	"与大多数其他近战武器不同，钩镰枪、长枪和长斧可以攻击2格距离。",
	"链枷忽视盾牌的防御加成。",
	"不同类型的敌人需要不同的战术来可靠的击败。",
	"游戏中的每个敌人都可以用正确的方法可靠的击败。",
	"人类在身体上无法与成年兽人匹敌。",
	"兽人依靠蛮力和体力。",
	"地精在身体上无法与成年人类相匹敌，所以他们靠的是机智和肮脏的把戏。",
	"兽人狂暴者失去更多的血就会更愤怒，并且变得更难被击倒。",
	"幽灵在物质世界和超越世界之间消失了，在两者之间不断变化。",
	"幽灵考验你的人的决心－越低，他们越有可能恐慌和逃跑。",
	"双手斧可以一次同时击中头部和身体。",
	"双手斧在一次旋转攻击中可以击中最多6个目标。",
	"道路是陆地上最快的旅行方式，但并不总是最安全的。",
	"在森林里可能隐藏着许多危险。",
	"一定要储备好粮食，以免你的人挨饿，抛弃你！",
	"僵尸死亡后会再次复苏。",
	"困难的地形，如高山和沼泽，会让你的人在世界地图上使用更多的补给。",
	"如果你赢不了，那就撤退改日再打。",
	"撤退。逃走。不要每场战斗都打得死去活来。",
	"使用空格键在世界地图上暂停。",
	"像小山和山脉这样高的地势，可以让你在世界地图上看得更远。",
	"并非每一份合同都值得冒险。",
	"试着为你的合同协商更好的报酬。",
	"试着协商报酬形式，以保证你在合同中得到更多的钱。",
	"不是每一场战斗都能胜利。",
	"在这个世界上，一个生命的价值可能微乎其微。",
	"从长远来看，背叛你的雇主可能会产生影响。",
	"世界上有些地方比其他地方更危险。",
	"利用港口快速环游世界。",
	"有些人会在利用你之后把你抛弃掉。",
	"投掷武器在短距离内是致命的，但其精度在离目标越远的地方会急剧下降。",
	"才华横溢的人可以来自各种背景。",
	"尝试用铁人模式体验战场兄弟的游戏方式。",
	"远程武器在夜间不太准确，包括你的敌人。",
	"扎营让你的人更快的恢复和修理他们的装备。",
	"使用 ALT + 鼠标右键 单击可以让在铁匠处付费修理你的物品。",
	"您可以使用 ALT + 鼠标右键单击以标记要在仓库中修理的物品。",
	"违反合同会激怒你的雇主，尤其是如果你收到了预付款。",
	"防御工事只会提供给你来自拥有他们的贵族家族的合同。",
	"贵族只向达到“素养专业”名望的雇佣兵战团提供合同。",
	"如果合同谈判失败，将损害你与潜在雇主的关系。",
	"你可以在结算屏幕的左上角找到合同报价。",
	"你可能会发现强大的命名物品通过远离文明探索或跟踪酒馆的谣言。",
	"死亡是雇佣兵工作描述的一部分。",
	"注意你手下的情绪。如果他们生气太久，他们可能会离开！",
	"如果你一直输给敌人，改变你的战术！",
	"世界地图上的队伍越大，行动越慢。包括你的。",
	"使用战犬来追捕难以捉摸或逃跑的敌人。",
	"使用训练有素的猎鹰在困难的地形上发现隐藏的敌人。",
	"砍刀会造成伤口流血。",
	"实现野心会提高每个人的情绪，并给予你名望以及一些独特的奖励。",
	"使用 CTRL + 左键单击来攻击世界地图上的盟友。这仅适用于您目前失业的情况。",
	"你的人会根据他们的背景和特性不同进行相互交流。",
	"昏迷的角色不会借机攻击进入其控制区域的目标。",
	"一旦你获得了一些经验，试着在老兵模式下打一场战役，这是推荐的难度。",
	"任意攻击的最低命中率为5%，任意攻击的最高命中率为95%。",
	"角色有时会在战斗中被击倒，但不会被彻底击毙，并且会在受到永久损伤的情况下存活下来。",
	"从你的错误中学习。不要只是重复它们，希望这次你会幸运。",
	"冰原狼的自然栖息地是森林。",
	"你可以在选项菜单中启用更快的AI回合。",
	"树木可以在战斗中使用“T”键隐藏。",
	"可以使用“B”键突出显示阻挡格子的物体。",
	"更高的名望将解锁更困难的合同和更好的报酬。",
	"如果你的计划会因为运气不好而失败，也许就是计划的不够好。",
	"做好工作。活着。得到报酬。",
	"如果一个角色等待他们的回合，他们在下一轮的回合顺序中的位置将被确定，并受到 25% 的先攻惩罚。",
	"95% 的命中率也是 5% 的失败率。",
	"“独狼”特技不会受到附近的狗或不属于你战团的盟友的影响。",
	"“快速适应”特技减少了随机性的变化。",
	"考虑到敌人在山上设立的营地更难攻打，尤其是他们筑有工事时。"
];
gt.Const.LoadingScreens <- [
	"ui/screens/loading_screen_01.jpg",
	"ui/screens/loading_screen_01.jpg",
	"ui/screens/loading_screen_02.jpg",
	"ui/screens/loading_screen_03.jpg",
	"ui/screens/loading_screen_04.jpg",
	"ui/screens/loading_screen_04.jpg",
	"ui/screens/loading_screen_07.jpg",
	"ui/screens/loading_screen_08.jpg"
];
