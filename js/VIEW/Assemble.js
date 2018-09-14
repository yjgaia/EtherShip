global.Assemble = CLASS({
	
	preset : () => {
		return VIEW;
	},
	
	init : (inner, self, previewShipParams) => {
		
		let rootNode;
		inner.on('paramsChange', (params) => {
			
			let transactionAddress = params.transactionAddress;
			
			if (rootNode !== undefined) {
				rootNode.remove();
			}
			
			rootNode = SkyEngine.Node({
				c : [
				
				SkyEngine.Background({
					y : 110,
					src : '/resource/assemble/background.png'
				}),
				
				// 타이틀
				SkyEngine.Node({
					y : -660,
					dom : H2({
						style : {
							textAlign : 'center',
							fontSize : 60,
							fontWeight : 'bold',
							color : '#fffff4'
						},
						c : MSG({
							ko : '조립중...'
						})
					})
				}),
				SkyEngine.Image({
					y : -600,
					src : '/resource/ui/titlebar.png'
				}),
				
				PreviewShip(previewShipParams),
				
				SkyEngine.Node({
					dom : IMG({
						src : '/resource/ui/loading.gif'
					})
				}),
				
				SkyEngine.Node({
					y : 580,
					dom : P({
						style : {
							textAlign : 'center',
							fontSize : 35,
							fontWeight : 'bold',
							color : '#fffff4'
						},
						c : MSG({
							ko : '전함을 조립하고 있습니다...'
						})
					})
				}),
				
				SkyEngine.Node({
					y : 640,
					dom : DIV({
						style : {
							textAlign : 'center',
							fontSize : 30,
							fontWeight : 'bold',
							color : '#7c6e34'
						},
						c : 'https://etherscan.io/tx/' + transactionAddress
					})
				})]
			}).appendTo(SkyEngine.Screen);
			
			ContractController.setTransactionCallback(transactionAddress, () => {
				GO('manageship');
			});
		});
		
		inner.on('close', () => {
			rootNode.remove();
		});
	}
});
