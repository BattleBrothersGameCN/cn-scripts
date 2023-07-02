this.research_notes_legendary_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.research_notes_legendary";
		this.m.Name = "传奇故事大典";
		this.m.Description = "这是一本薄薄的日志，用精致的皮革装订而成，里面记载着那些一度被认为只存在于神话和传说中的生物的寥寥数页研究笔记。";
		this.m.Icon = "misc/inventory_anatomists_book_04.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc;
		this.m.Value = 0;
	}

	function getTooltip()
	{
		local result = [
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
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/papers.png",
			text = "记录着战团对传奇生物的研究成果……如果你真能找得到它们的话"
		});
		local buffAcquisitions = [
			{
				flag = "isKrakenPotionDiscovered",
				creatureName = "克拉肯(Kraken)",
				potionName = "沼地霸主灵药"
			},
			{
				flag = "isRachegeistPotionDiscovered",
				creatureName = "雷切吉斯特",
				potionName = "复仇刀锋灵药"
			},
			{
				flag = "isIjirokPotionDiscovered",
				creatureName = "伊杰洛克(Ijirok)",
				potionName = "疯嚣之神灵药"
			},
			{
				flag = "isLorekeeperPotionDiscovered",
				creatureName = "博学者(Lorekeeper)",
				potionName = "内部护符药水(Potion of Inner Phylactery)"
			}
		];

		foreach( buff in buffAcquisitions )
		{
			if (this.World.Statistics.getFlags().get(buff.flag))
			{
				result.push({
					id = 15,
					type = "text",
					icon = "ui/icons/special.png",
					text = "" + buff.creatureName + ": " + buff.potionName
				});
			}
		}

		return result;
	}

});
