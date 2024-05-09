this.arena_veteran_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.arena_veteran";
		this.m.Name = "竞技场老兵";
		this.m.Icon = "ui/traits/trait_icon_75.png";
		this.m.Description = "作为一个有着许多伤疤的竞技场老兵，这个角色知道如何让人群为血腥的场面欢呼。实力越是悬殊，娱乐效果越好！";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
	}

	function getTooltip()
	{
		local matches = this.getContainer().getActor().getFlags().getAsInt("ArenaFights");
		local won = this.getContainer().getActor().getFlags().getAsInt("ArenaFightsWon");

		if (won == matches)
		{
			won = "每一";
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
				text = this.getDescription() + "到目前为止，这个角色参与了 " + matches + " 场比赛并赢了 " + won + " 场。"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] 决心"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "有 [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] 几率在被非致命伤害击倒时幸存"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
		_properties.SurviveWithInjuryChanceMult *= 1.51;
	}

});
