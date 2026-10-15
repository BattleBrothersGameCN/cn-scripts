this.rf_old_swordmaster_scenario_student_local_duel_event <- ::inherit("scripts/events/event", {
	m = {
		Candidates = [],
		Champion = null,
		Partner = null,
		RandomBro = null,
		RandomBro2 = null,
		Flags = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.rf_old_swordmaster_scenario_student_local_duel";
		this.m.Title = "当你接近时……";
		this.m.Cooldown = 60.0 * ::World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_50.png[/img]{你的学徒，%champion%，最近焦虑得有些异常。他在对练中投入的力量远超过了“友好”的范畴。甚至还打碎了两把木剑，飞出的木屑险些伤到其他的学徒。终于，你亲眼见证了%champion%和%partner%疯狂的对练。训练剑直撞在一起，火花四处飞溅！%champion%连续打击%partner%的防线，而他的“敌人”只能勉强招架，毫无还手之力。眼看%partner%支撑不住，%champion%抡剑过头顶，直接朝他的脑瓢砸去！\n\n幸亏你反应及时，挺剑格住了这致命的一击！你立刻抓住肩膀，把他拽到一边，让他对他的暴躁行为做出解释。%SPEECH_ON%师父，我听说%townname%有一位剑术大师，是本地领主最强的侍卫。我觉得我已经完全够格了，一定能击败他，取而代之！有您的教诲和我的武艺，荣耀不就在眼前了吗！%SPEECH_OFF%他说的每个字都充满了激情，看你没有反应，他马上接着说%SPEECH_ON%我掌握了所有的技术！我，我在您的带领下击败了那么多人，师父！没有一位师兄弟强得过我！怎么可能让这么个，这么个老东西 —— %SPEECH_OFF%他顿了顿，猛地低下了头，避开了你的眼神。你挑起了眉毛。%SPEECH_ON%没有说您的意思，师父，我是说……我能搞定他！我向你保证。%SPEECH_OFF%他很有能量，也对自己的武艺十分自信……但你也曾经被人挑战，很清楚这种决斗的传统：战斗至死。一步踏错，一个判断失误，都足以让你的学生即刻丧命。他真的能面对这样的挑战吗？%SPEECH_ON%我还是下不了决心……%SPEECH_OFF%你说道。干瘪起褶的脸上挂着苦笑。%SPEECH_ON%求你了，给我这次机会吧，我不想让您的教导白费！这可是千载难逢的好机会！是我们所有人的荣耀！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "失态的学徒";
				_event.m.Flags.set("EnemyChampionName", ::Const.Strings.CharacterNames[::Math.rand(0, ::Const.Strings.CharacterNames.len() - 1)] + " " + ::Const.Strings.SwordmasterTitles[::Math.rand(0, ::Const.Strings.SwordmasterTitles.len() - 1)]);
				this.Options.push({
					Text = "我会为你祈祷的，%champion%！",
					function getResult( _event )
					{
						return "N";
					}

				});
				this.Options.push({
					Text = "不行，你这是去送死！",
					function getResult( _event )
					{
						if (::Math.rand(1, 100) > 80)
						{
							return "StudentInsists";
						}
						else
						{
							return "StudentBacksOff";
						}
					}

				});
				this.Characters.push(_event.m.Champion.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "StudentBacksOff",
			Text = "[img]gfx/ui/events/event_82.png[/img]{失望立刻爬满了%champion%的脸。他的表情庄重而阴沉，想着你说的话，舌头在嘴唇上舔了又舔，脑袋也耷拉了下去。%SPEECH_ON%我，我懂了，师父。如果你 —— %SPEECH_OFF%他鼻子一抽%SPEECH_ON%如果你觉得我还不行。那我也没办法改变您的决定……我回去干我该干的事了。谢，谢谢。%SPEECH_OFF%他转身离去，双肩低垂，眉头紧皱，严酷的事实深深地打击了他。你并非没有过这样的感觉，你的一生中当然也有过失望，不过，这也是给你所有的学生上了一课。并非所有的战斗都可以速战速决，有些本事得靠时间磨出来，而%champion%还没到那个地步，就 —— 差那么一点点。\n\n个别学生不太认同这个想法，但没人敢站出来质疑你的决定。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "心灰意冷";
				_event.m.Cooldown = 30.0 * ::World.getTime().SecondsPerDay;
				_event.m.Champion.worsenMood(1.5, "阻止他参加一场意义非凡的决斗");

				if (_event.m.Champion.getMoodState() < ::Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Champion.getMoodState()],
						text = _event.m.Champion.getName() + ::Const.MoodStateEvent[_event.m.Champion.getMoodState()]
					});
				}

				this.Options.push({
					Text = "苦心人天不负……总会有机会的，%champion%！",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "StudentInsists",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%champion%的嘴角一扯，眯起眼睛，露出个恶心的笑。他猛然抬起右腿，又重重跺在地上，像是个撒泼的孩子，而不是规矩的学徒。他攥紧了拳头，像是要发作，眼角甚至挤出了泪花。正当你以为他要大喊大叫一番的时候，%champion%仰面朝天，颤抖着开口。%SPEECH_ON%我……我会证明你错了。没有人能这样羞辱我。就算是我的师父，我的 —— 偶像也不行！我这就去，这就去砍了这个该死的废物！让你看看我行不行！%SPEECH_OFF%他是如此大胆，把自己不成熟的一面公之于众。不等你回话，他鼻子一抽，就扭头转身。迅速收拾起东西，抓过剑，套上盔甲，系紧鞋带，挺起胸膛，站得要多直就有多直 —— 你从没见他这么利索过。%SPEECH_ON%你们谁爱跟着就跟着吧，我无所谓。刚好让你们做个见证！看我怎么一剑劈了那个老混蛋！不是靠你教我的那些东西，而是我已经超出了你那些老一套！记住。我的。话。%SPEECH_OFF%说完，他朝着%townname%的方向，头也不回地冲出了营地。你的学徒们用复杂的眼神看着你，有的惊讶地窃窃私语，有的因这幅景象愣住，还有的在为决斗的结果打赌。为了控制局面，你点了两名学徒，让他们跟着%champion%，确保他别干傻事。他们立刻起身，追了上去。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "一意孤行";
				this.Options.push({
					Text = "祝你好运！",
					function getResult( _event )
					{
						_event.startCombat(_event);
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "N",
			Text = "[img]gfx/ui/events/event_35.png[/img]{听了你的表态，%champion%的眼睛一下子亮了起来！他把手按在胸前，深深鞠了一躬，用满是自信的声音说道。%SPEECH_ON%师父，我肯定不会让您失望。我要么会带着兄弟们胜利归来，要么也会光荣战死。我向您保证。吟游诗人会这样传唱我们的故事，一个“剑术大师”陨落在我的剑下的故事！%SPEECH_OFF%他抬起头，看向%randombro%和%randombro2%。%SPEECH_ON%你们俩！赶紧的，跟我去%townname%！现在就去！%SPEECH_OFF%两人犹豫地看了看你，但还是准备跟着%champion%一起出发。没想到，%partner%突然笑着走到了%champion%身边，重重地拍了拍他的肩膀,还顺势给了他一个拥抱。%SPEECH_ON%我相信你，兄弟。我们就等着你把荣誉带回来了，大伙指望着你呢！等你回来，我第一个给你倒酒，让你好好讲讲这场精彩的战斗！%SPEECH_OFF%%champion%紧紧回抱了%partner%，退后一步，露出了灿烂的笑容。%SPEECH_ON%放心吧，兄弟！用不了多久，这份荣耀就会是我们的！%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "",
					function getResult( _event )
					{
						_event.startCombat(_event);
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "巅峰对决！";

				if (_event.m.Champion.getSkills().hasSkill("effects.rf_old_swordmaster_scenario_avatar"))
				{
					this.Options[0].Text = "受死吧！";
				}
				else
				{
					this.Options[0].Text = "让我骄傲吧，" + _event.m.Champion.getName() + "!";
				}

				this.Characters.push(_event.m.Champion.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%champion%走了这么久，可把你和徒弟们急坏了。营火旁空着的三个座位上，炖菜凉透了，面包也干得咬不动了。原本热闹的营地，现在安静的让人发慌。没人提前回帐篷休息，也没人收拾起锅碗瓢盆。大家都眼巴巴地盼着，等着他们心心念念的朋友回来。\n\n已经有人琢磨着给%champion%挖坟了，好像这场战斗必死无疑。还有人坐在路边，向过往的旅人打听%townname%的消息。终于，当太阳快落山时……三个身影出现在山顶。%SPEECH_ON%“他们回来了！他们回来了！%champion%赢了！”%SPEECH_OFF%随着这三人越走越近，大家的窃窃私语也被欢呼取代。走在最前面的%champion%略显疲惫，他的剑被鲜血浸透，头发沾满了汗水、血迹和泥浆，但这些都掩盖不了他的脸，一张沉浸在胜利的光彩里的脸。%champion%径直走向你，双膝跪地，托起一把华丽而趁手的剑。%SPEECH_ON%师父，这就是被我击败的剑术大师的剑，我已经击败敌人，以您的名义赢得了荣耀与声名！请您……收下它。%SPEECH_OFF%你微笑着，骄傲地接过剑，举到空中。周围的学徒们爆发出欣喜若狂的欢呼声！\n\n这胜利是如此的不真切，%champion%被高高举起，在营地里四周游行，接受着众人的赞美。\n\n年轻的%champion%已经证明，他的技艺足以被称为一位 —— 剑术大师，%champion%几乎，几乎可以和你的水平相当了。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%champion%，你是我的骄傲！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "战斗之后……";
				this.Characters.push(_event.m.Champion.getImagePath());
				::World.Assets.addBusinessReputation(50);
				_event.evolveChampion(_event.m.Champion, this);
				_event.m.Champion.improveMood(1.0, "赢得了一场意义非凡的决斗");

				if (_event.m.Champion.getMoodState() >= ::Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Champion.getMoodState()],
						text = _event.m.Champion.getName() + ::Const.MoodStateEvent[_event.m.Champion.getMoodState()]
					});
				}

				foreach( bro in ::World.getPlayerRoster().getAll() )
				{
					if (bro == _event.m.Champion)
					{
						continue;
					}

					bro.improveMood(0.5, "战团的勇士在一场意义非凡的对决中胜出");

					if (bro.getMoodState() >= ::Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = ::Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + ::Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_124.png[/img]{时间一分一秒地过去，你和那些焦躁的学生们一起，巴望着%champion%归来。几个学生踱来踱去，不安地盯着地平线，盼着三兄弟凯旋。这样干等着让你心里也有些不是滋味，但考虑到眼下的情况，你也只能时不时朝地平线看上一眼，默默祈祷，希望他们能胜利归来。\n\n%champion%的帐篷后面，一座新坟已然挖好，喻示着失败的下场。你甚至逮到一个翻他们行李的学生，说什么死人就用不上这些东西了。\n\n太阳渐渐西沉……两个扛着盾牌的人影现身在山丘顶上。看到这幅景象，%partner%发出绝望的哀嚎。营地里原本的嘈杂瞬间安静，所有人都被这突如其来的场景惊呆了……连你自己也有些不相信自己的眼睛。\n\n随着他们一步步走进营地，躺在盾牌上的%champion%显得异常平静，看来这场战斗只用短短一击就分出了胜负，至少他死得还算干脆，没怎么受罪。这种死法在你的手下也有过不少。\n\n下葬的仪式说不上隆重，但却充满了对他的尊重和怀念。%randombro%眼泛泪光，拿着一本小小的祷文站在墓前。在他轻声念出的几句慰灵话语中，他的朋友为他的坟墓填上了最后一铲土。墓前只有一块简陋的木桩，歪歪扭扭地刻着他的名字。这样简陋的归宿，和他的勇敢实在是不相称。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "战斗之后……";
				::MSU.Array.removeByValue(_event.m.Candidates, _event.m.Champion);

				foreach( bro in _event.m.Candidates )
				{
					if (bro == _event.m.Partner)
					{
						continue;
					}

					if (_event.canHaveRandomBros(bro, _event.m.Partner))
					{
						this.Options.push({
							Text = "你来代表我们报仇" + bro.getName() + ".",
							function getResult( _event )
							{
								_event.m.Champion = bro;
								_event.setupRandomBros();
								_event.startCombat(_event);
								return 0;
							}

						});
					}
				}

				  // [043]  OP_CLOSE          0      2    0    0
				$[stack offset 0].Options.push({
					Text = "永别了，%champion%！怎奈你英年早逝！",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!::World.getTime().IsDaytime || ::World.Assets.getOrigin().getID() != "scenario.rf_old_swordmaster")
		{
			return;
		}

		local bros = ::World.getPlayerRoster().getAll();

		if (bros.len() < 5)
		{
			return;
		}

		local town;
		local playerTile = ::World.State.getPlayer().getTile();

		foreach( t in ::World.EntityManager.getSettlements() )
		{
			if (t.getSize() > 2 || t.getSize() > 1 && t.isMilitary())
			{
				if (t.getTile().getDistanceTo(playerTile) <= 10 && !t.isIsolated())
				{
					town = t;
					break;
				}
			}
		}

		if (town == null)
		{
			return;
		}

		this.m.Candidates = [];
		local non_canditates = [];

		foreach( bro in bros )
		{
			if (bro.getSkills().hasSkill("effects.rf_old_swordmaster_scenario_avatar"))
			{
				continue;
			}

			if (bro.getCurrentProperties().getMeleeSkill() < 100 || bro.getCurrentProperties().getMeleeDefense() < 45 || bro.getBackground().getID().find("swordmaster") != null || !bro.getPerkTree().hasPerkGroup("pg.rf_swordmaster"))
			{
				non_canditates.push(bro);
			}
			else if (bro.getSkills().getSkillByID("effects.rf_old_swordmaster_scenario_recruit").isEnabled())
			{
				this.m.Candidates.push(bro);
			}
		}

		if (this.m.Candidates.len() == 0)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = this.m.Candidates.len() * 25;
		this.m.Champion = this.m.Candidates.remove(::Math.rand(0, this.m.Candidates.len() - 1));
		non_canditates.extend(this.m.Candidates);
		this.m.Partner = non_canditates.remove(::Math.rand(0, non_canditates.len() - 1));
		this.m.Candidates.sort(function ( _a, _b )
		{
			return _a.getXP()  _b.getXP();
		});
		this.m.Candidates.reverse();
		this.setupRandomBros();
	}

	function canHaveRandomBros( _champion, _partner )
	{
		local count = 0;

		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro != _champion && bro != _partner && !bro.getSkills().hasSkill("effects.rf_old_swordmaster_scenario_avatar"))
			{
				count++;
			}
		}

		return count >= 2;
	}

	function setupRandomBros()
	{
		local randomBros = [];

		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (this.m.Champion != bro && this.m.Partner != bro && !bro.getSkills().hasSkill("effects.rf_old_swordmaster_scenario_avatar"))
			{
				randomBros.push(bro);
			}
		}

		if (randomBros.len() < 2)
		{
			return false;
		}

		this.m.RandomBro = randomBros.remove(::Math.rand(0, randomBros.len() - 1));
		this.m.RandomBro2 = randomBros.remove(::Math.rand(0, randomBros.len() - 1));
		return true;
	}

	function onPrepare()
	{
		this.m.Flags = ::new("scripts/tools/tag_collection");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"champion",
			this.m.Champion.getName()
		]);
		_vars.push([
			"partner",
			this.m.Partner.getName()
		]);
		_vars.push([
			"randombro",
			this.m.RandomBro.getName()
		]);
		_vars.push([
			"randombro2",
			this.m.RandomBro2.getName()
		]);
		_vars.push([
			"enemyname",
			this.m.Flags.get("EnemyChampionName")
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Candidates.clear();
		this.m.Champion = null;
		this.m.Partner = null;
		this.m.RandomBro = null;
		this.m.RandomBro2 = null;
		this.m.Flags = null;
		this.m.Town = null;
	}

	function startCombat( _event )
	{
		local name = _event.m.Flags.get("EnemyChampionName");
		local properties = ::World.State.getLocalCombatProperties(::World.State.getPlayer().getPos());
		properties.Music = ::Const.Music.NobleTracks;
		properties.Entities = [];
		properties.Entities.push({
			ID = ::Const.EntityType.Swordmaster,
			Variant = 0,
			Row = 0,
			Name = name,
			Script = "scripts/entity/tactical/humans/swordmaster",
			Faction = ::Const.Faction.Enemy,
			function Callback( _entity, _tag )
			{
				_entity.setName(name);
			}

		});
		properties.Players.push(_event.m.Champion);
		properties.IsUsingSetPlayers = true;
		properties.IsFleeingProhibited = true;
		properties.IsAttackingLocation = true;
		properties.BeforeDeploymentCallback = function ()
		{
			local size = ::Tactical.getMapSize();

			for( local x = 0; x < size.X; x++ )
			{
				for( local y = 0; y < size.Y; y++ )
				{
					local tile = ::Tactical.getTileSquare(x, y);
					tile.Level = ::Math.min(1, tile.Level);
				}
			}
		};
		_event.registerToShowAfterCombat("Victory", "Defeat");
		::World.State.startScriptedCombat(properties, false, false, false);
	}

	function evolveChampion( _actor, _screen )
	{
		local currentBackground = _actor.getBackground();
		local oldDesc = currentBackground.m.Description;
		local newBackground = ::new("scripts/skills/backgrounds/rf_renowned_swordmaster_background");
		newBackground.m.IsNew = false;
		_actor.getSkills().removeByID(currentBackground.getID());
		_actor.getSkills().add(newBackground);
		newBackground.m.RawDescription = oldDesc + "在你的指导下，%name%成长为了真正的剑术大师。击败了著名的剑术大师" + this.m.Flags.get("EnemyChampionName") + "，一战成名，证明了自己的实力！";
		newBackground.buildDescription(true);
		local effect = _actor.getSkills().getSkillByID("effects.rf_old_swordmaster_scenario_recruit");

		foreach( row in ::DynamicPerks.PerkGroups.findById("pg.rf_sword").getTree() )
		{
			foreach( perkID in row )
			{
				local perk = _actor.getSkills().getSkillByID(perkID);

				if (perk == null)
				{
					perk = ::Reforged.new(::Const.Perks.findById(perkID).Script);
					_actor.getSkills().add(perk);
				}
				else if (perk.m.IsRefundable)
				{
					_actor.m.PerkPoints++;
					_actor.m.PerkPointsSpent--;
				}

				perk.m.IsRefundable = false;

				if (effect.m.FreePerksGainedIDs.find(perkID) == null)
				{
					effect.m.FreePerksGainedIDs.push(perkID);
				}
			}
		}

		local attributes = {
			MeleeSkill = ::Math.rand(10, 15),
			MeleeDefense = ::Math.rand(10, 15),
			Stamina = ::Math.rand(5, 10),
			Bravery = ::Math.rand(10, 20),
			Initiative = ::Math.rand(10, 20)
		};
		_actor.getBaseProperties().MeleeSkill += attributes.MeleeSkill;
		_actor.getBaseProperties().MeleeDefense += attributes.MeleeDefense;
		_actor.getBaseProperties().Stamina += attributes.Stamina;
		_actor.getBaseProperties().Bravery += attributes.Bravery;
		_actor.getBaseProperties().Initiative += attributes.Initiative;
		_actor.getSkills().update();
		_screen.List = [
			{
				id = 10,
				icon = "ui/backgrounds/background_30.png",
				text = this.m.Champion.getName() + "现在是一名" + this.m.Champion.getBackground().m.Name + "."
			},
			{
				id = 10,
				icon = "ui/icons/perks.png",
				text = this.m.Champion.getName() + "获得了所有的剑特技组特技，已经花费的特技点数会被返还。"
			}
		];
		_screen.List.extend([
			{
				id = 10,
				icon = "ui/icons/special.png",
				text = "战团获得了名望"
			},
			{
				id = 10,
				icon = "ui/icons/melee_skill.png",
				text = this.m.Champion.getName() + "获得了" + ::Const.UI.getColorized(attributes.MeleeSkill, ::Const.UI.Color.PositiveEventValue) + "点近战技能"
			},
			{
				id = 10,
				icon = "ui/icons/melee_defense.png",
				text = this.m.Champion.getName() + "获得了" + ::Const.UI.getColorized(attributes.MeleeDefense, ::Const.UI.Color.PositiveEventValue) + "点近战防御"
			},
			{
				id = 10,
				icon = "ui/icons/fatigue.png",
				text = this.m.Champion.getName() + "获得了" + ::Const.UI.getColorized(attributes.Stamina, ::Const.UI.Color.PositiveEventValue) + "点疲劳值"
			},
			{
				id = 10,
				icon = "ui/icons/bravery.png",
				text = this.m.Champion.getName() + "获得了" + ::Const.UI.getColorized(attributes.Bravery, ::Const.UI.Color.PositiveEventValue) + "点决心值"
			},
			{
				id = 10,
				icon = "ui/icons/initiative.png",
				text = this.m.Champion.getName() + "获得了" + ::Const.UI.getColorized(attributes.Initiative, ::Const.UI.Color.PositiveEventValue) + "点主动值"
			}
		]);
	}

});
