/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Jan Schulte | 2013 - 2014
 * 
 *  @Author:		Jan Schulte
 *  @Date:			12.10.2014
 *  @Description:	Wrappes the Tooltip Screen
 */

include("scripts/ui/screens/tooltip/tooltip_events_stub")

tooltip_screen <-
{

	// Member variables - do not directly access from the outside - use getter/setter
	// **********************************************************************************************************************************
	m =
	{
		JSHandle		= null
		
		// module handles
		Tooltip			= null
        TooltipEvents	= null

		// states
		Visible			= null
	}

	// Properties
	// **********************************************************************************************************************************
	function isVisible()
	{
		return m.Visible != null && m.Visible == true;
	}

	function getTooltip()
	{
		return m.Tooltip;
	}

    function getTooltipEvents()
	{
		return m.TooltipEvents;
	}


	// Callbacks
	// **********************************************************************************************************************************
	function clearEventListener()
	{
	}


	// Methods
	// **********************************************************************************************************************************
	function create()
	{
		m.Visible = false;

		// create the ui object
		m.JSHandle = UI.connect("TooltipScreen", this);

		// create the Tooltip module and connect to it
		m.Tooltip = new("scripts/ui/screens/tooltip/modules/tooltip");
		m.Tooltip.connectUI(m.JSHandle);

        // create the Tooltip Events handler
        m.TooltipEvents <- TooltipEventsStub();
        m.Tooltip.setOnQueryTileTooltipDataListener(m.TooltipEvents.onQueryTileTooltipData);
        m.Tooltip.setOnQueryEntityTooltipDataListener(m.TooltipEvents.onQueryEntityTooltipData);
		m.Tooltip.setOnQueryRosterEntityTooltipDataListener(m.TooltipEvents.onQueryRosterEntityTooltipData);
		m.Tooltip.setOnQuerySkillTooltipDataListener(m.TooltipEvents.onQuerySkillTooltipData);
        m.Tooltip.setOnQueryStatusEffectTooltipDataListener(m.TooltipEvents.onQueryStatusEffectTooltipData);
		m.Tooltip.setOnQuerySettlementStatusEffectTooltipDataListener(m.TooltipEvents.onQuerySettlementStatusEffectTooltipData);
        m.Tooltip.setOnQueryUIElementTooltipDataListener(m.TooltipEvents.onQueryUIElementTooltipData);
        m.Tooltip.setOnQueryUIItemTooltipDataListener(m.TooltipEvents.onQueryUIItemTooltipData);
        m.Tooltip.setOnQueryUIPerkTooltipDataListener(m.TooltipEvents.onQueryUIPerkTooltipData);
		m.Tooltip.setOnQueryFollowerTooltipDataListener(m.TooltipEvents.onQueryFollowerTooltipData);

		// make the Tooltip module & Events globaly available
		local gt = getroottable();
		gt.Tooltip <- WeakTableRef(m.Tooltip);
		gt.TooltipEvents <- WeakTableRef(m.TooltipEvents.TooltipEvents);

        // set screen visible
        show();
	}

	function destroy()
	{
		clearEventListener();

		local gt = getroottable();

		// clean up the modules
		m.Tooltip.destroy();
		m.Tooltip = null;

        m.TooltipEvents.destroy();
		m.TooltipEvents = null;

		gt.Tooltip = null;
        gt.TooltipEvents = null;

		// destroy the ui object
		m.JSHandle = UI.disconnect(m.JSHandle);
	}
	

	// UI Methods
	// **********************************************************************************************************************************
	function show()
	{
	    if (m.JSHandle != null && !isVisible())
        {
		    m.JSHandle.asyncCall("show", null);
		}
	}
	
	function hide()
	{
	    if (m.JSHandle != null && isVisible())
        {
            m.JSHandle.asyncCall("hide", null);
        }
	}


	// UI Events
	// **********************************************************************************************************************************
	function onScreenConnected()
	{

	}

	function onScreenDisconnected()
	{

	}

    function onScreenShown()
    {
        m.Visible = true;
    }

    function onScreenHidden()
    {
        m.Visible = false;
    }
}