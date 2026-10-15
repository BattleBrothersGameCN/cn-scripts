::Reforged.Mod.Tooltips.setTooltips({
	EventActor = ::MSU.Class.CustomTooltip(function ( _data )
	{
		local entity = ::Tactical.getEntityByID(_data.ExtraData.tointeger());

		if (entity == null)
		{
			return null;
		}

		if (::MSU.isKindOf(entity, "player"))
		{
			local ret = entity.getRosterTooltip();
			ret.push({
				id = 124,
				type = "text",
				text = "rf_divider"
			});
			ret.extend([
				::Reforged.TacticalTooltip.getTooltipAttributesSmall(entity, 100)
			]);
			ret.push({
				id = 124,
				type = "text",
				text = "rf_divider"
			});
			ret.extend(::Reforged.TacticalTooltip.getTooltipTraits(entity, 200));
			ret.extend(::Reforged.TacticalTooltip.getTooltipEffects(entity, 300));
			ret.extend(::Reforged.TacticalTooltip.getTooltipPerks(entity, 400));
			ret.extend(::Reforged.TacticalTooltip.getTooltipEquippedItems(entity, 500));
			ret.extend(::Reforged.TacticalTooltip.getTooltipBagItems(entity, 600));
			return ret;
		}

		return ::TooltipEvents.general_queryUIElementTooltipData(entity.getID(), "CharacterNameAndTitles", null);
	}),
	Faction = ::MSU.Class.CustomTooltip(function ( _data )
	{
		local ret = [
			{
				contentType = "settlement-status-effect"
			}
		];
		ret.extend(::World.FactionManager.getFaction(_data.ExtraData.tointeger()).RF_getTooltip());
		return ret;
	}),
	HireScreen = {
		DescriptionContainer = ::MSU.Class.CustomTooltip(function ( _data )
		{
			local states = [
				"切换显示特技组",
				"切换显示特技树",
				"切换显示人物描述"
			];
			return [
				{
					id = 1,
					type = "title",
					text = "点击切换"
				},
				{
					id = 2,
					type = "description",
					text = states[_data.ExtraData.tointeger()]
				}
			];
		})
	},
	Contract = {
		FocusOnObjective = ::MSU.Class.BasicTooltip("Click to focus", "Click to focus on the objectives for this contract"),
		Tooltip = ::MSU.Class.CustomTooltip(function ( _data )
		{
			local id = _data.ExtraData.tointeger();
			local contract;
			local active = ::World.Contracts.getActiveContract();

			if (active != null && active.getID() == id)
			{
				contract = active;
			}
			else
			{
				foreach( c in ::World.Contracts.m.Open )
				{
					if (c.getID() == id)
					{
						contract = c;
						break;
					}
				}
			}

			if (contract != null)
			{
				local ret = contract.RF_getTooltip();
				ret.insert(0, {
					contentType = "settlement-status-effect"
				});

				if (active != null)
				{
					ret.push({
						id = 100,
						type = "hint",
						icon = "ui/icons/locked_small.png",
						text = "你一次只能激活一个合同。"
					});
				}

				ret.push({
					id = 300,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "解除合同"
				});
				return ret;
			}
		})
	},
	Tactical = {
		Button = {
			WaitTurnAllButton = ::MSU.Class.CustomTooltip(function ( _ )
			{
				return [
					{
						id = 1,
						type = "title",
						text = this.format("等待回合(%s)", ::MSU.System.Keybinds.KeybindsByMod.mod_reforged.Tactical_WaitRound.getKeyCombinations())
					},
					{
						id = 2,
						type = "description",
						text = ::Reforged.Mod.Tooltips.parseString("让你的所有角色在[回合|Concept.Turn]中进行[等待|Concept.Wait]。")
					}
				];
			})
		}
	}
});
local tooltipImageKeywords = {
	["ui/icons/rf_reach.png"] = "Concept.Reach",
	["ui/icons/rf_reach_attack.png"] = "Concept.ReachIgnoreOffensive",
	["ui/icons/rf_reach_defense.png"] = "Concept.ReachIgnoreDefensive"
};
::Reforged.Mod.Tooltips.setTooltipImageKeywords(tooltipImageKeywords);
::Reforged.Mod.Tooltips.generateNestedTextFromObjCallback = function ( _field, _key, _extraData )
{
	if (this.split(_key, ".")[0] == "Concept")
	{
		local tooltip = this.getTooltip(_key).Tooltip;

		if (_field == "Name")
		{
			return tooltip.getUIData(_extraData)[0].text;
		}
	}
};
