this.apprentice_learns_event <- this.inherit("scripts/events/event", {
	m = {
		Apprentice = null,
		Teacher = null
	},
	function create()
	{
		this.m.ID = "event.apprentice_learns";
		this.m.Title = "露营时……";
		this.m.Cooldown = 90.000000 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]学徒%apprentice%成了%teacher%的小拐杖。而剑术大师的年龄并没有影响他提携新人的热情。学徒使用真剑，剑术大师则只用一把木剑。即便在这样巨大的武器差异下，剑术大师依然展现出了对定位，抓破绽和脱离危险技巧的运用。\n\n他年事已高，却还能不停地闪转腾挪，使得学徒无法命中。这招尤其精妙，剑术大师察觉到自己要被击中，迈步上前，踩住了学徒的脚。学徒后退给自己腾出空间，脚步却不能跟上。突然的失衡让他跌倒在地，回过头来，一把木剑已经架在了他的脖子上。\n\n这小子总是弄得灰头土脸，但至少他没有放弃。姑且说他是水滴石穿好了。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "很出色！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Teacher.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				local meleeDefense = this.Math.rand(2, 4);
				_event.m.Apprentice.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Apprentice.getBaseProperties().MeleeDefense += meleeDefense;
				_event.m.Apprentice.getSkills().update();
				_event.markAsLearned();
				_event.m.Apprentice.improveMood(1.000000, "投师" + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(0.500000, "教授了" + _event.m.Apprentice.getName() + "一些东西");
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.Apprentice.getName() + " 获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color]点近战技能"
					},
					{
						id = 17,
						icon = "ui/icons/melee_defense.png",
						text = _event.m.Apprentice.getName() + " 获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeDefense + "[/color]点近战防御"
					}
				];

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]重操旧业的退役士兵%teacher%垂青于%apprentice%，他俩一有机会就在练习武艺。 老战士深信攻击就是最好的防御，教授学徒使用各类武器时伤害最大化的方法。美中不足的是，他们把战团的餐具当成了训练对象。小伙子精进武艺的路上，锅碗瓢盆注定先要遭殃。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "很出色！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Teacher.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				local resolve = this.Math.rand(2, 5);
				_event.m.Apprentice.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Apprentice.getBaseProperties().Bravery += resolve;
				_event.m.Apprentice.getSkills().update();
				_event.markAsLearned();
				_event.m.Apprentice.improveMood(1.000000, "投师" + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(0.250000, "教授了" + _event.m.Apprentice.getName() + "一些东西");
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.Apprentice.getName() + " 获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color]点近战技能"
					},
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Apprentice.getName() + " 获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color]点决心"
					}
				];

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]年轻的%apprentice%成了老佣兵%teacher%的小跟班。为了在战团里挣到血汗钱，学徒注定要和经验丰富的老人学习。训练中，佣兵更强调身体的锻炼。比你的对手更快更持久，和把利刃戳进他的脑壳同样重要。这个认真的小伙子越来越结实了，比以往都要更有活力。",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "很出色！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Teacher.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				local initiative = this.Math.rand(4, 6);
				local stamina = this.Math.rand(2, 4);
				_event.m.Apprentice.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Apprentice.getBaseProperties().Initiative += initiative;
				_event.m.Apprentice.getBaseProperties().Stamina += stamina;
				_event.m.Apprentice.getSkills().update();
				_event.markAsLearned();
				_event.m.Apprentice.improveMood(1.000000, "投师" + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(0.250000, "教授了" + _event.m.Apprentice.getName() + "一些东西");
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.Apprentice.getName() + " 获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color]点近战技能"
					},
					{
						id = 17,
						icon = "ui/icons/initiative.png",
						text = _event.m.Apprentice.getName() + " 获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color]主动值"
					},
					{
						id = 17,
						icon = "ui/icons/fatigue.png",
						text = _event.m.Apprentice.getName() + " 获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color]点最大疲劳值"
					}
				];

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]你曾多次看到，%apprentice%远远地望着%teacher%。年轻的学徒似乎为雇佣骑士的暴力美学所折服。几天后，骑士松口了，让小伙子过来和他聊聊。你不知道他们说了什么，但他们已经在一起训练。 雇佣骑士可不是个慈祥的教官，他经常暴打那个男孩，让他坚强起来。起初，每次训练前，学徒都会退缩，但现在，面对如此巨大的逆境，他表现出了更强的决心。雇佣骑士也传授了快速有效杀人的技巧。在你无意听到的谈话中，防御方面的内容很少被提及，不过谁需要防御一个死掉的对手呢？",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "很出色！",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Teacher.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				local hitpoints = this.Math.rand(3, 5);
				local stamina = this.Math.rand(3, 5);
				_event.m.Apprentice.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Apprentice.getBaseProperties().Hitpoints += hitpoints;
				_event.m.Apprentice.getBaseProperties().Stamina += stamina;
				_event.m.Apprentice.getSkills().update();
				_event.markAsLearned();
				_event.m.Apprentice.improveMood(1.000000, "投师" + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(0.250000, "教授了" + _event.m.Apprentice.getName() + "一些东西");
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.Apprentice.getName() + " 获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color]点近战技能"
					},
					{
						id = 17,
						icon = "ui/icons/health.png",
						text = _event.m.Apprentice.getName() + " 获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + hitpoints + "[/color]点生命值"
					},
					{
						id = 17,
						icon = "ui/icons/fatigue.png",
						text = _event.m.Apprentice.getName() + " 获得了[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color]点最大疲劳值"
					}
				];

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
	}

	function markAsLearned()
	{
		this.m.Apprentice.getFlags().add("learned");
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local apprentice_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() > 3 && bro.getBackground().getID() == "background.apprentice" && !bro.getFlags().has("learned"))
			{
				apprentice_candidates.push(bro);
			}
		}

		if (apprentice_candidates.len() < 1)
		{
			return;
		}

		local teacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 6)
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.swordmaster" || bro.getBackground().getID() == "background.old_swordmaster" || bro.getBackground().getID() == "background.retired_soldier" || bro.getBackground().getID() == "background.hedgeknight" || bro.getBackground().getID() == "background.sellsword")
			{
				teacher_candidates.push(bro);
			}
		}

		if (teacher_candidates.len() < 1)
		{
			return;
		}

		this.m.Apprentice = apprentice_candidates[this.Math.rand(0, apprentice_candidates.len() - 1)];
		this.m.Teacher = teacher_candidates[this.Math.rand(0, teacher_candidates.len() - 1)];
		this.m.Score = (apprentice_candidates.len() + teacher_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"apprentice",
			this.m.Apprentice.getNameOnly()
		]);
		_vars.push([
			"teacher",
			this.m.Teacher.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.m.Teacher.getBackground().getID() == "background.swordmaster" || this.m.Teacher.getBackground().getID() == "background.old_swordmaster")
		{
			return "A";
		}
		else if (this.m.Teacher.getBackground().getID() == "background.retired_soldier")
		{
			return "B";
		}
		else if (this.m.Teacher.getBackground().getID() == "background.sellsword")
		{
			return "C";
		}
		else
		{
			return "D";
		}
	}

	function onClear()
	{
		this.m.Apprentice = null;
		this.m.Teacher = null;
	}

});
