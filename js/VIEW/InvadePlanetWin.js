global.InvadePlanetWin = CLASS({
	
	preset : () => {
		return VIEW;
	},
	
	init : (inner, self) => {
		
		let bgm = SkyEngine.BGM({
			mp3 : '/resource/bgm/win.mp3'
		});
		bgm.play();
		
		let rootNode;
		inner.on('paramsChange', (params) => {
			
			let planetId = params.planetId;
			
			if (rootNode !== undefined) {
				rootNode.remove();
			}
			
			let description;
			let takenPartPanel;
			rootNode = SkyEngine.Node({
				c : [
				
				SkyEngine.Background({
					speedX : -10,
					src : '/resource/ui/background.png'
				}),
				
				SkyEngine.Image({
					y : -550,
					src : '/resource/invasionresult/win.png'
				}),
				
				SkyEngine.Image({
					y : -200,
					src : '/resource/ui/' + planetId + '.png'
				}),
				
				SkyEngine.Node({
					y : 100,
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
					y : 200,
					dom : P({
						style : {
							textAlign : 'center',
							fontSize : 30,
							fontWeight : 'bold',
							color : '#809094'
						},
						c : MSG({
							ko : '약탈한 파츠'
						})
					})
				}),
				
				SkyEngine.Node({
					y : 350,
					dom : takenPartPanel = DIV({
						style : {
							padding : 20,
							width : 200,
							height : 200,
							backgroundImage : '/resource/manageship/assembleitem.png'
						}
					})
				}),
				
				SkyEngine.Node({
					y : 540,
					dom : UUI.V_CENTER({
						style : {
							width : 656,
							height : 82,
							backgroundImage : '/resource/invasionresult/ok.png',
							textAlign : 'center',
							fontSize : 40,
							fontWeight : 'bold',
							color : '#fffff4',
							cursor : 'pointer'
						},
						c : MSG({
							ko : '확인'
						}),
						on : {
							tap : () => {
								GO('selectplanet');
							}
						}
					})
				})]
			}).appendTo(SkyEngine.Screen);
			
			ContractController.getPlanetInfo(planetId, (planetInfo) => {
				
				description.append(MSG({
					ko : planetInfo[0] + ' 행성을 정벌하였습니다!'
				}));
			});
			
			ContractController.on('Transfer', (result) => {
				
				ContractController.getPartInfo(result._tokenId.toNumber(), (partInfo) => {
					
					takenPartPanel.append(DIV({
						style : {
							width : 200,
							height : 200,
							backgroundImage : '/resource/part/' + partInfo[2] + '/' + partInfo[3] + '.png',
							backgroundSize : 'contain',
							backgroundPosition : 'center center',
							backgroundRepeat : 'no-repeat'
						}
					}));
				});
			});
		});
		
		inner.on('close', () => {
			
			bgm.stop();
			bgm = undefined;
			
			rootNode.remove();
		});
	}
});
