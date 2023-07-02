this.double_strike_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TimeAdded = 0
	},
	function create()
	{
		this.m.ID = "effects.double_strike";
		this.m.Name = "双重打击!";
		this.m.Icon = "skills/status_effect_01.png";
		this.m.IconMini = "status_effect_01_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "这个角色刚刚命中了一次打击，准备施展强大的续击！下一次攻击将造成[color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] 对单个目标造成伤害。如果攻击有多个目标，只有第一个会受到增加的伤害。如果攻击未命中，效果会浪费。";
	}

	function onAdded()
	{
		this.m.TimeAdded = this.Time.getVirtualTimeF();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}

		if (!this.m.IsGarbage && this.m.TimeAdded + 0.100000 < this.Time.getVirtualTimeF() && !_targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			_properties.DamageTotalMult *= 1.200000;
			this.removeSelf();
		}
	}

});
