::Reforged.HooksMod.hook("scripts/items/accessory/accessory", function ( q )
{
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				foreach( index, entry in ret )
				{
					if (entry.id == 8 && entry.icon == "ui/icons/fatigue.png")
					{
						if (this.getStaminaModifier() == 0)
						{
							ret.remove(index);
						}
						else
						{
							entry.text = "疲劳值上限" + ::MSU.Text.colorizeValue(this.getStaminaModifier(), {
								AddSign = true
							});
						}

						break;
					}
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onUpdateProperties = function ()
	{
		return {
			function onUpdateProperties( _properties )
			{
				if (this.getCurrentSlotType() != ::Const.ItemSlot.Bag)
				{
					_properties.Stamina += this.getStaminaModifier();
				}
			}

		}.onUpdateProperties;
	};
});
