this.abandoned_village_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.abandoned_village_enter";
		this.m.Title = "当你接近时……";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_178.png[/img]{一座刚刚被毁坏不久的村庄……却没发现任何尸体。有的不过是一阵微风，掀起尘灰，在废墟间嘶嘶作响。不过有一座建筑幸免于难，一尊巨大的精心雕刻的男性石像。至少你觉得那是个男的。石像的脸被准确地移走了，表明这一切是有意为止，而非强盗等的肆意破坏。\n\n突然，脚步趟在泥水里的声音从四面八方逼近。肿胀的人影从阴影中蹒跚着现身：这是些被胡乱缝在一起的驼背的怪物，东拼西凑的躯干上，松垮的皮肉时不时现出里面的器官，多余的四肢七扭八扭地连在身上，自上而下的抽动着，而在这堆烂肉之上，好几个脑袋被安放在一起，仿佛某种有自我意识的肉质图腾，数张巨口无力地张开着，发出骇人的咕哝声，众多的眼睛瞪得老大，或盯着你，或盯着地面，或相互对视。你的手下们喘着粗气，拿起了武器。而怪物们则低吼着从地上捡起工具和武器。一头怪物探下身，捡起来两把菜刀。它摇摇晃晃地向前走来，面对着你们，皮肤上那些扭曲的面孔纷纷投来目光，它们张大嘴巴，尖叫声来回着传递，啸叫在腔室中回响，这些面孔轮流吸着气，让其他的面孔也有机会尖叫出声。\n\n你还有逃跑的机会 — 这东西不太可能追得上任何人，除了尊严和骄傲，你还能有什么损失呢？}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "战斗！",
					function getResult( _event )
					{
						local location = this.World.State.getLastLocation();

						if (location != null)
						{
							location.setVisited(false);
							location.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
							_event.registerToShowAfterCombat("Victory", "Defeat");
							this.World.State.startScriptedCombat(_event.buildEventCombatProperties(_event, location), false, false, false);
						}

						return 0;
					}

				},
				{
					Text = "快离开这个地方！",
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
				if (this.World.Statistics.getFlags().get("AbandonedVillageFightDefeated"))
				{
					this.Text = "[img]gfx/ui/events/event_178.png[/img]{不出所料，那些血肉魔像仍在无面石像周围徘徊。从它们身上的腐烂程度来看，他们的队伍里既有新成员，也有行将崩坏的老家伙。但当它们那黏糊糊的眼睛瞪向你和队员们时，它们展现出了一致的攻击性。你拔出剑，命令大家列好阵型。如果这个小镇有什么秘密，那么你一定要把它挖出来！}";
					this.Options = [
						{
							Text = "战斗！",
							function getResult( _event )
							{
								local location = this.World.State.getLastLocation();

								if (location != null)
								{
									location.setVisited(false);
									location.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
									_event.registerToShowAfterCombat("Victory", "Defeat");
									this.World.State.startScriptedCombat(_event.buildEventCombatProperties(_event, location), false, false, false);
								}
							}

						}
					];
				}
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_178.png[/img]{你站在刚被你击败的……那堆玩意儿旁。%randombrother%用剑刃挑起一团肉糊，将其举在面前。一大团皮肉从缝合处拉得老长，伸出的手臂就像是树枝，一团团脂肪顺着那些肢体滑下，像是流淌的树液。四处散落着不协调的肢体：这边，一只脚像门把手似的从躯干上垂下来；那边，一张脸仿佛正融化成一滩筋腱和韧带的河流。待你的佣兵任它从剑上滑下，那团肉囊便 “啪嗒” 一声摔在地上，骨头发出哗啦啦的声响，宛如一架坍塌的绳梯。%randombrother2% 拿着一筒箭矢和一本小书走了过来。%SPEECH_ON%我找到了这筒，呃，挺有意思的箭。看这箭筒底部，好像是个能浸泡箭头的容器。旧神才知道那里面装的是啥玩意儿。另外，其中一个家伙的脑袋上还绑着本书，感觉挺重要的。%SPEECH_OFF%打开那本书，你看到一连串村庄的名单，名单上的村庄逐一被划掉了，每个名字旁都标着一个简单的数字。五十、六十、七十。在书的最后一页，有一张去往另一处地点的地图，那似乎是一座庄园。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "看来我们得快一点了。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "战斗之后……";
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/ammo/legendary/quiver_of_coated_arrows");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + item.getName()
				});
				local locations = this.World.EntityManager.getLocations();

				foreach( location in locations )
				{
					if (location.getTypeID() == "location.artifact_reliquary")
					{
						location.setVisibilityMult(1.0);
						this.World.uncoverFogOfWar(location.getTile().Pos, 700.0);
						location.setDiscovered(true);
						this.World.getCamera().moveTo(location);
						location.onUpdate();
						break;
					}
				}

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_178.png[/img]{战局急转直下。你意识到，这些怪物身上，也一定有那些死在他们手里的人。为了不落得同样的下场，你下令撤退。血肉魔像们太过笨拙，它们缓慢地处理掉队伍的后卫，渐渐淡出了你的视野。\n\n或许你还会回到这里 — 这里的怪物到底是怎么回事？}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我们还会回来的。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "战斗之后……";
				this.World.Statistics.getFlags().set("AbandonedVillageFightDefeated", true);
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

	function buildEventCombatProperties( _event, _location )
	{
		local properties = this.Const.Tactical.CombatInfo.getClone();
		properties.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[_location.getTile().TacticalType];
		properties.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
		properties.CombatID = "AbandonedVillage";
		properties.Music = this.Const.Music.UndeadTracks;
		properties.LocationTemplate.Template[0] = "tactical.golems_village";
		properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineCenter;
		properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
		properties.IsWithoutAmbience = true;
		properties.Parties.push(_location);
		properties.Entities = [];
		local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID();
		properties.BeforeDeploymentCallback = function ()
		{
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", f, 7, 8, 7, 8, true);

			for( local i = 0; i < 2; i = ++i )
			{
				_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem", f, 6, 9, 6, 9, false);
			}

			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 6, 9, 6, 9, false);
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", f, 7, 8, 25, 26, true);

			for( local i = 0; i < 2; i = ++i )
			{
				_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem", f, 6, 9, 24, 27, false);
			}

			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 6, 9, 24, 27, false);
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", f, 24, 25, 15, 16, true);

			for( local i = 0; i < 2; i = ++i )
			{
				_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem", f, 23, 26, 14, 17, false);
			}

			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 23, 26, 14, 17, false);
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 13, 15, 3, 5, false);
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 13, 15, 26, 28, false);
		};
		properties.AfterDeploymentCallback = function ()
		{
			local weather = this.Tactical.getWeather();
			local time = this.World.getTime().TimeOfDay;
			weather.setAmbientLightingPreset(5);
			weather.setAmbientLightingSaturation(0.9);
			local clouds = weather.createCloudSettings();
			clouds.Type = this.getconsttable().CloudType.Fog;
			clouds.MinClouds = 20;
			clouds.MaxClouds = 24;
			clouds.MinVelocity = 3.0;
			clouds.MaxVelocity = 16.0;
			clouds.MinAlpha = 0.35;
			clouds.MaxAlpha = 0.45;
			clouds.MinScale = 2.0;
			clouds.MaxScale = 3.0;
			weather.buildCloudCover(clouds);
		};
		return properties;
	}

	function spawnEntityWithinBounds( _entity, _faction, _xLower, _xUpper, _yLower, _yUpper, _raiseTile, _maxAttempts = 200 )
	{
		local attempts = 0;
		local spawned = false;

		do
		{
			attempts++;
			local x = this.Math.rand(_xLower, _xUpper);
			local y = this.Math.rand(_yLower, _yUpper);
			local tile = this.Tactical.getTileSquare(x, y);

			if (!tile.IsEmpty)
			{
			}
			else
			{
				if (_raiseTile)
				{
					tile.Level = 1;

					for( local i = 0; i != 6; i = ++i )
					{
						if (!tile.hasNextTile(i))
						{
						}
						else
						{
							local next = tile.getNextTile(i);

							if (next.Level == 1)
							{
								tile.Level = 2;
								break;
							}
						}
					}
				}

				local e = this.Tactical.spawnEntity(_entity, tile.Coords);
				e.setFaction(_faction);
				e.assignRandomEquipment();
				spawned = true;
			}
		}
		while (!spawned && attempts <= _maxAttempts);

		return spawned;
	}

});
