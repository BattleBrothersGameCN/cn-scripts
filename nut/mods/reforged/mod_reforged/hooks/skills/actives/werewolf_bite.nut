::Reforged.HooksMod.hook("scripts/skills/actives/werewolf_bite", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "硬颌尖牙，剖心掏肺。";
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
