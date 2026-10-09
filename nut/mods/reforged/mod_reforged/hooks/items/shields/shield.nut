::Reforged.HooksMod.hook("scripts/items/shields/shield", function ( q )
{
	q.m.ReachIgnore <- 2;
	q.getReachIgnore <- {
		function getReachIgnore()
		{
			return this.m.ReachIgnore;
		}

	}.getReachIgnore;
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				if (this.RF_getDefenseMult() != 1.0)
				{
					ret.push({
						id = 11,
						type = "text",
						icon = "ui/icons/fatigue.png",
						text = ::Reforged.Mod.Tooltips.parseString("除非正在使用[盾墙|Skill+shieldwall]技能，盾牌防御会随着[疲劳|Concept.Fatigue]积累而线性下降，[疲劳|Concept.Fatigue]值满时降至最低，最低降至" + ::MSU.Text.colorizeMult(this.RF_getDefenseMult()) + " at maximum [Fatigue|Concept.Fatigue]")
					});
				}

				if (this.getReachIgnore() != 0)
				{
					ret.push({
						id = 12,
						type = "text",
						icon = "ui/icons/rf_reach.png",
						text = ::Reforged.Mod.Tooltips.parseString("抵消" + ::MSU.Text.colorPositive(this.getReachIgnore()) + "点[触及优势|Concept.ReachAdvantage]")
					});
				}

				return ret;
			}

		}.getTooltip;
	};
	q.getMeleeDefense = function ( __original )
	{
		return {
			function getMeleeDefense()
			{
				if (::MSU.isNull(this.getContainer()) || ::MSU.isNull(this.getContainer().getActor()))
				{
					return __original();
				}

				return ::Math.floor(__original() * this.RF_getDefenseMult());
			}

		}.getMeleeDefense;
	};
	q.getRangedDefense = function ( __original )
	{
		return {
			function getRangedDefense()
			{
				if (::MSU.isNull(this.getContainer()) || ::MSU.isNull(this.getContainer().getActor()))
				{
					return __original();
				}

				return ::Math.floor(__original() * this.RF_getDefenseMult());
			}

		}.getRangedDefense;
	};
	q.onUpdateProperties = function ()
	{
		return {
			function onUpdateProperties( _properties )
			{
				if (this.m.Condition == 0)
				{
					return;
				}

				local mult = this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields ? 1.25 : 1.0;
				_properties.MeleeDefense += ::Math.floor(this.getMeleeDefense() * mult);
				_properties.RangedDefense += ::Math.floor(this.getRangedDefense() * mult);
				_properties.Stamina += this.getStaminaModifier();
				_properties.DefensiveReachIgnore += this.getReachIgnore();
			}

		}.onUpdateProperties;
	};
	q.getMeleeDefenseBonus <- {
		function getMeleeDefenseBonus()
		{
			local mult = this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields ? 1.25 : 1.0;
			return ::Math.floor(this.getMeleeDefense() * mult);
		}

	}.getMeleeDefenseBonus;
	q.getRangedDefenseBonus <- {
		function getRangedDefenseBonus()
		{
			local mult = this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields ? 1.25 : 1.0;
			return ::Math.floor(this.getRangedDefense() * mult);
		}

	}.getRangedDefenseBonus;
	q.RF_getDefenseMult <- {
		function RF_getDefenseMult()
		{
			if (::MSU.isNull(this.getContainer()) || ::MSU.isNull(this.getContainer().getActor()))
			{
				return 0.5;
			}

			local actor = this.getContainer().getActor();

			if (actor.getSkills().hasSkill("effects.shieldwall"))
			{
				return 1.0;
			}

			return 1.0 - (actor.getCurrentProperties().IsSpecializedInShields ? 0.25 : 0.5) * actor.getFatiguePct();
		}

	}.RF_getDefenseMult;
});
