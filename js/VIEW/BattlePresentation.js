global.BattlePresentation = CLASS({
	
	preset : () => {
		return VIEW;
	},
	
	init : (inner, self) => {
		
		let bgm = SkyEngine.BGM({
			ogg : '/resource/bgm/attack_ship.ogg',
			mp3 : '/resource/bgm/attack_ship.mp3'
		});
		bgm.play();
		
		let bgm2 = SkyEngine.BGM({
			ogg : '/resource/sound/attack_ship_ambience.ogg',
			mp3 : '/resource/sound/attack_ship_ambience.mp3'
		});
		bgm2.play();
		
		let rootNode;
		inner.on('paramsChange', (params) => {
			
			let transactionAddress = params.transactionAddress;
			
			if (rootNode !== undefined) {
				rootNode.remove();
			}
			
			let description;
			rootNode = SkyEngine.Node({
				c : [
				
				SkyEngine.Background({
					speedX : -10,
					src : '/resource/ui/background.png'
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
							ko : '교전 중...'
						})
					})
				}),
				SkyEngine.Image({
					y : -600,
					src : '/resource/ui/titlebar.png'
				}),
				
				SkyEngine.Image({
					x : 700,
					src : '/resource/battle/unknown.png'
				}),
				
				SkyEngine.Node({
					y : 580,
					dom : description = P({
						style : {
							textAlign : 'center',
							fontSize : 35,
							fontWeight : 'bold',
							color : '#fffff4'
						}
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
			
			// 내 전함을 불러옵니다.
			WalletManager.getWalletAddress((walletAddress) => {
				
				rootNode.append(Ship({
					x : -700,
					walletAddress : walletAddress
				}));
			});
			
			description.append(MSG({
				ko : '수수께끼의 우주선과 교전중입니다.'
			}));
			
			ContractController.setTransactionCallback(transactionAddress, () => {
				GO('battlewin');
			});
			
			rootNode.setAlpha(0);
			rootNode.fadeIn(2);
		});
		
		inner.on('close', () => {
			
			bgm.stop();
			bgm = undefined;
			
			bgm2.stop();
			bgm2 = undefined;
			
			rootNode.remove();
		});
	}
});
