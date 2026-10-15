::Reforged.HooksMod.hook("scripts/skills/backgrounds/shepherd_background", function ( q )
{
	q.createPerkTreeBlueprint = function ()
	{
		return {
			function createPerkTreeBlueprint()
			{
				return ::new(::DynamicPerks.Class.PerkTree).init({
					DynamicMap = {
						["pgc.rf_exclusive_1"] = [
							"pg.rf_laborer"
						],
						["pgc.rf_shared_1"] = [],
						["pgc.rf_weapon"] = [],
						["pgc.rf_armor"] = [],
						["pgc.rf_fighting_style"] = []
					}
				});
			}

		}.createPerkTreeBlueprint;
	};
	q.getPerkGroupCollectionMin = function ()
	{
		return {
			function getPerkGroupCollectionMin( _collection )
			{
				if (_collection.getID() == "pgc.rf_fighting_style")
				{
					return _collection.getMin() - 1;
				}
			}

		}.getPerkGroupCollectionMin;
	};
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/hitchance.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+10%") + " chance to hit with slings")
				});
				return ret;
			}

		}.getTooltip;
	};
	q.onAnySkillUsed = function ( __original )
	{
		return {
			function onAnySkillUsed( _skill, _targetEntity, _properties )
			{
				__original(_skill, _targetEntity, _properties);
				local weapon = _skill.getItem();

				if (weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Sling))
				{
					_properties.RangedSkill += 10;
				}
			}

		}.onAnySkillUsed;
	};
	q.getPerkGroupMultiplier = function ()
	{
		return {
			function getPerkGroupMultiplier( _groupID, _perkTree )
			{
				if (_groupID == "pg.special.rf_leadership")
				{
					return 2;
				}
			}

		}.getPerkGroupMultiplier;
	};
});
