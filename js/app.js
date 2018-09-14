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
		uri : 'invadeplanetpresentation/{planetId}/{transactionAddress}',
		target : InvadePlanetPresentation
	});
	
	MATCH_VIEW({
		uri : 'invadeplanetwin/{planetId}',
		target : InvadePlanetWin
	});
	
	MATCH_VIEW({
		uri : 'invadeplanetlose/{planetId}',
		target : InvadePlanetLose
	});
	
	MATCH_VIEW({
		uri : 'manageship',
		target : ManageShip
	});
	
	MATCH_VIEW({
		uri : 'assemble/{transactionAddress}',
		target : Assemble
	});
	
	MATCH_VIEW({
		uri : 'battle',
		target : Battle
	});
	
	MATCH_VIEW({
		uri : 'battlepresentation/{transactionAddress}',
		target : BattlePresentation
	});
});
