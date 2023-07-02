class TooltipEventsStub {
    //constructor
    constructor()
    {
        TooltipEvents = new("scripts/ui/screens/tooltip/tooltip_events");
    }

	// Tooltip UI Events Handler
	//
    function onQueryTileTooltipData() {
        local ret = TooltipEvents.onQueryTileTooltipData();
        return TooltipEventsStub.translateTooltip(ret);
    }

    function onQueryEntityTooltipData(_entityId, _isTileEntity) {
        local ret = TooltipEvents.onQueryEntityTooltipData(_entityId, _isTileEntity);
        return TooltipEventsStub.translateTooltip(ret);
    }

    function onQueryRosterEntityTooltipData(_entityId) {
        local ret = TooltipEvents.onQueryRosterEntityTooltipData(_entityId);
        return TooltipEventsStub.translateTooltip(ret);
    }

    function onQuerySkillTooltipData(_entityId, _skillId) {
        local ret = TooltipEvents.onQuerySkillTooltipData(_entityId, _skillId);
        return TooltipEventsStub.translateTooltip(ret);
    }

    function onQueryStatusEffectTooltipData(_entityId, _statusEffectId) {
        local ret = TooltipEvents.onQueryStatusEffectTooltipData(_entityId, _statusEffectId);
        return TooltipEventsStub.translateTooltip(ret);
    }

    function onQuerySettlementStatusEffectTooltipData(_statusEffectId) {
        local ret = TooltipEvents.onQuerySettlementStatusEffectTooltipData(_statusEffectId);
        return TooltipEventsStub.translateTooltip(ret);
    }

    function onQueryUIElementTooltipData(_entityId, _elementId, _elementOwner) {
        local ret = TooltipEvents.onQueryUIElementTooltipData(_entityId, _elementId, _elementOwner);
        return TooltipEventsStub.translateTooltip(ret);
    }

    function onQueryUIItemTooltipData(_entityId, _itemId, _itemOwner) {
        local ret = TooltipEvents.onQueryUIItemTooltipData(_entityId, _itemId, _itemOwner);
        return TooltipEventsStub.translateTooltip(ret);
    }

    function onQueryUIPerkTooltipData(_entityId, _perkId) {
        local ret = TooltipEvents.onQueryUIPerkTooltipData(_entityId, _perkId);
        return TooltipEventsStub.translateTooltip(ret);
    }

    function onQueryFollowerTooltipData(_followerID) {
        local ret = TooltipEvents.onQueryFollowerTooltipData(_followerID);
        return TooltipEventsStub.translateTooltip(ret);
    }

    // inner API
    function translateTooltip(tooltip) {
        foreach(idx, val in tooltip){
            if ("text" in val) {
                val["text"] = "foo: " + idx;
            }
        }
        return tooltip;
    }

    //property
    TooltipEvents = null;
}


local gt = getroottable();
gt.TooltipEventsStub <- TooltipEventsStub;