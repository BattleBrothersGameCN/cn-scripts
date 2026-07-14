::MSU.Table.merge(::Reforged, {
	__IsDuringGetRumor = false,
	__IsDevMode = false,
	function __toggleDevMode()
	{
		this.__IsDevMode = !this.__IsDevMode;

		foreach( s in ::Reforged.Mod.ModSettings.getPage("Debug").getAllElementsAsArray(::MSU.Class.BooleanSetting).filter(function ( _, _e )
		{
			return _e.getID().len() > 4 && _e.getID().slice(0, 4) == "Dev_";
		}) )
		{
			s.set(this.__IsDevMode);
		}

		::Tooltip.reload();
	}

});
