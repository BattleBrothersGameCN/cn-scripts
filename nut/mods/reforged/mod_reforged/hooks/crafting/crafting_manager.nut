::Reforged.HooksMod.hook("scripts/crafting/crafting_manager", function ( q )
{
	q.getQualifiedBlueprints = function ( __original )
	{
		return {
			function getQualifiedBlueprints()
			{
				local settingValue = ::Reforged.Mod.ModSettings.getSetting("CraftingBlueprintVisibility").getValue();

				switch(settingValue)
				{
				case "Vanilla":
					return __original();

				case "Always":
					local ret = [];

					foreach( b in this.m.Blueprints )
					{
						local oldTimesCrafted = b.m.TimesCrafted;
						b.m.TimesCrafted = 1;

						if (b.isQualified())
						{
							ret.push(b);
						}

						b.m.TimesCrafted = oldTimesCrafted;
					}

					return ret;

				case "One Ingredient Available":
					local ret = [];

					foreach( b in this.m.Blueprints )
					{
						if (b.isPartlyCraftable())
						{
							local oldTimesCrafted = b.m.TimesCrafted;
							b.m.TimesCrafted = 1;

							if (b.isQualified())
							{
								ret.push(b);
							}

							b.m.TimesCrafted = oldTimesCrafted;
						}
					}

					return ret;

				case "All Ingredients Available":
					local ret = [];

					foreach( b in this.m.Blueprints )
					{
						local oldTimesCrafted = b.m.TimesCrafted;
						b.m.TimesCrafted = 0;

						if (b.isQualified())
						{
							ret.push(b);
						}

						b.m.TimesCrafted = oldTimesCrafted;
					}

					return ret;
				}

				throw "Unknown setting value: " + settingValue;
			}

		}.getQualifiedBlueprints;
	};
	q.getQualifiedBlueprintsForUI = function ()
	{
		return {
			function getQualifiedBlueprintsForUI()
			{
				local ret = [];

				foreach( blueprint in this.getQualifiedBlueprints() )
				{
					ret.push(blueprint.getUIData());
				}

				ret.sort(this.onSortBlueprints);
				return ret;
			}

		}.getQualifiedBlueprintsForUI;
	};
});
