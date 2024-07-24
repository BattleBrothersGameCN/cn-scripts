this.arena_pit_fighter_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.pit_fighter";
		this.m.Name = "土坑斗士";
		this.m.Icon = "ui/traits/trait_icon_73.png";
		this.m.Description = "这个角色刚刚涉足残酷的竞技场战斗行业，而且还没死掉。";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
	}

	function getTooltip()
	{
		local matches = this.getContainer().getActor().getFlags().getAsInt("ArenaFights");
		local won = this.getContainer().getActor().getFlags().getAsInt("ArenaFightsWon");
		local text;

		if (matches == 1)
		{
			text = "目前为止，这个角色只打过一场比赛";

			if (won == 1)
			{
				text = text + "并且取得了胜利。";
			}
			else
			{
				text = text + "，但是输了。";
			}
		}
		else
		{
			if (won == matches)
			{
				won = "每一";
			}

			text = "到目前为止，这个角色参与了 " + matches + " 场比赛并赢了 " + won + " 场。";
		}

		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription() + text
			}
		];
	}

});
