local spawnEntity = ::Tactical.spawnEntity;
::Tactical.spawnEntity = {
	function spawnEntity( vargv, ... )
	{
		vargv.insert(0, this);
		local e = spawnEntity.acall(vargv);

		if (::isKindOf(e, "actor"))
		{
			::Time.scheduleEvent(::TimeUnit.Virtual, 1, ::Tactical.Entities.RF_onSpawn, e);
		}

		return e;
	}

}.spawnEntity;
local addEntityToMap = ::Tactical.addEntityToMap;
::Tactical.addEntityToMap = {
	function addEntityToMap( _entity, _x, _y )
	{
		addEntityToMap(_entity, _x, _y);

		if (::isKindOf(_entity, "actor"))
		{
			::Time.scheduleEvent(::TimeUnit.Virtual, 1, ::Tactical.Entities.RF_onSpawn, _entity);
		}
	}

}.addEntityToMap;
::Reforged.HooksMod.hook("scripts/skills/skill", function ( q )
{
	q.onActorSpawned <- {
		function onActorSpawned( _entity )
		{
		}

	}.onActorSpawned;
});
::Reforged.HooksMod.hook("scripts/skills/skill_container", function ( q )
{
	q.onActorSpawned <- {
		function onActorSpawned( _entity )
		{
			this.callSkillsFunction("onActorSpawned", [
				_entity
			]);
		}

	}.onActorSpawned;
});
::Reforged.HooksMod.hook("scripts/entity/tactical/tactical_entity_manager", function ( q )
{
	q.RF_onSpawn <- {
		function RF_onSpawn( _actor )
		{
			if (_actor.getFlags().has("RF_HasOnSpawnBeenCalled"))
			{
				return;
			}

			_actor.getFlags().set("RF_HasOnSpawnBeenCalled", true);
			_actor.onSpawned();

			foreach( faction in ::Tactical.Entities.getAllInstances() )
			{
				foreach( actor in faction )
				{
					actor.getSkills().onActorSpawned(_actor);
				}
			}
		}

	}.RF_onSpawn;
});
::Reforged.HooksMod.hook("scripts/entity/tactical/actor", function ( q )
{
	q.onSpawned <- {
		function onSpawned()
		{
		}

	}.onSpawned;
});
::Reforged.QueueBucket.VeryLate.push(function ()
{
	::Reforged.HooksMod.hook("scripts/entity/tactical/player", function ( q )
	{
		q.onCombatFinished = function ( __original )
		{
			return {
				function onCombatFinished()
				{
					this.getFlags().remove("RF_HasOnSpawnBeenCalled");
					__original();
				}

			}.onCombatFinished;
		};
	});
});
