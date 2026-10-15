this.rf_oathtakers_take_oaths_in_regular_origins_event <- ::inherit("scripts/events/event", {
	m = {
		TriggerEveryXDays = 15,
		Oathtakers = [],
		__PotentialOaths = null
	},
	function create()
	{
		this.m.__PotentialOaths = ::MSU.Class.WeightedContainer();

		foreach( path in ::IO.enumerateFiles("scripts/skills/traits") )
		{
			if (this.split(path, "/").top().find("oath_of") != null)
			{
				this.m.__PotentialOaths.add(path);
			}
		}

		this.m.ID = "event.rf_oathtakers_take_oaths_in_regular_origins";
		this.m.IsSpecial = true;
		this.m.Title = "改换誓言";
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Oathtakers.len() == 1)
				{
					this.Text = "[img]gfx/ui/events/event_183.png[/img]{天还没亮，你便瞥见%bro1%立于营地最远的边缘，那里营火渐暗，雾气低垂。他孤身一人，穿好盔甲一动不动的站在那里，似乎在等待只有他能听到的审判。\n\n他缓慢而郑重地跪在地上。没有祈祷，也没有低语，只有当他将一个小物件放在地上时，铁护手摩擦地面的声音。那是一枚摩挲薄了的铁符，你曾看他在战斗之后碰过它，似乎是要确认这枚被他赋予了某种重量的铁符是否还在。而现在，他毫不犹豫的将其留在了这里，似乎它已经完成了使命。\n\n随后，他从腰带上的小包里掏出了另一件东西，光线昏暗，你并不能看清那具体是什么。或许是刻着什么的木片，又或是结起来的布条。他把它绑在盔甲上，那动作既不虔诚，也不草率，倒像是士兵在战前系好他的装束，坦然接受随之而来的重负。\n\n他终于起身，脸上波澜不惊。但身姿中却透出一种微妙的变化，要不是你和他并肩战斗了这么久，恐怕你也很难察觉得到。那是一种新的紧绷，新的沉静，新的决绝。这名执誓者已经卸下了旧的誓言，将新的誓言承在了肩头。无论他在这个寒夜中究竟宣誓了什么，都会深刻地影响到未来的战斗，不仅关乎他自己，也关乎整个战团。}";
					this.Options[0].Text = "我可不指望能参透他。";
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_183.png[/img]{你在夜深人静时醒来，耳边传来低沉的窸窣声。铠甲轻响，靴子擦过泥土，还有那些刻意压低声响、生怕惊醒营地的士兵们发出的微弱碰撞。执誓者们已经醒了，他们总是比其他佣兵兄弟们醒得早得多。\n\n他们在营地的角落紧紧围成圆环，更像是准备接受惩戒，而非是某种仪式。他们把头埋得很深。你也不是没见过这样的情景，但你还是搞不清，他们到底是在忏悔，还是仅仅是作为士兵，冷静地检查着自己的装备。或许对于执誓者来说，这两件事并没有什么两样吧。\n\n过了一会，%bro1%拿出一个小物件，一个被汗水和时间磨穿了的铁符，把它丢在地上。%bro2%放下一条沾染了干涸血迹的布带，也不知道上面的血是不是他的。这是他们过去所担负的各种誓言的残余：背负过的负担，完成过的任务，打破了或是完成了的誓言。从他们抛弃遗物的方式当中，你并不能看出是哪一种。\n\n只见%bro1%从身上取出一件新的信物，其他人则有的在盾牌上刻下新的刻痕，有的将绳索缠绕在手腕上。%bro2%则用一枚钉子穿起一块皮革，牢牢钉在自己的胸甲上，仿佛将一份判决书亲手钉在胸口。这些动作所承载的深意与你无关，你只知道，新的誓言已经被立下。\n\n圆环解散的时候，众人返回各自的位置，步伐中透出一种近乎冷酷的决心。他们的面容带着一种冷漠的平静——那是明知自己必将流血，却决心让每一滴血都流得有意义的人才有的神情。无论他们所佩戴的东西象征什么，他们都以一种笃信的姿态将其背负，仿佛相信整个世界都会因他们的选择而改变轨迹。\n\n你只觉得这场仪式的重量，就像是低洼田野里缓缓升起的雾气，刚开始无声无息，却逐渐笼罩了整个营地。无论他们在这个寒夜中究竟宣誓了什么，都会深刻地影响到未来的战斗，不仅关乎他们自己，也关乎整个战团。}";
					this.Options[0].Text = "我可不指望能参透他们。";
				}

				this.List = [];

				foreach( bro in _event.m.Oathtakers )
				{
					local currentOath;
					local currentOathScript;

					foreach( s in bro.getSkills().m.Skills )
					{
						if (!s.isType(::Const.SkillType.Trait))
						{
							continue;
						}

						local script = ::IO.scriptFilenameByHash(s.ClassNameHash);

						if (_event.m.__PotentialOaths.contains(script))
						{
							currentOathScript = script;
							currentOath = s;
							break;
						}
					}

					if (currentOath != null)
					{
						bro.getSkills().remove(currentOath);
					}

					local newOath = ::new(_event.m.__PotentialOaths.roll(currentOathScript == null ? null : [
						currentOathScript
					]));
					bro.getSkills().add(newOath);
					this.List.push({
						id = 16,
						icon = newOath.getIcon(),
						text = this.format("%s%s%s", bro.getName(), currentOath != null ? "完成了" + currentOath.getName() + "并" : "", "立下了" + newOath.getName())
					});
				}
			}

		});
	}

	function isValid()
	{
		if (::World.Assets.getOrigin().getID() == "scenario.paladins")
		{
			return false;
		}

		local currentDay = ::World.getTime().Days;

		if (currentDay % this.m.TriggerEveryXDays != 0)
		{
			return false;
		}

		local flagID = this.m.ID + "_LastDay";

		if (::World.Flags.has(flagID) && currentDay == ::World.Flags.get(flagID))
		{
			return false;
		}

		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				::World.Flags.set(flagID, currentDay);
				return true;
			}
		}

		return false;
	}

	function onPrepare()
	{
		this.m.Oathtakers = ::World.getPlayerRoster().getAll().filter(function ( _, _bro )
		{
			return _bro.getBackground().getID() == "background.paladin";
		});
	}

	function onPrepareVariables( _vars )
	{
		local bros = clone this.m.Oathtakers;
		_vars.push([
			"bro1",
			bros.remove(::Math.rand(0, bros.len() - 1)).getName()
		]);

		if (bros.len() != 0)
		{
			_vars.push([
				"bro2",
				bros.remove(::Math.rand(0, bros.len() - 1)).getName()
			]);
		}
	}

	function onClear()
	{
		this.m.Oathtakers.clear();
	}

});
