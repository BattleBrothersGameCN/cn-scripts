this.heavily_armored_warhound_item <- this.inherit("scripts/items/accessory/warhound_item", {
	m = {},
	function create()
	{
		this.warhound_item.create();
		this.m.ID = "accessory.heavily_armored_warhound";
		this.m.Description = "一条为战争而生，强壮而忠诚的北方战獒。可在战斗中释放，用以侦查、追踪或猎杀逃跑的敌人。穿有一件重型兽皮护甲。";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.ArmorScript = "scripts/items/armor/special/wardog_heavy_armor";
		this.m.Value = 750;
	}

	function setEntity( _e )
	{
		this.m.Entity = _e;

		if (this.m.Entity != null)
		{
			this.m.Icon = "tools/hound_01_leash_70x70.png";
		}
		else
		{
			this.m.Icon = "tools/hound_0" + this.m.Variant + "_armor_02_70x70.png";
		}
	}

});
