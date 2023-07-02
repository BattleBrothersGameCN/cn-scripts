this.eagle_eyes_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.eagle_eyes";
		this.m.Name = "鹰眼";
		this.m.Icon = "ui/traits/trait_icon_09.png";
		this.m.Description = "拥有鹰眼般的视力，这个角色可以从一百步之外发现一只苍蝇。";
		this.m.Excluded = [
			"trait.short_sighted",
			"trait.night_blind"
		];
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] 视野"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Vision += 1;
	}

});
