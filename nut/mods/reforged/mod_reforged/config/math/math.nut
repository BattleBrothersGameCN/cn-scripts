::Reforged.Math <- {
	function luckyRoll( _min, _max, _target, _luck = 0 )
	{
		local _randomNumber = ::Math.rand(_min, _max);

		while (_luck > 0)
		{
			if (::Math.rand(1, 100) <= _luck)
			{
				_randomNumber = this.__getCloser(_randomNumber, ::Math.rand(_min, _max), _target);
			}

			_luck = _luck - 100;
		}

		return _randomNumber;
	}

	function ceil( _value, _decimalPlaceOffset = 0 )
	{
		_value = _value * ::Math.pow(10, _decimalPlaceOffset);
		_value = ::Math.ceil(_value);
		_value = _value * ::Math.pow(10, -_decimalPlaceOffset);
		return _value;
	}

	function __getCloser( _oldValue, _newValue, _target )
	{
		local oldDistance = ::Math.abs(_oldValue - _target);
		local newDistance = ::Math.abs(_newValue - _target);
		return newDistance < oldDistance ? _newValue : _oldValue;
	}

	function randWithSeed( _min, _max, vargv, ... )
	{
		if (vargv.len() == 0)
		{
			throw "must pass at least one seed argument";
		}

		local preservedSeed = ::Math.rand(1, 1215752191);
		vargv.insert(0, this);
		::Reforged.Math.seedRandom.acall(vargv);
		local ret = ::Math.rand(_min, _max);
		::Math.seedRandom(preservedSeed);
		return ret;
	}

	function seedRandom( vargv, ... )
	{
		if (vargv.len() == 0)
		{
			throw "must pass at least one seed argument";
		}

		if (("Assets" in ::World) && !::MSU.isNull(::World.Assets))
		{
			vargv.push(::World.Assets.getCampaignID());
			vargv.push(::World.Assets.getSeedString());
			vargv.push(::World.Assets.getName());
		}

		local seed = 0;

		foreach( s in vargv )
		{
			switch(typeof s)
			{
			case "string":
				seed = seed + ::toHash(s);
				break;

			case "bool":
				s = s ? 2 : 1;

			case "integer":
			case "float":
				seed = seed + s * 10000;
				break;

			default:
				throw ::MSU.Exception.InvalidType(s);
			}
		}

		::Math.seedRandom(seed);
	}

	function seedRandomString( vargv, ... )
	{
		if (vargv.len() == 0)
		{
			throw "must pass at least one seed argument";
		}

		if (("Assets" in ::World) && !::MSU.isNull(::World.Assets))
		{
			vargv.push(::World.Assets.getCampaignID().tostring());
			vargv.push(::World.Assets.getSeedString());
			vargv.push(::World.Assets.getName());
		}

		local seed = "";

		foreach( s in vargv )
		{
			switch(typeof s)
			{
			case "string":
				seed = seed + s;
				break;

			case "integer":
			case "float":
				seed = seed + s.tostring();
				break;

			case "bool":
				seed = seed + (s ? "true" : "false");
				break;

			default:
				throw ::MSU.Exception.InvalidType(s);
			}
		}

		::Math.seedRandomString(seed);
	}

	function lerp( _x, _x1, _y1, _x2, _y2 )
	{
		local m = (_y2 - _y1) / (_x2 - _x1).tofloat();
		local c = _y1 - m * _x1;
		return m * _x + c;
	}

	function lerpClamp( _x, _x1, _y1, _x2, _y2 )
	{
		return this.clamp(this.lerp(_x, _x1, _y1, _x2, _y2), _y1, _y2);
	}

	function multilerp( _x, _points )
	{
		local i = 0;
		local count = _points.len() - 2;

		while (i < count && _x > _points[i + 1][0])
		{
			i++;
		}

		local p1 = _points[i];
		local p2 = _points[i + 1];
		return this.lerp(_x, p1[0], p1[1], p2[0], p2[1]);
	}

	function clamp( _value, _min, _max )
	{
		if (_min > _max)
		{
			local max = _max;
			_max = _min;
			_min = max;
		}

		local ret = _value < _min ? _min : _value > _max ? _max : _value;
		return typeof _value == "integer" ? ret.tointeger() : ret.tofloat();
	}

};
