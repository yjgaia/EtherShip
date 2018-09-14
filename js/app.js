RUN(() => {
	
	MATCH_VIEW({
		uri : '',
		target : Home
	});
	
	MATCH_VIEW({
		uri : ['selectplanet', 'planet/{planetId}'],
		target : SelectPlanet
	});
	
	MATCH_VIEW({
		uri : 'planet/{planetId}',
		target : PlanetInfo
	});
	
	MATCH_VIEW({
		uri : 'battle',
		target : Battle
	});
});
