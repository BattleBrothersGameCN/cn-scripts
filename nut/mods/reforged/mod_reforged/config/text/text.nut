::Reforged.Text <- {
	function getNumberAsText( _number )
	{
		if (_number == 0)
		{
			return "零";
		}

		local ret = "";
		local n = _number;

		if (n < 0)
		{
			ret = "负";
			n = -n;
		}

		local units = [
			"",
			"1",
			"2",
			"3",
			"4",
			"5",
			"6",
			"7",
			"8",
			"9",
			"10",
			"11",
			"12",
			"13",
			"14",
			"15",
			"16",
			"17",
			"18",
			"19"
		];
		local tens = [
			"",
			"",
			"二",
			"三",
			"四",
			"五",
			"六",
			"七",
			"八",
			"九"
		];
		local getPart = function ( _n )
		{
			local str = "";

			if (_n >= 100)
			{
				str = str + (units[_n / 100] + " hundred");
				_n = _n % 100;

				if (_n > 0)
				{
					str = str + " and ";
				}
			}

			if (_n >= 20)
			{
				str = str + tens[_n / 10];

				if (_n % 10 > 0)
				{
					str = str + (" " + units[_n % 10]);
				}
			}
			else if (_n > 0)
			{
				str = str + units[_n];
			}

			return str;
		};

		if (n >= 1000000)
		{
			ret = ret + (getPart(n / 1000000) + " million");
			n = n % 1000000;

			if (n > 0)
			{
				ret = ret + (n < 100 ? " and " : " ");
			}
		}

		if (n >= 1000)
		{
			ret = ret + (getPart(n / 1000) + " thousand");
			n = n % 1000;

			if (n > 0)
			{
				ret = ret + (n < 100 ? " and " : " ");
			}
		}

		if (n > 0)
		{
			ret = ret + getPart(n);
		}

		return ret;
	}

	function getDayHourString( _seconds )
	{
		local days = ::Math.floor(_seconds / ::World.getTime().SecondsPerDay);
		local hours = ::Math.floor(_seconds / ::World.getTime().SecondsPerHour) % 24;
		local dayHourString = "";

		switch(days)
		{
		case 0:
			break;

		case 1:
			dayHourString = "一天";
			break;

		default:
			dayHourString = days + "天";
		}

		dayHourString = dayHourString + (hours == 0 ? "" : hours + "小时");
		return dayHourString;
	}

	function getDaysAndHalf( _seconds )
	{
		local doubleDays = ::Math.round(2.0 * (_seconds / ::World.getTime().SecondsPerDay));
		local daysAndHalf = doubleDays / 2.0;

		if (daysAndHalf <= 1.0)
		{
			return "一天";
		}

		if (daysAndHalf == daysAndHalf.tointeger())
		{
			return daysAndHalf + "天";
		}

		return this.getNumberAsText(daysAndHalf.tointeger()) + "天半";
	}

	function getDaysRemainingText( _numDays )
	{
		if (_numDays > 8)
		{
			return "较久";
		}

		if (_numDays >= 6)
		{
			return "一周";
		}

		if (_numDays >= 4)
		{
			return "几天";
		}

		if (_numDays >= 2)
		{
			return "两三天";
		}

		if (_numDays >= 1)
		{
			return "一天";
		}

		return "一天以内";
	}

	function getDaysAgoAsText( _numDays )
	{
		if (_numDays > 8)
		{
			return "挺久以前";
		}

		if (_numDays >= 6)
		{
			return "一周前";
		}

		if (_numDays >= 4)
		{
			return "几天前";
		}

		if (_numDays >= 2)
		{
			return "两三天前";
		}

		if (_numDays == 1)
		{
			return "昨天";
		}

		return "今天";
	}

};
