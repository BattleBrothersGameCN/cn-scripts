this.hunting_sand_golems_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_sandgolems";
		this.m.Name = "流沙";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 850 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"猎杀沙漠中杀人的东西，大概在 " + this.Contract.m.Home.getName()
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 10 && this.Contract.getDifficultyMult() >= 1.15)
				{
					this.Flags.set("IsEarthquake", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Desert)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local mapSize = this.World.getMapSize();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 8, 12, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "伊夫利特", false, this.Const.World.Spawn.SandGolems, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.setDescription("活体岩石构成的生物，由南方炎阳的酷热和烈火塑造而成。");
				party.setFootprintType(this.Const.World.FootprintsType.SandGolems);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);

				for( local i = 0; i < 1; i = ++i )
				{
					local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, disallowedTerrain);

					if (nearTile != null)
					{
						this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.SandGolems, 0.75);
					}
				}

				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(8);
				roam.setMaxRange(12);
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Desert, true);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					this.Contract.setScreen("Victory");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					local tileType = this.World.State.getPlayer().getTile().Type;

					if (tileType == this.Const.World.TerrainType.Desert)
					{
						this.Flags.set("IsBanterShown", true);
						this.Contract.setScreen("Banter");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsEarthquake"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Earthquake");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.World.Contracts.startScriptedCombat(properties, false, true, true);
					}
				}
				else if (!this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					this.Contract.setScreen("Encounter");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"返回" + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "谈判",
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer%抬起头，似乎沿着他的鼻梁俯视着你。这是一种极具蔑视的姿态，但他确实让你进来了。这位维齐尔拍了拍手，一个仆人拿着一卷卷轴来到你面前，将其展开并宣读。%SPEECH_ON%沙海中发现了伊夫利特的踪迹。逐币者——也就是你——将受……%SPEECH_OFF%维齐尔又拍了拍手。%SPEECH_ON%可能是他，仆人。是‘可能’是他。注意你的用词。%SPEECH_OFF%你知道仆人想说不是他写的这卷轴，但他把话咽了回去。 他回到刚才的声明上。%SPEECH_ON%……受雇去驱散灼热的沙尘，使其回归自然状态。消灭上述怪物将获得%reward%克朗的报酬。%SPEECH_OFF%卷轴重新卷起，仆人从两边捧着，滑出了视线。你再次看到维齐尔，但他正由一个奴隶女孩喂着葡萄，没在注意你。 | 一位名叫%employer%的维齐尔接待了你，不过这次会面中的所有礼节都只是公事公办的客套而已。%SPEECH_ON%逐币者，伊夫利特在沙海中潜行。召你来就是为了处理此事。如果你不接受%reward%克朗的报酬，那我们自会另寻他人替代你。%SPEECH_OFF% | 你走进一个房间，发现几位维齐尔几乎被奴隶女孩们的身子给埋住了。房间里充满了大量的嬉笑和挑逗，但最引人注意的是，似乎没人注意到你来了。除了一个年长的男人，他蹒跚着走过来向你鞠躬。%SPEECH_ON%逐币者，维齐尔%employer%在召请逐币者执行猎杀伊夫利特的任务。%SPEECH_OFF%老人瞥了一眼那边，然后挺直了身子。他再次开口时，已经去掉了那些装模作样的废话。%SPEECH_ON%它们是些巨大的沙土杂种，正在乡间肆虐。我警告你，它们可不是好惹的，所以别让这满眼的浮华和黄金忽悠了，去应付你应付不来的事。如果你接受，报酬是%reward%克朗。%SPEECH_OFF%老人挺直腰板，清了清嗓子，大声问道。%SPEECH_ON%你是否接受征召？%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{有意思，继续。 | 猎杀这样的敌人可不便宜。 | 这会花不少钱。 | 在沙漠中追捕幻象。这差事谁不喜欢。 | %companyname%可以帮忙，只要价钱合适。}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{听起来这活不适合我们。 | 我可不会带着弟兄们在沙漠里漫无目的地瞎转。 | 我觉得还是免了吧。 | 我拒绝，弟兄们更愿意对付有血有肉的敌人。}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Banter",
			Title = "在途中……",
			Text = "[img]gfx/ui/events/event_161.png[/img]{在追踪神秘的伊夫利特时，你遇到一位脚如皮革般粗糙的老妇。见到你，她鞠了一躬。%SPEECH_ON%啊，金币的奴隶，你们寻找的是伊夫利特，对吧？当然。我从你们脸上就看出来了。%SPEECH_OFF%她停顿了一下，指向你们要去的沙丘方向。%SPEECH_ON%我们在这土生土长，懂吗？我们与这片土地是一体的。当我们彼此放逐、伤害、施以残酷时，沙海便会站在蒙冤者的一边。你们该畏惧的并非怪物本身，而是它被创造出来的缘由，因为这缘由已渗透此间沙砾。依此逻辑，你们或许能杀死一头怪物，却无法断绝让它不断涌现的根源。%SPEECH_OFF% | 你在沙漠中遇到一口井。一个男人给你几桶水让你解渴，并说地下的水源永不枯竭。放眼望去不见一片农田，你有理由相信地下的水足以让人永远解渴。不过，这个男人似乎察觉到你在这些地方另有目的。%SPEECH_ON%我猜你们在找伊夫利特，对不对？%SPEECH_OFF%你点点头，问他怎么知道的。他咧嘴一笑。%SPEECH_ON%因为我见过它们，见过它们的所作所为，而且我相信用不了多久，就会有专业的军队或维齐尔的奴隶来解决这些纷争。伊夫利特是复仇的怪物，它只会屈服于将它从大地中召唤出来的东西：残忍。%SPEECH_OFF%你喝完水，谢过陌生人的话语，继续上路。 | 沙地中有几具尸体。有些滑到了沙丘的半腰。一具躺在沙丘底部，另一具则离底部很远，像是被扔过去的。尸体正被风沙显露出来，暗示死亡就发生在不久之前。看起来，袭击他们的东西以惊人的力量将他们击得粉碎，然后又花了一点时间摧残剩余的尸骸，部分地方的皮肉都被彻底磨蚀，只剩骨头。伊夫利特一定就在附近……}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "注意脚下。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_153.png[/img]{乍一看，那只是海市蜃楼。远处的沙漠变幻不定，模糊不清，对于不知情或疲惫不堪的人来说，这些景象会扭曲变化，成为人们心中所想的任何东西。直到那伊夫利特转过身，将一具人体撕成两半，并把残肢甩过沙丘时，你才意识到这绝非想象中的怪物。它是一个来自地狱的生物，一团盘旋的沙尘暴，其中石块流转，勉强构成了一个类似人形的轮廓。当它向前倾身时，你意识到，至少在对踏入其领地武装陌生人的态度上，它与人类别无二致：在暴怒中杀戮。 | 前方的沙丘从上至下滑动，沙粒如同从床上掀起的床单般向你卷来。但一块石头仿佛破土而出，接着是另一块，又一块，当第一块石头升起时，你意识到那是一个伊夫利特。一声低吼迸发出来，深沉的咆哮夹杂着沙风撞击的噼啪声。这伊夫利特呈现出一种倾斜、支离破碎的人形，以石为骨，以沙为肉，然后它发起了冲锋。 | 你看到那伊夫利特将一条勉强算是手臂的东西向下伸向地面。沙粒从它的手臂中吹出，将这些沙粒压向一具尸体，力量撕碎了衣物，继而击穿撕开了皮肉，最后将其彻底剥离至白骨。当伊夫利特做完这一切，它转向你，发出了凶猛的咆哮。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "冲锋！",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Earthquake",
			Title = "当你接近时……",
			Text = "[img]gfx/ui/events/event_160.png[/img]{你刚踏上沙丘顶端，它立刻就从你脚下延伸开去。你发现自己正在下陷，在流沙将你完全吞噬前滚了出来。当你沿着沙坡翻滚时，你发现邻近的沙丘同样在后退，而你腹中的震颤并非源于恐惧，而是大地本身的猛烈摇晃。当一切平息，你站起身，稳住脚步。而伊夫利特们已然来到陷坑的边缘，俯视着你。它们朝你尖啸，那嘶嘶的狂怒伴随着沙粒彼此摩擦结晶的刺耳声响。你被包围了！ | 你停下脚步，叹了口气。沙漠仿佛无边无际，而就在你这么想的时候，你发现周围的景象正在收缩。过了一会儿你才意识到是大地在震动，流沙移动正将你吸入其中。你翻滚着脱离险境，却发现自己一路滚下沙坡。到了坡底，你迅速跳起，拔出武器，面对你早已猜到的对手：伊夫利特。它们站在沙丘的边缘，俯视着你，仿佛看着陷阱里的老鼠。它们的身体是沙尘构成的云雾，漂浮的石块勉强勾勒出一种类似人形的断续轮廓。它们发出低吼，向下冲来！}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "拿起武器！",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "战斗之后……",
			Text = "[img]gfx/ui/events/event_160.png[/img]{战斗结束了，但伊夫利特并未完全消散。构成它们躯体的沙砾翻涌冒泡，作为骨架的石块愤怒地移位、震颤。你听到的嘶嘶声全然不似怪物，分明是人类的声音。它们嘶嘶作响，声音就在你耳边。你猛地转身，却什么也没发现。它们又在你身后嘶嘶作声，而这次当你转过身时，声响消失了，沙砾静止了，石块也如常归于大地。这些野兽被消灭了，或许栖身于其中的东西也同样如此。是时候返回%employer%那里了。 | 伊夫利特被消灭了，但它们的躯体似乎只是某种更为邪恶之物的容器。你瞥见一些精魂朝着地平线飞掠而去，但也或许这只是沙漠制造的幻觉。没人能说得清，唯一能确定的是，伊夫利特那野兽般的躯体已被击败，单凭这一点，%employer%就该付你报酬。}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "完成了。",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "你回来后……",
			Text = "[img]gfx/ui/events/event_162.png[/img]{你试图进入%employer%的房间，但一名守卫拦住了你。你略带诧异地挑了挑眉，告诉他维齐尔正在等你。守卫俯视着你。%SPEECH_ON%他在等你，但他并不想见你。这是两码事，逐币者。探子已经确认了你在沙漠中的成果。这是你的报酬，和谈好的一样。现在离开。我说了，离开！%SPEECH_OFF%守卫跺了跺脚，走廊上所有站岗的守卫都同时跺脚并面向你。好吧，你虽不是什么天才，但也感觉出来，现在大概是该离开的时候了。 | %employer%从一个由靠垫和女人组成的王座上俯视着你。从锁链判断，那些是女奴，尽管也许这是她们的某种癖好——但她们悲伤的面容否定了这点。维齐尔开口说话，但这几乎像是表演给所有在场者看的，而你只是在配合出演。%SPEECH_ON%逐币者，我的小鹰们已向我禀报了你的作为。伊夫利特已被解决，它们的邪术将不再是威胁！这便是我的黄金的力量。这是我们约定好的工作，为此，%reward%克朗是你的报酬。%SPEECH_OFF%当一个仆人将一袋钱币递给你时，维齐尔朝你轻蔑地弹了弹手指。%SPEECH_ON%走吧。%SPEECH_OFF% | 你看到%employer%正把一个沙漏翻来覆去地转动。沙粒均匀地分布在两边的玻璃球里。沿墙站着一排低头躬身的仆人。在相邻的墙边则是一排坐垫，上面坐着衣着艳俗的女人，她们的头发由戴着锁链的女仆打理。维齐尔猛地将沙漏拍在桌上。他蹲在沙漏后面，眼睛透过玻璃两侧向内窥视，瞳孔向内盯着。你终于注意到里面的沙粒并未正常流动，而是在愤怒地旋转。%SPEECH_ON%伊夫利特已经被处理掉了，我的猎鹰们是这么告诉我的。逐币者，你完成了你被召来所做的工作，为此，你将得到%reward%克朗。我希望你在沙漠中的时光，不仅让你获得了战斗与战争的经验，也赐予了你沉思的念头。%SPEECH_OFF%你不确定这个人是什么意思。他猛地抓起沙漏，又开始左右倾斜它。沙粒在两侧撞击，激烈地翻腾。一个仆人递给你一袋钱币，接着你以最快的速度离开了这个房间。 | 你回到%employer%那里，发现维齐尔正脸朝下趴在一张软榻上。几个老男人正在用指关节为他捶背或揉脚。房间对面，一个女人在给自己扇扇子。她全身赤裸，她的目光从未离开维齐尔，维齐尔的目光也从未离开她。这个男人说话的样子，几乎就像你根本不在房间里一样。%SPEECH_ON%仆人们，把那个黑线缝的紫色钱袋给这个逐币者。逐币者，你对沙海中的精魂——这些所谓的伊夫利特——处理得不错。 是我的黄金将你引入那片沙漠，也是我的黄金奖赏了你，所以要让书记官们知道，是我的黄金真正解决了这个问题，并且，工具，也就是你这个逐币者，得到了公平的报酬。%SPEECH_OFF%一个仆人把一個紫色的袋子塞进你怀里。维齐尔呻吟了一声，因为一個老男人正好把肘部顶进了他的股沟。%SPEECH_ON%需要我命令你离开吗，逐币者？%SPEECH_OFF% | 一个没有眉毛的老人在%employer%的门外迎接并拦住了你。。他把一个袋子推到你怀里。%SPEECH_ON%里面有%reward%克朗，维齐尔说好的数目。%SPEECH_OFF%老人环顾四周寻找旁听者，当看到只有你一人在能听到的范围内时，他似乎点了点头。%SPEECH_ON%伊夫利特不仅仅是恶魔，它们是蒙冤的精魂，而你让它们得到了解脱。但它们很可能还会回来，因为像%employer%这样的人，除了如瀑布般的黄金，无法给这个世界带来任何东西，他们忘记了在那瀑布之下，许多人被碾压或溺毙。%SPEECH_OFF%你不确定他是什么意思，但一个走近的守卫结束了对话，老人扇了你一耳光。%SPEECH_ON%滚，逐币者！拿着你的报酬，从我眼前消失！%SPEECH_OFF% | 最出乎意料的是，一队猫迎接你进入%employer%的房间。你勉强能看到维齐尔在一道纱幔后面，旁边还有一群同样觉得好笑的围观者。\n\n你低头看见这群猫正拖着一块小木板，上面放着一个钱袋。你抬起头。那些剪影般的人都屏住了呼吸。叹了口气，你弯腰捡起了钱袋。一个窥视者忍不住鼓起掌来，但立刻被严厉的嘘声制止了。任务完成，猫群瘫倒在瓷砖上，四散开来，打盹、梳理毛发，或者扑抓阳光中飞舞的光影。你相当确定袋子里有%reward%克朗，但一刻也不想在这个房间里多待，你走到外面去清点。}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "狩猎成功。",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "清除城市附近的伊夫利特");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color]克朗"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/mirage_sightings_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setAttackableByAI(true);
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});
