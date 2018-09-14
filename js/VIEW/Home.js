global.Home = CLASS({
	
	preset : () => {
		return VIEW;
	},
	
	init : (inner, self) => {
		
		let bgm = SkyEngine.BGM({
			ogg : '/resource/bgm/mainmenu.ogg',
			mp3 : '/resource/bgm/mainmenu.mp3'
		});
		bgm.play();
		
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
							fontWeight : 'bold',
							color : '#aac4ff'
						},
						c : MSG({
							ko : '전함 관리'
						})
					}),
					on : {
						tap : () => {
							
							SOUND_ONCE({
								ogg : '/resource/sound/mainbutton.ogg',
								mp3 : '/resource/sound/mainbutton.mp3'
							});
							
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
							fontWeight : 'bold',
							color : '#aac4ff'
						},
						c : MSG({
							ko : '행성 정벌'
						})
					}),
					on : {
						tap : () => {
							
							SOUND_ONCE({
								ogg : '/resource/sound/mainbutton.ogg',
								mp3 : '/resource/sound/mainbutton.mp3'
							});
							
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
							fontWeight : 'bold',
							color : '#aac4ff'
						},
						c : MSG({
							ko : '전함 대전'
						})
					}),
					on : {
						tap : () => {
							
							SOUND_ONCE({
								ogg : '/resource/sound/mainbutton.ogg',
								mp3 : '/resource/sound/mainbutton.mp3'
							});
							
							GO('battle');
						}
					}
				})
			}),
			
			SkyEngine.Node({
				y : 650,
				dom : P({
					style : {
						width : 1280,
						fontSize : 40,
						fontWeight : 'bold',
						color : '#70798d',
						textAlign : 'center'
					},
					c : 'Developed by BTNcafe in SKT Bloackchain Hackathon 2018'
				})
			})]
		}).appendTo(SkyEngine.Screen);
		
		rootNode.setAlpha(0);
		rootNode.fadeIn(2);
		
		inner.on('close', () => {
			
			bgm.stop();
			bgm = undefined;
			
			rootNode.remove();
		});
	}
});
