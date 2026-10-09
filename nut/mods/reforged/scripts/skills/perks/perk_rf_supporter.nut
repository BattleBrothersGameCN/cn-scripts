this.perk_rf_supporter <- ::inherit("scripts/skills/skill", {
	m = {
		MinDistanceAPRecovery = 1,
		ActionPointsRecovered = 3,
		IsSpent = false,
		WillRecoverActionPoints = false
	},
	function create()
	{
		this.m.ID = "perk.rf_supporter";
		this.m.Name = ::Const.Strings.PerkName.RF_Supporter;
		this.m.Description = ::Const.Strings.PerkDescription.RF_Supporter;
		this.m.Icon = "ui/perks/perk_rf_supporter.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function onAdded()
	{
		this.getContainer().add(::new("scripts/skills/actives/rf_encourage_skill"));
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.rf_encourage");
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onBeforeAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (this.m.IsSpent || _targetEntity == null)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (actor.getFaction() != _targetEntity.getFaction() || actor.getID() == _targetEntity.getID() || !actor.isPlacedOnMap() || actor.getTile().getDistanceTo(_targetTile) > this.m.MinDistanceAPRecovery)
		{
			return;
		}

		this.m.WillRecoverActionPoints = true;
		this.m.IsSpent = true;
	}

	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (this.m.WillRecoverActionPoints)
		{
			this.m.WillRecoverActionPoints = false;
			local actor = this.getContainer().getActor();
			local recoveredActionPoints = ::Math.min(actor.getActionPointsMax() - actor.getActionPoints(), this.m.ActionPointsRecovered);
			actor.setActionPoints(actor.getActionPoints() + recoveredActionPoints);
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + "恢复了" + ::MSU.Text.colorPositive(recoveredActionPoints) + "点行动点数");
		}
	}

});
