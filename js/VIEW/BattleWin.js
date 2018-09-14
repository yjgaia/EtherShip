global.BattleWin = CLASS({
	
	preset : () => {
		return VIEW;
	},
	
	init : (inner, self) => {
		
		let bgm = SkyEngine.BGM({
			ogg : '/resource/bgm/win.ogg',
			mp3 : '/resource/bgm/win.mp3'
		});
		bgm.play();
		
		let rootNode;
		inner.on('paramsChange', (params) => {
			
			if (rootNode !== undefined) {
				rootNode.remove();
			}
			
			rootNode = SkyEngine.Node({
				c : [
				
				SkyEngine.Background({
					src : '/resource/battle/sample.jpg'
				})]
			}).appendTo(SkyEngine.Screen);
			
			rootNode.setAlpha(0);
			rootNode.fadeIn(2);
		});
		
		inner.on('close', () => {
			
			bgm.stop();
			bgm = undefined;
			
			rootNode.remove();
		});
	}
});
