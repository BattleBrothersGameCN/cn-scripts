::Reforged.HooksMod.hook("scripts/skills/actives/gorge_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "意在将目标压扁，扯成碎片的强力撕咬！";
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
});
