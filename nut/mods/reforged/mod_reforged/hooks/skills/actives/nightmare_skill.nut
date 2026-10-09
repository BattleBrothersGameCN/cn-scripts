::Reforged.HooksMod.hook("scripts/skills/actives/nightmare_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "让目标陷入噩梦世界，尽情享用他们的灵魂！";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getDefaultTooltip();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "技能范围为" + ::MSU.Text.colorizeValue(this.getMaxRange()) + "格"
				});
				ret.push({
					id = 20,
					type = "text",
					icon = "ui/icons/warning.png",
					text = ::Reforged.Mod.Tooltips.parseString("只能对[$ $|Skill+sleeping_effect]的目标使用")
				});
				return ret;
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
