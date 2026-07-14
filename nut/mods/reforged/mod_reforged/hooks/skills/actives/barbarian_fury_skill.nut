::Reforged.HooksMod.hook("scripts/skills/actives/barbarian_fury_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Icon = "skills/active_175.png";
				this.m.IconDisabled = "skills/active_175_sw.png";
				this.m.Description = ::Reforged.Mod.Tooltips.parseString("与一名直接相邻的盟友交换位置，任一角色被[击晕|Skill+stunned_effect]或定身时除外。轮换战线，确保生力军位于前列！");
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				return this.skill.getDefaultUtilityTooltip();
			}

		}.getTooltip;
	};
	q.getCursorForTile = function ()
	{
		return {
			function getCursorForTile( _tile )
			{
				return ::Const.UI.Cursor.Rotation;
			}

		}.getCursorForTile;
	};
});
