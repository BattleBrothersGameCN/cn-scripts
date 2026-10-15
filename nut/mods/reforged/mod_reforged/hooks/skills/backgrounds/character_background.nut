::Reforged.HooksMod.hook("scripts/skills/backgrounds/character_background", function ( q )
{
	q.m.BaseAttributes <- {
		Hitpoints = [
			50,
			60
		],
		Bravery = [
			30,
			40
		],
		Stamina = [
			90,
			100
		],
		MeleeSkill = [
			47,
			57
		],
		RangedSkill = [
			32,
			42
		],
		MeleeDefense = [
			0,
			5
		],
		RangedDefense = [
			0,
			5
		],
		Initiative = [
			100,
			110
		]
	};
	q.createPerkTreeBlueprint = function ()
	{
		return {
			function createPerkTreeBlueprint()
			{
				return ::new(::DynamicPerks.Class.PerkTree).init({});
			}

		}.createPerkTreeBlueprint;
	};
	q.isHired <- {
		function isHired()
		{
			return !::MSU.isNull(this.getContainer()) && !::MSU.isNull(this.getContainer().getActor()) && this.getContainer().getActor().isHired();
		}

	}.isHired;
	q.getProjectedAttributesTooltip <- {
		function getProjectedAttributesTooltip()
		{
			return [
				{
					id = 3,
					type = "description",
					rawHTMLInText = true,
					text = this.getProjectedAttributesHTML()
				}
			];
		}

	}.getProjectedAttributesTooltip;
	q.getPerkTreeTooltip <- {
		function getPerkTreeTooltip()
		{
			return {
				id = 3,
				type = "description",
				text = this.getContainer().getActor().getPerkTree().getTooltip()
			};
		}

	}.getPerkTreeTooltip;
	q.getProjectedAttributesHTML <- {
		function getProjectedAttributesHTML()
		{
			local projection = this.getContainer().getActor().getProjectedAttributes();
			local formatString = function ( _img, _attribute )
			{
				local min = projection[_attribute][0];
				local max = projection[_attribute][1];
				return this.format("<span class=\'attributePredictionItem\'><img src=\'coui://%s\'/> <span class=\'attributePredictionSingle\'>%i</span> <span class=\'attributePredictionRange\'>[%i - %i]</span></span>", _img, (min + max) / 2, min, max);
			};
			local ret = ::Reforged.Mod.Tooltips.parseString("<div class=\'attributePredictionHeader\'>该角色[基础|Concept.BaseAttribute][属性|Concept.CharacterAttribute]在[等级|Concept.Level] " + ::Const.XP.MaxLevelWithPerkpoints + "[级|Concept.Level]时[基础|Concept.BaseAttribute][属性|Concept.CharacterAttribute]的预测，包括人物特性和[永久创伤|Concept.InjuryPermanent]的影响</div>");
			ret = ret + "<div class=\'attributePredictionContainer\'>";
			ret = ret + formatString("gfx/ui/icons/health.png", ::Const.Attributes.Hitpoints);
			ret = ret + formatString("gfx/ui/icons/melee_skill.png", ::Const.Attributes.MeleeSkill);
			ret = ret + formatString("gfx/ui/icons/fatigue.png", ::Const.Attributes.Fatigue);
			ret = ret + formatString("gfx/ui/icons/ranged_skill.png", ::Const.Attributes.RangedSkill);
			ret = ret + formatString("gfx/ui/icons/bravery.png", ::Const.Attributes.Bravery);
			ret = ret + formatString("gfx/ui/icons/melee_defense.png", ::Const.Attributes.MeleeDefense);
			ret = ret + formatString("gfx/ui/icons/initiative.png", ::Const.Attributes.Initiative);
			ret = ret + formatString("gfx/ui/icons/ranged_defense.png", ::Const.Attributes.RangedDefense);
			ret = ret + "</div>";
			return ret;
		}

	}.getProjectedAttributesHTML;
	q.getBaseAttributesTooltip <- {
		function getBaseAttributesTooltip( _hideRolledValues )
		{
			local baseProperties = this.getContainer().getActor().getBaseProperties();
			local baseAttr = this.m.BaseAttributes;
			local change = this.onChangeAttributes();
			local formatString = function ( _img, _attrName )
			{
				local baseValue = _hideRolledValues ? "" : baseProperties[_attrName].tostring();
				local minValue = baseAttr[_attrName][0] + change[_attrName][0];
				local maxValue = baseAttr[_attrName][1] + change[_attrName][1];
				return this.format("<span class=\'attributePredictionItem\'><img src=\'coui://%s\'/> <span class=\'attributePredictionSingle\'>%s</span> <span class=\'attributePredictionRange\'>[%i - %i]</span></span>", _img, baseValue, minValue, maxValue);
			};
			local html = "<div class=\'attributePredictionHeader\'>该背景的基础属性范围是：</div>";
			html = html + "<div class=\'attributePredictionContainer\'>";
			html = html + formatString("gfx/ui/icons/health.png", "生命值");
			html = html + formatString("gfx/ui/icons/melee_skill.png", "MeleeSkill");
			html = html + formatString("gfx/ui/icons/fatigue.png", "Stamina");
			html = html + formatString("gfx/ui/icons/ranged_skill.png", "RangedSkill");
			html = html + formatString("gfx/ui/icons/bravery.png", "Bravery");
			html = html + formatString("gfx/ui/icons/melee_defense.png", "MeleeDefense");
			html = html + formatString("gfx/ui/icons/initiative.png", "主动值");
			html = html + formatString("gfx/ui/icons/ranged_defense.png", "RangedDefense");
			return [
				{
					id = 4,
					type = "description",
					rawHTMLInText = true,
					text = html
				}
			];
		}

	}.getBaseAttributesTooltip;
});
::Reforged.HooksMod.hookTree("scripts/skills/backgrounds/character_background", function ( q )
{
	q.getGenericTooltip = function ( __original )
	{
		return {
			function getGenericTooltip()
			{
				local ret = __original();

				if (::Reforged.Mod.ModSettings.getSetting("CharacterScreen_ShowBaseAttributeRangesHiring").getValue())
				{
					ret.extend(this.getBaseAttributesTooltip(true));
				}

				return ret;
			}

		}.getGenericTooltip;
	};
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();
				local showBaseAttributeRangeRegular = ::Reforged.Mod.ModSettings.getSetting("CharacterScreen_ShowBaseAttributeRangesRegular").getValue();

				if (showBaseAttributeRangeRegular == "Always")
				{
					ret.extend(this.getBaseAttributesTooltip(false));
				}
				else if (showBaseAttributeRangeRegular == "Only New Recruits")
				{
					if (this.getContainer().getActor().m.LevelUpsSpent == 0)
					{
						ret.extend(this.getBaseAttributesTooltip(false));
					}
				}

				if (::Reforged.Mod.ModSettings.getSetting("CharacterScreen_ShowAttributeProjection").getValue())
				{
					local player = this.getContainer().getActor();

					if (::Const.XP.MaxLevelWithPerkpoints - player.getLevel() + player.getLevelUps() > 0)
					{
						ret.extend(this.getProjectedAttributesTooltip());
					}
				}

				return ret;
			}

		}.getTooltip;
	};
});
