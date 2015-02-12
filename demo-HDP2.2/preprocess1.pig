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
    			CRSDepTime as time, DepDelay as delay;

        airline3 = filter airline2 by origin == '$airport_code';
	$data = foreach airline3 generate delay, month, day, dow, util.get_hour(time) as hour, distance, 
					  util.is_bad_carrier(carrier) as is_bad_carrier, 
					  util.days_from_nearest_holiday(year, month, day) as hdays;
};

ORD_2007 = preprocess('2007', 'ORD');
rmf airline/fm/ord_2007_1;
store ORD_2007 into 'airline/fm/ord_2007_1' using PigStorage(',');

ORD_2008 = preprocess('2008', 'ORD');
rmf airline/fm/ord_2008_1;
store ORD_2008 into 'airline/fm/ord_2008_1' using PigStorage(',');

