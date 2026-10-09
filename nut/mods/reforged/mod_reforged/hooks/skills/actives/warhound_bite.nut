::Reforged.HooksMod.hook("scripts/skills/actives/warhound_bite", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "摇晃大口，撕扯血肉。";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				return this.getDefaultTooltip();
			}

		}.getTooltip;
	};
});
