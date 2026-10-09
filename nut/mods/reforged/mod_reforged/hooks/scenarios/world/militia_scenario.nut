::Reforged.HooksMod.hook("scripts/scenarios/world/militia_scenario", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				local additionalDesc = "\n[color=#bcad8c]民兵武装：[/color]所有新兵都将获得民兵特技组。";

				if (this.m.Description.slice(-4) == "[/p]")
				{
					this.m.Description = this.m.Description.slice(0, -4) + additionalDesc + "[/p]";
				}
				else
				{
					this.m.Description += additionalDesc;
				}
			}

		}.create;
	};
	q.onBuildPerkTree = function ( __original )
	{
		return {
			function onBuildPerkTree( _perkTree )
			{
				__original(_perkTree);

				foreach( i, row in ::DynamicPerks.PerkGroups.findById("pg.rf_militia").getTree() )
				{
					foreach( perkID in row )
					{
						if (_perkTree.hasPerk(perkID))
						{
							if (_perkTree.getPerkTier(perkID) == i + 1)
							{
								continue;
							}
							else
							{
								_perkTree.removePerk(perkID);
							}
						}

						_perkTree.addPerk(perkID, i + 1);
					}
				}
			}

		}.onBuildPerkTree;
	};
});
