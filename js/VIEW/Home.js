global.Home = CLASS({
	
	preset : () => {
		return VIEW;
	},
	
	init : (inner, self) => {
		
		let rootNode = SkyEngine.Node({
			c : [
			
			SkyEngine.Background({
				src : '/resource/home/background.png'
			}),
			
			SkyEngine.Image({
				y : -500,
				src : '/resource/home/logo.png'
			}),
			
			SkyEngine.Node({
				x : 1200,
				y : -640,
				dom : A({
					c : IMG({
						src : '/resource/home/config.png'
					}),
					on : {
						tap : () => {
							// 설정 창 띄우기
						}
					}
				})
			}),
			
			SkyEngine.Node({
				x : -740,
				dom : A({
					style : {
						display : 'block',
						width : 660,
						height : 542,
						backgroundImage : '/resource/home/manageship.png',
						textAlign : 'center'
					},
					c : H3({
						style : {
							paddingTop : 20,
							fontSize : 50,
							fontWeight : 'bold'
						},
						c : MSG({
							ko : '전함 관리'
						})
					}),
					on : {
						tap : () => {
							GO('manageship');
						}
					}
				})
			}),
			
			SkyEngine.Node({
				dom : A({
					style : {
						display : 'block',
						width : 660,
						height : 542,
						backgroundImage : '/resource/home/invadeplanet.png',
						textAlign : 'center'
					},
					c : H3({
						style : {
							paddingTop : 20,
							fontSize : 50,
							fontWeight : 'bold'
						},
						c : MSG({
							ko : '행성 정벌'
						})
					}),
					on : {
						tap : () => {
							GO('selectplanet');
						}
					}
				})
			}),
			
			SkyEngine.Node({
				x : 740,
				dom : A({
					style : {
						display : 'block',
						width : 660,
						height : 542,
						backgroundImage : '/resource/home/battle.png',
						textAlign : 'center'
					},
					c : H3({
						style : {
							paddingTop : 20,
							fontSize : 50,
							fontWeight : 'bold'
						},
						c : MSG({
							ko : '전함 대전'
						})
					}),
					on : {
						tap : () => {
							GO('battle');
						}
					}
				})
			})]
		}).appendTo(SkyEngine.Screen);
		
		inner.on('close', () => {
			rootNode.remove();
		});
	}
});
