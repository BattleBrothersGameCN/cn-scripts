this.root_state <- this.inherit("scripts/states/state", {
	m = {},
	function onInit()
	{
		local prefix = function ( context )
		{
			local gt = this.getroottable();

			if (!("RenderTemplate" in gt))
			{
				gt.RenderTemplate <- function ( template, vargv, ... )
				{
					local args = [
						this,
						template
					];

					foreach( val in vargv )
					{
						this.print("val" + val);

						if (this.type(val) == "string")
						{
							args.append(val);
						}
						else
						{
							args.append(val.tostring());
						}
					}

					return ::format.acall(args);
				};
			}

			return true;
		};
		local origin = function ()
		{
			local globalTable = this.getroottable();
			globalTable.Root <- this;
			globalTable.LoadingScreen <- this.new("scripts/ui/screens/loading/loading_screen");
			globalTable.TooltipScreen <- this.new("scripts/ui/screens/tooltip/tooltip_screen");
			globalTable.UIDataHelper <- this.new("scripts/ui/global/data_helper");
			globalTable.Cursor <- this.new("scripts/ui/global/cursor");
			globalTable.MapGen <- this.new("scripts/mapgen/map_generator");
			globalTable.DialogScreen <- this.new("scripts/ui/screens/dialog_screen");
			this.add("MainMenuState", "scripts/states/main_menu_state");
		};
		local suffix = function ( context )
		{
		};
		local params = {};
		local context = {
			result = null,
			params = params,
			origin = origin
		};

		if (!prefix.call(this, context))
		{
			return context.result;
		}

		context.result = context.origin.acall([
			this
		]);
		suffix.call(this, context);
		return context.result;
	}

});
