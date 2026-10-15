this.artifact_reliquary_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.artifact_reliquary_enter";
		this.m.Title = "当你接近时……";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_182.png[/img]{一座完全由切好的石块和彩绘瓦片建成的庄园矗立在这个地区。这种审美品味，哪怕大多数王室成员也负担不起。草坪修剪得很低，像是踏入这片蛮荒之地的脚印，姿态各异的人像雕塑点缀其间，或志得意满，或落寞怅惘。树篱修剪成动物形状，喷泉喷出清水，泛着粼粼波光。战团站在一面涂黑的栅栏之外，像农场里的动物一样发呆张望。%randombrother%摇了摇头，啐了一口。%SPEECH_ON%没错，是很漂亮，但阔佬们可不会随便敞着门等人进去参观，对吧？这地方要么早就被洗劫一空，要么就是住着什么怪东西，强盗比起他们都得算是无辜路人。%SPEECH_OFF%你表示同意。再往里看，是一条通往碗形凹坑的小路，坑边的悬崖就像是神灵们用手指戳出来的一般。你心里很清楚，如果继续探索下去，你们未必能活着出来。你完全可以先离开这里，以后再来……}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "前进，伙计们。",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "我们以后再来。",
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
				if (this.World.Statistics.getFlags().get("ReliquaryFightDefeated"))
				{
					this.Text = "[img]gfx/ui/events/event_182.png[/img]{你又踏进了那片碗状的土地上，血肉魔像早已在悬崖边缘上就位。大先知手持怪杖站在正中，狞笑着说。%SPEECH_ON%欢迎回来。好好品尝我的母爱吧。%SPEECH_OFF%}";
					this.Options = [
						{
							Text = "这狗娘养的……",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_182.png[/img]{你下令让队伍开进那形似月球表面的悬崖区域。突然，一名头戴高大黑盔的男子从雕像后转了出来。只见他手持一柄奇怪的法杖，玻璃的杖端后面拖着一道绿雾。%SPEECH_ON%欢迎！想了解一下我的事业吗？下到蠕虫上到飞鸟，都是在母爱的温暖中，得到了原始的本能，觉醒了智慧的闪光，你懂吗，没有了母爱，人类何谈成为万物灵长。我，一个男人，现在是母亲了！我，一个男人，打破了自然的桎梏，以及所有生灵的本能，我会成为无巢之母，凌驾于自然母亲的架构之上，成为万物的哺育者！我，大先知！将用我的造物滋润这片干涸的大地……%SPEECH_OFF%喋喋不休的疯子和奇怪的法杖，一看就知道准没有好事。你抽出了剑，大先知见状闭嘴。轻轻低下头颅，张开双臂，法杖里闪出绿色的光芒。你之前见过的怪物，那些黏糊，肿胀，肢体乱七八糟的东西纷纷从雕像后面冒了出来。围住你的战团还不够，更多的占据了高处，靠在悬崖的边缘上，好似斗兽场的观众，准备看一场好戏。大先知微笑着把法杖指向了你。%SPEECH_ON%笑笑吧，佣兵，等你死了，我会重新把你孕育，带回这个世界，让你在我权柄的怀抱里得到滋养！%SPEECH_OFF%}",
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

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_182.png[/img]{大先知身负重伤，躺倒在自己造物的血污当中。他的头盔遮住了脖颈，但你只是蹲下，像是撬桶盖一样，轻易把剑插进头盔底下。他咳出一口血沫。%SPEECH_ON%你杀不死我的，你杀不死自然母亲。%SPEECH_OFF%你点头，把剑从他的下巴插入，直到听到剑尖撞到头盔顶的声音才停止。鲜血从护颈里流了出来。你起身说道，%SPEECH_ON%我就是自然母亲。%SPEECH_OFF%%randombrother%笑了。%SPEECH_ON%说得好，队长。但细想想好像又有点蠢 —%SPEECH_OFF%你打断了他，让你的手下好好搜刮一下这个地方，他也不例外。这么一座哥特庄园肯定会让你不虚此行。至于大先知那闪着绿光的法杖，一并收进库存。正当你打算离开的时候，一群“血肉魔像”逃出了这座哥特庄园，跑到了荒野之中。造物者虽然已死，但你或许还能遇到他的造物。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "至少我们干掉了最凶残的那个。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "战斗之后……";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/weapons/legendary/miasma_flail");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_182.png[/img]{眼看就要输掉这场战斗，你决定及时止损 —  毕竟看起来对于大先知来说，死亡还只算是开始。不顾投入在这，你下令突围，撤出这里。血肉魔像像是不悦的斗兽场观众一样，含混不清地嘲弄着你。\n\n大先知笑得直咳嗽，他站在原地，直至融入到背景之中。一缕绿雾飘来，凝成狞笑形状的嘴，这缕绿雾最终消散，而你们也离开了这个地方。重返此地绝非易事，但除掉这疯子的执念已在你的心底扎了根。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "也许杀了他才能把他赶出我们的梦境。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "战斗之后……";
				this.World.Statistics.getFlags().set("ReliquaryFightDefeated", true);

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
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
		properties.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
		properties.CombatID = "ArtifactReliquary";
		properties.TerrainTemplate = "tactical.golems";
		properties.LocationTemplate.Template[0] = "tactical.golems_lair";
		properties.Music = this.Const.Music.UndeadTracks;
		properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
		properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
		properties.IsFleeingProhibited = true;
		properties.IsWithoutAmbience = true;
		properties.IsFogOfWarVisible = false;
		properties.Parties.push(_location);
		properties.Entities = [];
		local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID();
		properties.BeforeDeploymentCallback = function ()
		{
			local sorcerers = [];
			local greaterGolems = [];
			local entity;
			entity = _event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/grand_diviner", f, 16, 18, 10, 14, 0, true, sorcerers);

			if (entity != null)
			{
				sorcerers.push(entity);
			}

			for( local i = 0; i < 4; i = ++i )
			{
				entity = _event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", f, 18, 21, 6, 24, 0, true, sorcerers);

				if (entity != null)
				{
					sorcerers.push(entity);
				}
			}

			for( local i = 0; i < 4; i = ++i )
			{
				_event.spawnGuardEntity("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed_bodyguard", f, sorcerers);
			}

			for( local i = 0; i < 3; i = ++i )
			{
				entity = _event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/greater_flesh_golem", f, 15, 17, 6, 24, i + 1, true, greaterGolems);

				if (entity != null)
				{
					greaterGolems.push(entity);
				}
			}
		};
		properties.AfterDeploymentCallback = function ()
		{
			local playersAndFleshCradles = [];
			local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

			foreach( bro in brothers )
			{
				playersAndFleshCradles.push(bro);
			}

			local entity;

			for( local i = 0; i < 10; i = ++i )
			{
				entity = _event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/flesh_cradle", f, 4, 24, 4, 24, 0, true, playersAndFleshCradles);

				if (entity != null)
				{
					playersAndFleshCradles.push(entity);
				}
			}

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

	function spawnEntityWithinBounds( _entity, _faction, _xLower, _xUpper, _yLower, _yUpper, _useVariant = 0, _avoidEntities = false, _entitiesToAvoid = [], _maxAttempts = 500 )
	{
		local attempts = 0;
		local entity;

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
				if (_avoidEntities)
				{
					local scrapTile = false;

					foreach( entityToAvoid in _entitiesToAvoid )
					{
						if (tile.getDistanceTo(entityToAvoid.getTile()) < 3)
						{
							scrapTile = true;
							break;
						}
					}

					if (scrapTile)
					{
						  // [050]  OP_JMP            0     21    0    0
					}
				}

				entity = this.Tactical.spawnEntity(_entity, tile.Coords);
				entity.setFaction(_faction);
				entity.assignRandomEquipment();

				if (_useVariant > 0)
				{
					entity.setVariant(_useVariant);
				}
			}
		}
		while (entity == null && attempts <= _maxAttempts);

		return entity;
	}

	function spawnGuardEntity( _guardEntity, _guardFaction, _wards, _maxAttempts = 500 )
	{
		local attempts = 0;
		local entity;

		do
		{
			attempts++;
			local entityToProtect;
			local tile;

			foreach( ward in _wards )
			{
				if (ward.getType() != this.Const.EntityType.FaultFinder)
				{
					continue;
				}

				local alreadyHasGuard = false;

				for( local i = 0; i < this.Const.Direction.COUNT; i = ++i )
				{
					if (!ward.getTile().hasNextTile(i))
					{
					}
					else
					{
						local nextTile = ward.getTile().getNextTile(i);

						if (nextTile.IsEmpty)
						{
						}
						else if (nextTile.IsOccupiedByActor && nextTile.getEntity().getType() == this.Const.EntityType.LesserFleshGolem)
						{
							alreadyHasGuard = true;
							break;
						}
					}
				}

				if (alreadyHasGuard)
				{
					continue;
				}

				entityToProtect = ward;
			}

			if (entityToProtect == null)
			{
			}
			else
			{
				for( local i = this.Const.Direction.COUNT - 1; i >= 0; i = --i )
				{
					if (!entityToProtect.getTile().hasNextTile(i))
					{
					}
					else
					{
						local nextTile = entityToProtect.getTile().getNextTile(i);

						if (nextTile.IsEmpty)
						{
							tile = nextTile;
							break;
						}
					}
				}

				entity = this.Tactical.spawnEntity(_guardEntity, tile.Coords);
				entity.setFaction(_guardFaction);
				entity.assignRandomEquipment();
			}
		}
		while (entity == null && attempts <= _maxAttempts);

		return entity;
	}

});
