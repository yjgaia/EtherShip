global.Home = CLASS({
	
	preset : () => {
		return VIEW;
	},
	
	init : (inner, self) => {
		
		DIV({
			c : 'test'
		}).appendTo(BODY);
		
		inner.on('close', () => {
		});
	}
});
