::Reforged.HooksMod.hook("scripts/events/event", function ( q )
{
	q.RF_getUICharacterTooltipID <- {
		function RF_getUICharacterTooltipID( _index = 0 )
		{
			local image = this.getUICharacterImage(_index);

			if (image == null)
			{
				return null;
			}

			local imagePath = image.Image;

			if (("Characters" in this.m.ActiveScreen) && this.m.ActiveScreen.Characters.len() > _index)
			{
				foreach( k, v in this.m )
				{
					if (::MSU.isKindOf(v, "actor") && imagePath.find("," + v.getID() + ",") != null)
					{
						return "EventActor+" + v.getID();
					}
				}
			}

			if (("Banner" in this.m.ActiveScreen) && imagePath == this.m.ActiveScreen.Banner)
			{
				foreach( f in ::World.FactionManager.getFactions() )
				{
					if (f != null && (imagePath == f.getUIBanner() || imagePath == f.getUIBannerSmall()))
					{
						return "Faction+" + f.getID();
					}
				}
			}
		}

	}.RF_getUICharacterTooltipID;
	q.setScreen = function ( __original )
	{
		return {
			function setScreen( _screen )
			{
				::Reforged.NestedTooltips.setApplyNestingForEvents(true);
				__original(_screen);
				::Reforged.NestedTooltips.setApplyNestingForEvents(false);
			}

		}.setScreen;
	};
	q.buildText = function ( __original )
	{
		return {
			function buildText( _text )
			{
				::Reforged.NestedTooltips.setApplyNestingForEvents(true);
				local ret = __original(_text);
				::Reforged.NestedTooltips.setApplyNestingForEvents(false);
				return ret;
			}

		}.buildText;
	};
});
::Reforged.HooksMod.hookTree("scripts/events/event", function ( q )
{
	q.onPrepareVariables = function ( __original )
	{
		return {
			function onPrepareVariables( _vars )
			{
				::Reforged.NestedTooltips.setApplyNestingForEvents(true);
				__original(_vars);
				::Reforged.NestedTooltips.setApplyNestingForEvents(false);
			}

		}.onPrepareVariables;
	};
});
