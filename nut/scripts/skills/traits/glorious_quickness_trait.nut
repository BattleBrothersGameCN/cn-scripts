this.glorious_quickness_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.glorious";
		this.m.Name = "荣耀迅捷";
		this.m.Icon = "ui/traits/trait_icon_71.png";
		this.m.Description = "在南方的竞技场上锻造的这个角色已经打了很多仗，是迅速处理多个对手的专家。 他美妙的生活方式要求很高的薪水，但他永远不会抛弃你，也不能被解雇。 如果三个初始成员都死了，你的战役就结束了。";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "每当在他的轮次杀死一个敌人时，这个角色立刻恢复 [color=" + this.Const.UI.Color.PositiveValue + "]1[/color] 行动点数"
			}
		];
		return ret;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		local actor = this.getContainer().getActor();

		if (actor.isAlliedWith(_targetEntity))
		{
			return;
		}

		if (actor.getActionPoints() == actor.getActionPointsMax())
		{
			return;
		}

		if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == actor.getID())
		{
			actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + 1));
			actor.setDirty(true);
			this.spawnIcon("trait_icon_71", this.m.Container.getActor().getTile());
		}
	}

});
