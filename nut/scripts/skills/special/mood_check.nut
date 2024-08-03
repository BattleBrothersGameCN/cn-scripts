this.mood_check <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.mood_check";
		this.m.Name = "情绪检定";
		this.m.Icon = "skills/status_effect_02.png";
		this.m.IconMini = "";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.Trait;
		this.m.Order = this.Const.SkillOrder.Trait + 600;
		this.m.IsActive = false;
		this.m.IsHidden = false;
		this.m.IsSerialized = false;
		this.m.IsStacking = true;
	}

	function getTooltip()
	{
		local ret;

		switch(this.getContainer().getActor().getMoodState())
		{
		case this.Const.MoodState.Neutral:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "这名角色满足于现状。情绪还能提升，也还有恶化的空间。\n\n情绪总会随时间逐渐回归这种状态。"
				}
			];
			break;

		case this.Const.MoodState.Concerned:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "这名角色不算满意，希望事情能有所改善 —— 这对过着艰苦佣兵生活的人来说并不罕见。"
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = "只能拥有[color=" + this.Const.UI.Color.NegativeValue + "]稳定[/color]或更糟士气"
				}
			];
			break;

		case this.Const.MoodState.Disgruntled:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "最近的事件让这名角色对现状感到失望和不满。这种心情可能会消散，也可能因其他事件而雪上加霜。"
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = "只能拥有[color=" + this.Const.UI.Color.NegativeValue + "]动摇[/color]或更糟士气"
				}
			];
			break;

		case this.Const.MoodState.Angry:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "最近的事件让这名角色对周围的人感到愤怒，意图报复。如果情况没有很快改善，该角色可能会决定离开战团！"
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = "只能拥有[color=" + this.Const.UI.Color.NegativeValue + "]崩溃[/color]或更糟士气"
				}
			];
			break;

		case this.Const.MoodState.InGoodSpirit:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "最近的事件使这名角色心情愉快。这种情绪或许会因现实掣肘而消失，但就目前而言，情况还不错。"
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = "有 [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color]几率以自信士气开始战斗"
				}
			];
			break;

		case this.Const.MoodState.Eager:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "最近的事件让这名角色渴望为战团而战，对现状感到高兴，激励着他周围的人。"
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = "有 [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color]几率以自信士气开始战斗"
				}
			];
			break;

		case this.Const.MoodState.Euphoric:
			ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "最近的事件使这名角色处于一种兴奋状态，他为把时间花在战团里感到高兴，确信能战胜任何敌人。说真的，这样有点烦人。"
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = "有 [color=" + this.Const.UI.Color.PositiveValue + "]75%[/color]几率以自信士气开始战斗"
				}
			];
			break;
		}

		local changes = this.getContainer().getActor().getMoodChanges();

		foreach( change in changes )
		{
			if (change.Positive)
			{
				ret.push({
					id = 11,
					type = "hint",
					icon = "ui/tooltips/positive.png",
					text = "" + change.Text + ""
				});
			}
			else
			{
				ret.push({
					id = 11,
					type = "hint",
					icon = "ui/tooltips/negative.png",
					text = "" + change.Text + ""
				});
			}
		}

		return ret;
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();
		local mood = actor.getMoodState();
		local morale = actor.getMoraleState();
		local isDastard = this.getContainer().hasSkill("trait.dastard");

		switch(mood)
		{
		case this.Const.MoodState.Concerned:
			actor.setMaxMoraleState(this.Const.MoraleState.Steady);
			actor.setMoraleState(this.Const.MoraleState.Steady);
			break;

		case this.Const.MoodState.Disgruntled:
			actor.setMaxMoraleState(this.Const.MoraleState.Wavering);
			actor.setMoraleState(this.Const.MoraleState.Wavering);
			break;

		case this.Const.MoodState.Angry:
			actor.setMaxMoraleState(this.Const.MoraleState.Breaking);
			actor.setMoraleState(this.Const.MoraleState.Breaking);
			break;

		case this.Const.MoodState.Neutral:
			actor.setMaxMoraleState(this.Const.MoraleState.Confident);
			break;

		case this.Const.MoodState.InGoodSpirit:
			actor.setMaxMoraleState(this.Const.MoraleState.Confident);

			if (morale < this.Const.MoraleState.Confident && this.Math.rand(1, 100) <= 25 && !isDastard)
			{
				actor.setMoraleState(this.Const.MoraleState.Confident);
			}

			break;

		case this.Const.MoodState.Eager:
			actor.setMaxMoraleState(this.Const.MoraleState.Confident);

			if (morale < this.Const.MoraleState.Confident && this.Math.rand(1, 100) <= 50 && !isDastard)
			{
				actor.setMoraleState(this.Const.MoraleState.Confident);
			}

			break;

		case this.Const.MoodState.Euphoric:
			actor.setMaxMoraleState(this.Const.MoraleState.Confident);

			if (morale < this.Const.MoraleState.Confident && this.Math.rand(1, 100) <= 75 && !isDastard)
			{
				actor.setMoraleState(this.Const.MoraleState.Confident);
			}

			break;
		}
	}

	function onUpdate( _properties )
	{
		local mood = this.getContainer().getActor().getMoodState();
		local p = this.Math.round(this.getContainer().getActor().getMood() / (this.Const.MoodState.len() - 0.05) * 100.0);
		this.m.Name = this.Const.MoodStateName[mood] + " (" + p + "%)";

		switch(mood)
		{
		case this.Const.MoodState.Neutral:
			this.m.Icon = "skills/status_effect_64.png";
			break;

		case this.Const.MoodState.Concerned:
			this.m.Icon = "skills/status_effect_46.png";
			break;

		case this.Const.MoodState.Disgruntled:
			this.m.Icon = "skills/status_effect_45.png";
			break;

		case this.Const.MoodState.Angry:
			this.m.Icon = "skills/status_effect_44.png";
			break;

		case this.Const.MoodState.InGoodSpirit:
			this.m.Icon = "skills/status_effect_47.png";
			break;

		case this.Const.MoodState.Eager:
			this.m.Icon = "skills/status_effect_48.png";
			break;

		case this.Const.MoodState.Euphoric:
			this.m.Icon = "skills/status_effect_49.png";
			break;
		}
	}

});
