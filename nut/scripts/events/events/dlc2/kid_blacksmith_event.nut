this.kid_blacksmith_event <- this.inherit("scripts/events/event", {
	m = {
		Juggler = null,
		Apprentice = null,
		Killer = null,
		Other = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.kid_blacksmith";
		this.m.Title = "在%townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{你正在%townname%的商店间闲逛，忽觉有人在扯你的袖子。转过身来，只见一个孩子，脸上抹得黢黑，两只白亮的眼睛直愣愣地看着你。他问你懂不懂剑。你指了指你腰间的剑鞘。他拍着手说道。%SPEECH_ON%太好了！我为那边的一位铁匠工作，但他去取铁锭了。他要我看守这把特别的剑，但它，嗯，它掉下来了。然后就断了。它自己掉下来，自己断的。你能帮我把它修好吗？%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "来个人帮帮这个孩子。",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 70)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Juggler != null)
				{
					this.Options.push({
						Text = "看来%juggler%想帮帮你。",
						function getResult( _event )
						{
							return "Juggler";
						}

					});
				}

				if (_event.m.Apprentice != null)
				{
					this.Options.push({
						Text = "看来%apprentice%想帮帮你。",
						function getResult( _event )
						{
							return "Apprentice";
						}

					});
				}

				if (_event.m.Killer != null)
				{
					this.Options.push({
						Text = "看来%killer%想帮帮你。",
						function getResult( _event )
						{
							return "Killer";
						}

					});
				}

				this.Options.push({
					Text = "不行，臭小子赶紧走。",
					function getResult( _event )
					{
						return "No";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "No",
			Text = "[img]gfx/ui/events/event_97.png[/img]{你让那个孩子滚开。他十有八九是个骗子。说到这里，你检查了一下自己的口袋，确保里面的东西都还在。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "太好了，什么都没丢。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_97.png[/img]{%other%被你派去给孩子帮忙。他帮着把剑柄和剑刃组合在一起，那孩子仅凭自己的本事就轻松地把剑修好了。你惊叹于他的技艺，连他这个徒弟都这么厉害，他的师父得有多大的能耐。一切处理妥当之后，那孩子提出可以帮%companyname%修修武器，你欣然接受了。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "干得好！",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local stash = this.World.Assets.getStash().getItems();
				local items = 0;

				foreach( item in stash )
				{
					if (item != null && item.isItemType(this.Const.Items.ItemType.Weapon) && item.getCondition() < item.getConditionMax())
					{
						item.setCondition(item.getConditionMax());
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "你的" + item.getName() + "被修好了"
						});
						items = ++items;

						if (items > 3)
						{
							break;
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_97.png[/img]{%other%听到你要让他帮忙，叹了口气。他懒洋洋地走到铁砧前，那砧板长得像一颗大牙，架在细细的铁架子上。铁匠的东西就挂在一面旧铁栏杆改成的专门的墙上，支架向外弯曲，以便更好地固定住要加工的东西。孩子拍了拍手。%SPEECH_ON%不要到处乱碰，帮我修好这个就行了。%SPEECH_OFF%%other%摸不着头脑地转了一圈，把铁砧的腿儿给踢倒了。铁砧眼看就要歪倒，孩子赶紧跑过去扶住它，只希望今天能别再惹上别的麻烦了。巨大的重量把孩子拍扁在了卵石路上，他四脚朝天，就像是一只被拇指压扁的蟋蟀。你从远处看到了这一切，赶紧示意雇佣兵回来，免得惹上麻烦。趁着刚刚开始有人注意，他赶紧溜走了。他耸了耸肩说。%SPEECH_ON%我们没做错什么，对吧、长官？%SPEECH_OFF%你点了点头。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "看来你得低调一段时间了。",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.worsenMood(1.5, "不小心弄残了个小男孩");

				if (_event.m.Other.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Juggler",
			Text = "[img]gfx/ui/events/event_97.png[/img]{你怀疑那耍杂技的并不是真的打算去帮那孩子的忙，你看到他将匕首和斧头扔向空中，人们欢声雀跃起来。看到人群聚拢过来，他把帽子放在卵石路上，继续着他的表演。他们投了很多硬币，等到他做出了空接五个棒子的终极表演时，现场的掌声更是震耳欲聋。他欠身鞠躬，拿起了帽子，匆匆忙忙地走了回来。%SPEECH_ON%我干的不错吧，长官？%SPEECH_OFF%你点点头，问起那个男孩断掉的剑。他擦了擦额头上的汗水。%SPEECH_ON%什么，长官？你说让我归队吗？是，长官，我马上归队。%SPEECH_OFF%你撅起了嘴唇，向铁匠铺看去，那小男孩正趴在一块铁砧上，被刚回来的铁匠抽得噼啪作响。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "真是场精彩的表演。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				_event.m.Juggler.improveMood(1.0, "沉浸在人群的赞美当中");

				if (_event.m.Juggler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}

				local money = this.Math.rand(10, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "你获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color]克朗"
				});
			}

		});
		this.m.Screens.push({
			ID = "Apprentice",
			Text = "[img]gfx/ui/events/event_97.png[/img]{年轻的学徒%apprentice%被派去给那孩子帮忙。他慢悠悠地走到铁匠台前，开始用他的方法帮助这个孩子。他所做的远超过了帮忙的程度：他用一种比当初还要结实的方法把剑重新拼合了起来。铁匠回来后发现了这件作品，几乎是哀求着，想知道背后的奥秘。%apprentice%笑着说。%SPEECH_ON%你把这把剑给我，我就把师父传给我的秘诀告诉你。%SPEECH_OFF%连你都不知道这学徒还掌握了这种学问，这家伙可真是一块行走的海绵。和铁匠的交易完成后，双方皆大欢喜地离开了。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "我还以为你是专门研究编篮子的呢。",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				_event.m.Apprentice.improveMood(1.0, "得以发挥了他的铁匠技术");

				if (_event.m.Apprentice.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}

				local item = this.new("scripts/items/weapons/arming_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Killer",
			Text = "[img]gfx/ui/events/event_97.png[/img]{你让杀人犯%killer%去帮帮这个孩子。这人笑着答应了，那孩子却直觉似的感到不舒服。他往后退了几步，挥手示意自己不需要帮忙了。%SPEECH_ON%不用了先生，我没问题的。谢……谢谢你。毕竟，男子汉要学会自己承担责任，对吧？%SPEECH_OFF%杀人犯微笑着蹲了下来，把手指按在了孩子的脸颊上。%SPEECH_ON%对，孩子，没错。男子汉会做好自己分内的事。%SPEECH_OFF%你觉得有些过了，让%killer%去清点库存。他摸了摸孩子的头，起身离开了。孩子赶快跑走了，又拿着一把匕首跑了回来。%SPEECH_ON%请，收下这个吧。不要让这个家伙再靠近我了，先生。说好了？我不想再跟他打交道，哪怕现在就挨铁匠抽也不要见到他了。你收下武器，不要让他靠近我。成交？成交了，对吧？收下它吧！%SPEECH_OFF%你觉得这个孩子似乎是第一次进行这种交易，或者说这是他第一次觉得自己的生命受到了威胁。无论如何，你收下了匕首。孩子松了一口气，回到锻炉前继续工作，时不时的观察着周围。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "你杀死了他的童心，%killer%。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Killer.getImagePath());
				local item = this.new("scripts/items/weapons/rondel_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "你获得了" + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_other = [];
		local candidates_juggler = [];
		local candidates_apprentice = [];
		local candidates_killer = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.juggler")
			{
				candidates_juggler.push(b);
			}
			else if (b.getBackground().getID() == "background.apprentice")
			{
				candidates_apprentice.push(b);
			}
			else if (b.getBackground().getID() == "background.killer_on_the_run")
			{
				candidates_killer.push(b);
			}
			else
			{
				candidates_other.push(b);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_juggler.len() != 0)
		{
			this.m.Juggler = candidates_juggler[this.Math.rand(0, candidates_juggler.len() - 1)];
		}

		if (candidates_apprentice.len() != 0)
		{
			this.m.Apprentice = candidates_apprentice[this.Math.rand(0, candidates_apprentice.len() - 1)];
		}

		if (candidates_killer.len() != 0)
		{
			this.m.Killer = candidates_killer[this.Math.rand(0, candidates_killer.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"other",
			this.m.Other.getName()
		]);
		_vars.push([
			"juggler",
			this.m.Juggler != null ? this.m.Juggler.getName() : ""
		]);
		_vars.push([
			"apprentice",
			this.m.Apprentice != null ? this.m.Apprentice.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Juggler = null;
		this.m.Apprentice = null;
		this.m.Killer = null;
		this.m.Other = null;
		this.m.Town = null;
	}

});
