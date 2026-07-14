this.rf_lash_pole_skill <- ::inherit("scripts/skills/actives/lash_skill", {
	m = {},
	function create()
	{
		this.lash_skill.create();
		this.m.ID = "actives.rf_lash_pole";
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MaxRange = 2;
		this.m.IsTooCloseShown = true;
	}

	function getTooltip()
	{
		local ret = this.lash_skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "攻击范围为" + ::MSU.Text.colorPositive(this.getMaxRange()) + "格"
		});
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		this.lash_skill.onAnySkillUsed(_skill, _targetEntity, _properties);

		if (_skill == this)
		{
			if (_targetEntity != null && !this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) == 1)
			{
				_properties.MeleeSkill += -15;
			}
		}
	}

});
