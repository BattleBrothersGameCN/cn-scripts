::Reforged.HooksMod.hook("scripts/items/weapons/named/named_weapon", function ( q )
{
	q.getBaseItemFields = function ( __original )
	{
		return {
			function getBaseItemFields()
			{
				local ret = __original();
				ret.push("触及");
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
	q.onSerialize = function ( __original )
	{
		return {
			function onSerialize( _out )
			{
				local chanceToHitHead = this.m.ChanceToHitHead;
				this.m.ChanceToHitHead = 0;
				__original(_out);
				this.m.ChanceToHitHead = chanceToHitHead;
				_out.writeI8(chanceToHitHead);
			}

		}.onSerialize;
	};
	q.onDeserialize = function ( __original )
	{
		return {
			function onDeserialize( _in )
			{
				__original(_in);
				this.m.ChanceToHitHead = _in.readI8();
			}

		}.onDeserialize;
	};
});
