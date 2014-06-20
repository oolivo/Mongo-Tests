for( i = 0 ; i < 500000; i++)
{
	loc = Math.floor(Math.random( ) * 8);

	switch(loc)
	{
		//slightly coarse boxes
		case 0: continent = 'Asia';
			lat = Math.floor(  (Math.random() * 60) + 20);
			lon = Math.floor(  (Math.random() * 140) + 40);

			if( lat < 20 || lat > 80 || lon < 40 || lon > 180)
				print("Problem with asia math");

			break;
		case 1: continent = 'North America';
			lat = Math.floor(  (Math.random() * 60  ) +20 );
			lon = Math.floor(  (Math.random() * 120 ) -180 );

			if( lat < 20 || lat > 80 || lon < -180 || lon > -60)
				print("Problem with North America math");

			break;
		case 2: continent = 'South America';
			lat = Math.floor(  (Math.random() * -65 ) + 10);
			lon = Math.floor(  (Math.random() * -35) - 45);

			if( lat < -55 || lat > 10 || lon < -80 || lon > -45)
				print("Problem with South America math");

			break;
		case 3: continent = 'Europe';
			lat = Math.floor(  (Math.random() * 22 ) + 38);
			lon = Math.floor(  (Math.random() * 49) - 10);

			if( lat < 38 || lat > 60 || lon < -10 || lon > 39)
				print("Problem with Europe math");

			break;
		case 4: continent = 'Africa';
			lat = Math.floor(  (Math.random() * 72 ) -35);
			lon = Math.floor(  (Math.random() * 59 ) - 20);

			if( lat < -35 || lat > 37 || lon < -20 || lon > 39)
				print("Problem with Africa math");

			break;
		case 5: continent = 'Australia';
			lat = Math.floor(  (Math.random() * -30 ) - 10);
			lon = Math.floor(  (Math.random() * 40 ) + 115);

			if( lat < -40 || lat > -10 || lon < 115 || lon > 155 )
				print("Problem with Australia math");

			break;
		case 6: continent = 'Antartica';
			lat = Math.floor(  (Math.random() *  -30 ) - 60);
			lon = Math.floor(  (Math.random() * 320 ) - 160);

			if( lat < -90 || lat > -60 || lon < -160 || lon > 160)
				print("Problem with Antartica  math");

			break;
		default: continent = 'Misc';
			 lat = Math.floor( ( Math.random() * 180 ) -90 );
			 lon = Math.floor( (Math.random() * 360 ) -180 );
			 if( lat < -90 || lat > 90 || lon < -180 || lon > 180)
				print("Problem with Misc  math");

	}
	filler='';
	fillAmount= Math.random()*10000;
	for( c = 0 ; c < fillAmount; c++)
		filler += 'a'; 
	
	
	db.locations.insert( { "val" :  fillAmount, 
			       "location" : { "type" : "Point", "coordinates" : [ lon, lat] },
				"region" : continent,
				"filler" : filler });	



}

print('Done!');
