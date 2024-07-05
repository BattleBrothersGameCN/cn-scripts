this.world_screen_topbar_ambition_module <- this.inherit("scripts/ui/screens/ui_module", {
	m = {},
	function clearEventListener()
	{
	}

	function create()
	{
		this.m.ID = "TopbarAmbitionModule";
		this.ui_module.create();
	}

	function destroy()
	{
		this.clearEventListener();
		this.ui_module.destroy();
	}

	function setText( _text )
	{
		this.m.JSHandle.asyncCall("setText", _text);
	}

	function onRequestCancel()
	{
		if (!this.World.Ambitions.hasActiveAmbition())
		{
			return;
		}

		if (!this.World.Ambitions.getActiveAmbition().isCancelable())
		{
			return;
		}

		this.World.State.showDialogPopup("取消野心", "取消野心给了你重新选择的机会，却也会让手下对你的领导力失望。\n\n你确定要取消吗？", this.onCancelAmbition.bindenv(this), null);
	}

	function onCancelAmbition()
	{
		this.World.Ambitions.cancelAmbition();
	}

});
