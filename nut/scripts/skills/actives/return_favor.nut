this.return_favor <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.return_favor";
		this.m.Name = "以牙还牙";
		this.m.Description = "利用你高超的战斗技能，采取防御姿态，并设法使任何在你攻击范围内的攻击你的人丧失能力。";
		this.m.Icon = "ui/perks/perk_31_active.png";
		this.m.IconDisabled = "ui/perks/perk_31_active_sw.png";
		this.m.Overlay = "perk_31_active";
		this.m.SoundOnUse = [
			"sounds/combat/return_favor_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 30;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "获得 [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] 的概率使任何在近战攻击时没有击中此角色的对手昏迷（仍然存在抗性和免疫能力）。"
			}
		];
		return ret;
	}

	function isUsable()
	{
		return !this.m.IsSpent && this.skill.isUsable();
	}

	function onUse( _user, _targetTile )
	{
		if (!this.m.IsSpent)
		{
			this.m.Container.add(this.new("scripts/skills/effects/return_favor_effect"));
			this.m.IsSpent = true;
			return true;
		}

		return false;
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

});
