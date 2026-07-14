::Reforged.HooksMod.hook("scripts/skills/actives/ghastly_touch", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "直击对手灵魂，穿透护甲造成伤害。";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				return this.skill.getDefaultTooltip();
			}

		}.getTooltip;
	};
	q.onAnySkillUsed = function ( __original )
	{
		return function ( _skill, _targetEntity, _properties )
		{
			__original(_skill, _targetEntity, _properties);

			if (_skill == this)
			{
				_properties.DamageArmorMult *= 0.0;
			}
		};
	};
});
