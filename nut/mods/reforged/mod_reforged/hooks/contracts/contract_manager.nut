::Reforged.HooksMod.hook("scripts/contracts/contract_manager", function ( q )
{
	q.m.RF_LastVisitContracts <- {};
	q.update = function ( __original )
	{
		return {
			function update( _force = false )
			{
				local shouldUpdate = this.m.LastUpdateTime + 1.0 < ::Time.getVirtualTimeF();
				__original(_force);

				if (!shouldUpdate)
				{
					return;
				}

				if (!_force && ::World.State.getMenuStack().hasBacksteps())
				{
					return;
				}

				if (!_force && ("State" in ::Tactical) && ::Tactical.State != null)
				{
					return;
				}

				foreach( contracts in this.m.RF_LastVisitContracts )
				{
					for( local i = contracts.len() - 1; i >= 0; i-- )
					{
						if (contracts[i].isValid())
						{
						}
						else
						{
							local c = contracts.remove(i);

							if (c.m.SituationID == 0)
							{
							}
							else
							{
								local situationFound = false;

								foreach( settlement in ::World.EntityManager.getSettlements() )
								{
									foreach( s in settlement.m.RF_LastVisitSituations )
									{
										if (s.getInstanceID() != c.m.SituationID)
										{
											continue;
										}

										situationFound = true;

										foreach( i, con in s.m.RF_LastVisitContracts )
										{
											if (con.getID() == c.getID())
											{
												s.m.RF_LastVisitContracts.remove(i);
												break;
											}
										}

										break;
									}

									if (situationFound)
									{
										break;
									}
								}
							}
						}
					}
				}
			}

		}.update;
	};
	q.RF_getKnownContracts <- {
		function RF_getKnownContracts( _includeActive = false )
		{
			local ret;

			if (::World.Retinue.hasFollower("follower.agent"))
			{
				ret = this.getOpenContracts();
			}
			else
			{
				ret = [];

				foreach( list in this.m.RF_LastVisitContracts )
				{
					ret.extend(list);
				}

				local ids = ret.map(function ( _c )
				{
					return _c.getID();
				});
				ret.extend(this.getOpenContracts().filter(function ( _, _c )
				{
					return _c.isStarted() && ids.find(_c.getID()) == null;
				}));
				  // [033]  OP_CLOSE          0      3    0    0
			}

			if (_includeActive && !::MSU.isNull($[stack offset 0].getActiveContract()))
			{
				ret.insert(0, $[stack offset 0].getActiveContract());
			}

			return ret;
		}

	}.RF_getKnownContracts;
	q.addContract = function ( __original )
	{
		return {
			function addContract( _contract, _isNewContract = true )
			{
				if (!_isNewContract)
				{
					__original(_contract, _isNewContract);
					return;
				}

				local IDBefore = _contract.m.ID;
				__original(_contract, _isNewContract);

				if (_contract.m.ID != IDBefore && ::World.Retinue.hasFollower("follower.agent"))
				{
					_contract.RF_fakeStart();
				}
			}

		}.addContract;
	};
	q.onSerialize = function ( __original )
	{
		return {
			function onSerialize( _out )
			{
				__original(_out);
				_out.writeU16(this.m.RF_LastVisitContracts.len());

				foreach( settlementName, contracts in this.m.RF_LastVisitContracts )
				{
					_out.writeString(settlementName);
					_out.writeU8(contracts.len());

					foreach( c in contracts )
					{
						_out.writeI32(c.ClassNameHash);
						c.onSerialize(_out);
					}
				}
			}

		}.onSerialize;
	};
	q.onDeserialize = function ( __original )
	{
		return {
			function onDeserialize( _in )
			{
				__original(_in);

				if (::Reforged.Mod.Serialization.isSavedVersionAtLeast("0.8.5", _in.getMetaData()))
				{
					local situations = [];

					foreach( settlement in ::World.EntityManager.getSettlements() )
					{
						situations.extend(settlement.m.RF_LastVisitSituations);
					}

					this.m.RF_LastVisitContracts = {};
					local count = _in.readU16();

					for( local i = 0; i < count; i++ )
					{
						local settlementName = _in.readString();
						local contracts = [];
						local contractsCount = _in.readU8();

						for( local j = 0; j < contractsCount; j++ )
						{
							local c = ::new(::IO.scriptFilenameByHash(_in.readI32()));
							c.onDeserialize(_in);
							contracts.push(c);

							if (c.m.SituationID == null)
							{
							}
							else
							{
								foreach( s in situations )
								{
									if (s.getInstanceID() == c.m.SituationID)
									{
										s.m.RF_LastVisitContracts.push(::MSU.asWeakTableRef(c));
										break;
									}
								}
							}
						}

						this.m.RF_LastVisitContracts[settlementName] <- contracts;

						foreach( s in ::World.EntityManager.getSettlements() )
						{
							if (s.getName() == settlementName)
							{
								s.m.RF_LastVisitContracts = contracts;
								break;
							}
						}
					}
				}
			}

		}.onDeserialize;
	};
});
