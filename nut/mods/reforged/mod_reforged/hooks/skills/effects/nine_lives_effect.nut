::Reforged.HooksMod.hook("scripts/skills/effects/nine_lives_effect", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "增强反应能力（九命猫）";
				this.m.Icon = "skills/rf_nine_lives_effect.png";
				this.m.IconMini = "rf_nine_lives_effect_mini";
			}

		}.create;
	};
});
