::Reforged.HooksMod.hook("scripts/skills/actives/zombie_bite", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "用一口烂牙咬得别人生疼。";
			}

		}.create;
	};
	q.isHidden = function ()
	{
		return {
			function isHidden()
			{
				local actor = this.getContainer().getActor();
				return actor.getMainhandItem() != null && !actor.isDisarmed();
			}

		}.isHidden;
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
