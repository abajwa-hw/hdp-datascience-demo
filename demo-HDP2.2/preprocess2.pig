register 'util.py' USING jython as util;

-- Helper macro to load data and join into a feature vector per instance
DEFINE preprocess(year_str, airport_code) returns data
{
	-- load airline data from specified year (need to specify fields since it's not in HCat)
	airline = load 'airline/delay/$year_str.csv' using PigStorage(',') as (Year: int, Month: int, DayOfMonth: int, DayOfWeek: int, DepTime: chararray, CRSDepTime, ArrTime, CRSArrTime, Carrier: chararray, FlightNum, TailNum, ActualElapsedTime, CRSElapsedTime, AirTime, ArrDelay, DepDelay: int, Origin: chararray, Dest: chararray, Distance: int, TaxiIn, TaxiOut, Cancelled: int, CancellationCode, Diverted, CarrierDelay, WeatherDelay, NASDelay, SecurityDelay, LateAircraftDelay);

	-- keep only instances where flight was not cancelled
	airline_flt = filter airline by Cancelled == 0;

	-- Keep only fields I need
	airline2 = foreach airline_flt generate Year as year, Month as month, DayOfMonth as day, DayOfWeek as dow,
    			Carrier as carrier, Origin as origin, Dest as dest, Distance as distance, 
    			CRSDepTime as time, DepDelay as delay,
    			util.to_date(Year, Month, DayOfMonth) as date;

	-- load weather data
	weather = load 'airline/weather/$year_str.csv' using PigStorage(',') as (station: chararray, date: chararray, metric, value, t1, t2, t3, time);

	-- keep only TMIN and TMAX weather observations from ORD
	weather_tmin = filter weather by station == 'USW00094846' and metric == 'TMIN';
	weather_tmax = filter weather by station == 'USW00094846' and metric == 'TMAX';
	weather_prcp = filter weather by station == 'USW00094846' and metric == 'PRCP';
	weather_snow = filter weather by station == 'USW00094846' and metric == 'SNOW';
	weather_awnd = filter weather by station == 'USW00094846' and metric == 'AWND';
	
	joined = join airline2 by date, weather_tmin by date, weather_tmax by date, weather_prcp by date, weather_snow by date, weather_awnd by date;
        joined2 = filter joined by origin == '$airport_code';
	$data = foreach joined2 generate delay, month, day, dow, util.get_hour(airline2::time) as tod, distance,
			 		 util.is_bad_carrier(carrier) as is_bad_carrier,
					 util.days_from_nearest_holiday(year, month, day) as hdays,
			                 weather_tmin::value as temp_min, weather_tmax::value as temp_max,
			                 weather_prcp::value as prcp, weather_snow::value as snow, weather_awnd::value as wind; 
};

ORD_2007 = preprocess('2007', 'ORD');
rmf airline/fm/ord_2007_2;
store ORD_2007 into 'airline/fm/ord_2007_2' using PigStorage(',');

ORD_2008 = preprocess('2008', 'ORD');
rmf airline/fm/ord_2008_2;
store ORD_2008 into 'airline/fm/ord_2008_2' using PigStorage(',');

