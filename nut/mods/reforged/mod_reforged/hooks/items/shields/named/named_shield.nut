::Reforged.HooksMod.hook("scripts/items/shields/named/named_shield", function ( q )
{
	q.getBaseItemFields = function ( __original )
	{
		return {
			function getBaseItemFields()
			{
				local ret = __original();
				ret.push("ReachIgnore");
				return ret;
			}

		}.getBaseItemFields;
	};
	q.onPutIntoBag = function ( __original )
	{
		return {
			function onPutIntoBag()
			{
				__original();

				if (this.m.Name.len() == 0)
				{
					if (::Math.rand(1, 100) <= 25)
					{
						this.setName(this.getContainer().getActor().getName() + "的" + ::MSU.Array.rand(this.m.NameList));
					}
					else
					{
						this.setName(this.createRandomName());
					}
				}
			}

		}.onPutIntoBag;
	};
	q.randomizeValues = function ()
	{
		return {
			function randomizeValues()
			{
				local available = [];
				available.push(function ( _i )
				{
					_i.m.MeleeDefense = ::Math.round(_i.m.MeleeDefense * ::Math.rand(120, 140) * 0.01);
				});
				available.push(function ( _i )
				{
					_i.m.RangedDefense = ::Math.round(_i.m.RangedDefense * ::Math.rand(120, 140) * 0.01);
				});
				available.push(function ( _i )
				{
					_i.m.FatigueOnSkillUse = _i.m.FatigueOnSkillUse - ::Math.rand(1, 3);
				});
				available.push(function ( _i )
				{
					_i.m.StaminaModifier = ::Math.round(_i.m.StaminaModifier * ::Math.rand(70, 90) * 0.01);
				});

				for( local n = 2; n != 0 && available.len() != 0; n-- )
				{
					local r = ::Math.rand(0, available.len() - 1);
					available[r](this);
					available.remove(r);
				}
			}

		}.randomizeValues;
	};
});
