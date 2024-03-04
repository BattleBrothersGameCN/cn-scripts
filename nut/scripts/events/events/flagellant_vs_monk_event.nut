this.flagellant_vs_monk_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null,
		Flagellant = null
	},
	function create()
	{
		this.m.ID = "event.flagellant_vs_monk";
		this.m.Title = "露营时……";
		this.m.Cooldown = 45.000000 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]营火闪耀着耀眼的光芒，将人们的面庞扭曲成橙色，仿佛他们自己就是燃烧着的木头。\n\n 在这里，你发现 %monk% 和 %flagellant% 在谈着什么。起初，他们的讨论并不复杂。 僧侣恳求自笞者不再挥鞭。 虽然你没必要介入，但你不得不承认，用一种被美化的仪式摧残自己的身体并不是最好的活法。 但紧接着自笞者反驳的话，让你们两个人停了下来。 这段话语经过精心设计，如果你不把它忘掉，恐怕就会越来越认同自笞者的想法。 更让人不安的是，这家伙说地如此的轻描淡写。 一具伤痕累累的躯壳里竟然能温暖地编织出这么抚慰人心的声音。 是什么造就了它？\n\n 这个僧侣结结巴巴地说了一会儿，然后把手放到了自笞者的肩膀上，按着他，让他们互相对视。 他轻声细语，这些话会让你耳朵发痒，但你并不能听清其中的意思。 你只能假设，它们的目的是，再次说服苦修者过上更好，不那么暴力的生活。\n\n 但是，再一次的，苦修者开始回应，然后他们继续你来我往地辩论起来。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "真有趣。咱们看看接下来会发生什么。",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "好了，你们闹够了吧。我们有很多实际的事要做。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]决定让他俩继续讨论，你走开了一段时间。 当你回来的时候，你发现苦修者坐在僧侣旁边。 两个人在一根圆木上来回地看了看，双手合十，祈祷着，神圣的低语，从他们的嘴唇里冒了出来。 你没有必要去听他们在说什么，因为这本身就是一个令人欣慰的景象。 你并不知道什么是安抚众神最好的方式，但你会不由自主地感到一丝欣慰，因为苦修者放下了折磨自己的工具。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "愿这人找到自己的宁静。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local background = this.new("scripts/skills/backgrounds/pacified_flagellant_background");
				_event.m.Flagellant.getSkills().removeByID("background.flagellant");
				_event.m.Flagellant.getSkills().add(background);
				_event.m.Flagellant.m.Background = background;
				background.buildDescription();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Flagellant.getName() + "现在是一个被安抚的自笞者"
					}
				];
				_event.m.Monk.getBaseProperties().Bravery += 2;
				_event.m.Monk.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk.getName() + " 获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] 决心"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]决定让他俩继续讨论，你走开了一段时间。\n\n你回来的时候，僧侣光着身子，弯下腰，眼里含着泪水。 他的身体胆怯的发抖，但他的面色坚毅，仿佛这就是他想要的。 他吸了一口气，直起身子，把手腕甩过肩膀。 只见他手里握着的自笞者的鞭子，只听到皮鞭打在僧侣背上的声音。 他拉动鞭子，鞭刃和倒刺撕裂血肉的声音在你耳中回响。 苦修者什么也没说，只是在僧侣的旁边坐了下来。 他凝视着大地，眼里没有一丝生命的微光，但你确确实实看到了随着每次鞭打，他背部流出的充满生命的血液。\n\n你又一次离开，但脚下的草地少了嘎吱嘎吱的声响，空气中却多了一股金属的味道。你走回帐篷的路上，皮鞭的声音还在继续。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "一个自虐者会发现恐怖的真谛。",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local background = this.new("scripts/skills/backgrounds/monk_turned_flagellant_background");
				_event.m.Monk.getSkills().removeByID("background.monk");
				_event.m.Monk.getSkills().add(background);
				_event.m.Monk.m.Background = background;
				background.buildDescription();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Monk.getName() + "现在是从僧侣转变为的自笞者"
					}
				];
				_event.m.Flagellant.getBaseProperties().Bravery += 2;
				_event.m.Flagellant.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Flagellant.getName() + " 获得了 [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] 决心"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local flagellant_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.flagellant")
			{
				flagellant_candidates.push(bro);
			}
		}

		if (flagellant_candidates.len() == 0)
		{
			return;
		}

		local monk_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				monk_candidates.push(bro);
			}
		}

		if (monk_candidates.len() == 0)
		{
			return;
		}

		this.m.Flagellant = flagellant_candidates[this.Math.rand(0, flagellant_candidates.len() - 1)];
		this.m.Monk = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk.getName()
		]);
		_vars.push([
			"flagellant",
			this.m.Flagellant.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Monk = null;
		this.m.Flagellant = null;
	}

});
