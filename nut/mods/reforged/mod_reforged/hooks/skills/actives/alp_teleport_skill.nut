::Reforged.HooksMod.hook("scripts/skills/actives/alp_teleport_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "梦魇会在受攻击时传送到随机地格上。";
				this.m.Icon = "skills/rf_alp_teleport_skill.png";
				this.m.IconDisabled = "skills/rf_alp_teleport_skill_sw.png";
			}

		}.create;
	};
});
