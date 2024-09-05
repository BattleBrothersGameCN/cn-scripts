this.antidote_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.immune_to_poison";
		this.m.Name = "毒素免疫";
		this.m.Icon = "skills/status_effect_118.png";
		this.m.IconMini = "status_effect_118_mini";
		this.m.Overlay = "status_effect_118";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "该角色服下了解毒剂，在[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color]回合内免疫任何毒素。";
	}

	function onAdded()
	{
		this.m.TurnsLeft = 3;
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 3;
		this.spawnIcon("status_effect_118", this.getContainer().getActor().getTile());
	}

	function onUpdate( _properties )
	{
		_properties.IsImmuneToPoison = true;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});
