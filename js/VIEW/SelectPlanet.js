global.SelectPlanet = CLASS({
	
	preset : () => {
		return VIEW;
	},
	
	init : (inner, self) => {
		
		let rootNode = SkyEngine.Node({
			c : [
			
			SkyEngine.Background({
				speedX : -10,
				src : '/resource/ui/background.png'
			}),
			
			SkyEngine.Node({
				x : -1215,
				y : -670,
				dom : A({
					c : IMG({
						src : '/resource/ui/back.png'
					}),
					on : {
						tap : () => {
							GO('');
						}
					}
				})
			}),
			
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
						ko : '행성 정벌'
					})
				})
			}),
			
			SkyEngine.Image({
				y : -600,
				src : '/resource/ui/titlebar.png'
			}),
			
			SkyEngine.Node({
				y : -600,
				dom : P({
					style : {
						marginTop : 100,
						textAlign : 'center',
						fontSize : 40,
						fontWeight : 'bold',
						color : '#fff0e6'
					},
					c : MSG({
						ko : '정벌할 행성을 선택해주시기 바랍니다.'
					})
				})
			}),
			
			SkyEngine.Node({
				x : -900,
				y : -100,
				dom : UUI.BUTTON({
					icon : IMG({
						src : '/resource/ui/0.png'
					}),
					spacing : 20,
					title : H4({
						style : {
							fontSize : 40,
							fontWeight : 'bold',
							color : '#fff0e6'
						},
						c : 'EOS'
					}),
					on : {
						tap : () => {
							GO('planet/0');
						}
					}
				})
			}),
			
			SkyEngine.Node({
				x : -500,
				y : 200,
				dom : UUI.BUTTON({
					icon : IMG({
						src : '/resource/ui/1.png'
					}),
					spacing : 20,
					title : H4({
						style : {
							fontSize : 40,
							fontWeight : 'bold',
							color : '#fff0e6'
						},
						c : 'TRON'
					}),
					on : {
						tap : () => {
							GO('planet/1');
						}
					}
				})
			}),
			
			SkyEngine.Node({
				x : 100,
				y : 0,
				dom : UUI.BUTTON({
					icon : IMG({
						src : '/resource/ui/2.png'
					}),
					spacing : 20,
					title : H4({
						style : {
							fontSize : 40,
							fontWeight : 'bold',
							color : '#fff0e6'
						},
						c : 'Ripple'
					}),
					on : {
						tap : () => {
							GO('planet/2');
						}
					}
				})
			}),
			
			SkyEngine.Node({
				x : 400,
				y : 200,
				dom : UUI.BUTTON({
					icon : IMG({
						src : '/resource/ui/3.png'
					}),
					spacing : 20,
					title : H4({
						style : {
							fontSize : 40,
							fontWeight : 'bold',
							color : '#fff0e6'
						},
						c : 'OmiseGO'
					}),
					on : {
						tap : () => {
							GO('planet/3');
						}
					}
				})
			}),
			
			SkyEngine.Node({
				x : 900,
				y : -100,
				dom : UUI.BUTTON({
					icon : IMG({
						src : '/resource/ui/4.png'
					}),
					spacing : 20,
					title : H4({
						style : {
							fontSize : 40,
							fontWeight : 'bold',
							color : '#fff0e6'
						},
						c : 'Qtum'
					}),
					on : {
						tap : () => {
							GO('planet/4');
						}
					}
				})
			})]
		}).appendTo(SkyEngine.Screen);
		
		rootNode.setAlpha(0);
		rootNode.fadeIn(2);
		
		inner.on('close', () => {
			rootNode.remove();
		});
	}
});
