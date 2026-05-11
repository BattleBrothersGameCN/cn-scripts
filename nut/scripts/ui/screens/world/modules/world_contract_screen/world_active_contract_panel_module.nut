this.world_active_contract_panel_module <- this.inherit("scripts/ui/screens/ui_module", {
	m = {},
	function create()
	{
		this.m.ID = "ActiveContractPanelModule";
		this.ui_module.create();
	}

	function destroy()
	{
		this.ui_module.destroy();
	}

	function show( _withSlideAnimation = false )
	{
		if (!this.isVisible() && !this.isAnimating())
		{
			this.m.JSHandle.asyncCall("show", _withSlideAnimation);
		}
	}

	function hide( _withSlideAnimation = false )
	{
		if (this.isVisible() && !this.isAnimating())
		{
			this.m.JSHandle.asyncCall("hide", _withSlideAnimation);
		}
	}

	function updateContract( _contract = null )
	{
		this.m.JSHandle.asyncCall("loadFromData", this.convertToUI(_contract));
	}

	function clearContract()
	{
		this.m.JSHandle.asyncCall("hide", false);
	}

	function onShowContractDetails()
	{
		this.World.State.showDialogPopup("取消合同", "取消一份已经生效，尤其是收了预付款的合同，将会影响你作为雇佣兵的声誉，以及和当前雇主的关系。\n\n你确定要取消吗？", this.onContractCancelled.bindenv(this), null);
	}

	function onContractCancelled()
	{
		this.World.Contracts.removeContract(this.World.Contracts.getActiveContract());
	}

	function convertToUI( _contract )
	{
		local ret = {
			Title = _contract.getTitle(),
			Lists = _contract.getUIBulletpoints()
		};
		return ret;
	}

});
