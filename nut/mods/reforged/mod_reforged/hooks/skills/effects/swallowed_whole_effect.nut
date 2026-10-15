::Reforged.HooksMod.hook("scripts/skills/effects/swallowed_whole_effect", function ( q )
{
	q.m.TargetName <- "";
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "撑肠拄肚";
				this.m.Description = "该角色刚刚吞下了另一名角色。只有剖开肚子才能救他出来。";
			}

		}.create;
	};
	q.setName = function ()
	{
		return {
			function setName( _name )
			{
				this.m.TargetName = _name;
			}

		}.setName;
	};
	q.getName = function ()
	{
		return {
			function getName()
			{
				return this.m.Name + " (" + this.m.TargetName + ")";
			}

		}.getName;
	};
});
