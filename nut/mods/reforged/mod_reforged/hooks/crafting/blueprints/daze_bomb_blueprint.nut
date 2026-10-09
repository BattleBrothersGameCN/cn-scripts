::Reforged.HooksMod.hook("scripts/crafting/blueprints/daze_bomb_blueprint", function ( q )
{
	q.getName = function ( __original )
	{
		return {
			function getName()
			{
				return __original() + " (x2)";
			}

		}.getName;
	};
	q.onCraft = function ( __original )
	{
		return {
			function onCraft( _stash )
			{
				__original(_stash);
				_stash.add(::new(::IO.scriptFilenameByHash(this.m.PreviewCraftable.ClassNameHash)));
			}

		}.onCraft;
	};
});
