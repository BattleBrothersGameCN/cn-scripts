::Reforged.HooksMod.hook("scripts/scenarios/world/raiders_scenario", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				local additionalDesc = "\n[color=#bcad8c]肾上腺素：[/color]所有新兵都能学习肾上腺素特技。";

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

				if (_perkTree.hasPerk("perk.adrenaline"))
				{
					_perkTree.removePerk("perk.adrenaline");
				}

				_perkTree.addPerk("perk.adrenaline");
			}

		}.onBuildPerkTree;
	};
});
