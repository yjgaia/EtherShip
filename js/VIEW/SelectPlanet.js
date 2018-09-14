global.SelectPlanet = CLASS({
	
	preset : () => {
		return VIEW;
	},
	
	init : (inner, self) => {
		
		let rootNode = SkyEngine.Node({
			c : []
		}).appendTo(SkyEngine.Screen);
		
		inner.on('close', () => {
			rootNode.remove();
		});
	}
});
