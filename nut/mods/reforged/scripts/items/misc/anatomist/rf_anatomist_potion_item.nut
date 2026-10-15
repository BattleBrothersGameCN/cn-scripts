this.rf_anatomist_potion_item <- ::inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.Value = 0;
	}

	function getTooltip()
	{
		local ret = this.anatomist_potion_item.getTooltip();
		local path = ::IO.scriptFilenameByHash(this.ClassNameHash);

		foreach( info in ::Reforged.Items.AnatomistPotions.Infos )
		{
			if (info.ItemScript == path)
			{
				ret.extend(::new(info.EffectScript).getTooltip().slice(2));
			}
		}

		ret.push({
			id = 65,
			type = "text",
			text = "右键单击或拖动到当前选定的角色上进行饮用。此物品会在使用过程中消耗掉。"
		});
		ret.push({
			id = 65,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "使身体发生变异，导致疾病"
		});
		return ret;
	}

	function onUse( _actor, _item = null )
	{
		local path = ::IO.scriptFilenameByHash(this.ClassNameHash);

		foreach( info in ::Reforged.Items.AnatomistPotions.Infos )
		{
			if (info.ItemScript == path)
			{
				_actor.getSkills().add(::new(info.EffectScript));
			}
		}

		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});
