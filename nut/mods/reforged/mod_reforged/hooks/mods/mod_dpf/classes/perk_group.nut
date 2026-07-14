::Reforged.HooksMod.hook(::DynamicPerks.Class.PerkGroup, function ( q )
{
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = [
					{
						id = 1,
						type = "title",
						text = this.getName()
					},
					{
						id = 2,
						type = "description",
						text = this.getDescription()
					}
				];

				foreach( i, row in this.getTree() )
				{
					local perks = [];

					foreach( j, perkID in row )
					{
						local perkDef = ::Const.Perks.findById(perkID);
						perks.push({
							id = 10,
							type = "text",
							icon = perkDef.Icon,
							text = this.format("[tooltip=mod_msu.Perk+%s]%s[/tooltip]", this.split(perkDef.Script, "/").top(), perkDef.Name)
						});
					}

					ret.push({
						id = 3 + i,
						type = "text",
						text = "特技层级" + (i + 1) + ":",
						children = perks
					});
				}

				return ret;
			}

		}.getTooltip;
	};
});
