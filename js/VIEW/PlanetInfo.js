global.PlanetInfo = CLASS({
	
	preset : () => {
		return VIEW;
	},
	
	init : (inner, self) => {
		
		let rootNode;
		
		inner.on('paramsChange', (params) => {
			
			let planetId = params.planetId;
			
			console.log(planetId);
			
			if (rootNode !== undefined) {
				rootNode.remove();
			}
			
			rootNode = SkyEngine.Node({
				c : [
				SkyEngine.Node({
					dom : DIV({
						style : {
							width : 1280 * 2,
							height : 720 * 2
						}
					})
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
								GO('selectplanet');
							}
						}
					})
				}),
				
				SkyEngine.Node({
					x : -845,
					y : 30,
					dom : DIV({
						style : {
							position : 'relative',
							width : 801,
							height : 1214,
							backgroundImage : '/resource/planetinfo/infopanel.png'
						},
						c : [UUI.V_CENTER({
							style : {
								height : 530
							},
							c : UUI.BUTTON({
								style : {
									cursor : 'default'
								},
								icon : IMG({
									style : {
										maxHeight : 400
									},
									src : '/resource/ui/' + planetId + '.png'
								}),
								spacing : 20,
								title : H4({
									style : {
										fontSize : 40,
										fontWeight : 'bold',
										color : '#fff0e6'
									},
									c : 'Ripple'
								})
							})
						}), P({
							style : {
								margin : 'auto',
								marginTop : 25,
								width : 700,
								height : 160,
								fontSize : 35,
								fontWeight : 'bold',
								color : '#fff0e6',
								lineHeight : '1.8em'
							},
							c : MSG(PlanetDescriptions[planetId].description)
						}), P({
							style : {
								margin : 'auto',
								width : 700,
								height : 110,
								fontSize : 35,
								fontWeight : 'bold',
								color : '#fff0e6',
								lineHeight : '1.8em'
							},
							c : MSG({
								ko : '인구 수'
							}) + ' : ' + MSG(PlanetDescriptions[planetId].population)
						}), UUI.V_CENTER({
							style : {
								margin : 'auto',
								width : 700,
								height : 105,
								fontSize : 35,
								fontWeight : 'bold',
								color : '#fff0e6',
								textAlign : 'center'
							},
							c : MSG({
								ko : '약탈할 수 있는 부품 목록'
							})
						}), UUI.V_CENTER({
							style : {
								position : 'absolute',
								left : 0,
								bottom : 0,
								width : 807,
								height : 120,
								backgroundImage : '/resource/planetinfo/startinvasion.png',
								fontSize : 35,
								fontWeight : 'bold',
								color : '#fff0e6',
								textAlign : 'center',
								cursor : 'pointer'
							},
							c : MSG({
								ko : '정벌 시작'
							}),
							on : {
								tap : () => {
									//TODO:
								}
							}
						})]
					})
				}),
				
				SkyEngine.Node({
					x : 415,
					y : 30,
					dom : DIV({
						style : {
							width : 1669,
							height : 1214,
							backgroundImage : '/resource/planetinfo/rankpanel.png'
						},
						c : [H2({
							style : {
								margin : 'auto',
								width : 1498,
								padding : '40px 0',
								fontSize : 35,
								fontWeight : 'bold',
								color : '#fff0e6',
								textAlign : 'center',
								cursor : 'pointer'
							},
							c : MSG({
								ko : '정벌 랭킹'
							})
						}), DIV({
							style : {
								margin : 'auto',
								width : 1598,
								height : 1060,
								overflowY : 'auto'
							},
							c : [DIV({
								style : {
									margin : 'auto',
									marginBottom : 10,
									width : 1498,
									height : 177,
									backgroundImage : '/resource/planetinfo/ranklist.png'
								},
								c : [UUI.V_CENTER({
									style : {
										flt : 'left',
										width : 120,
										height : '100%',
										fontSize : 50,
										fontWeight : 'bold',
										color : '#675b2b',
										textAlign : 'center'
									},
									c : 1
								}), UUI.V_CENTER({
									style : {
										flt : 'right',
										width : 1378,
										height : '100%',
										fontSize : 35,
										fontWeight : 'bold',
										color : '#fff0e6',
										textAlign : 'center'
									},
									c : [DIV({
										c : '0xEcCFaA737a5A80bE37e4E70130628E692413cB36'
									}), DIV({
										style : {
											marginTop : 30
										},
										c : MSG({
											ko : '행성을 철저하게 망가뜨림'
										})
									})]
								}), CLEAR_BOTH()]
							})]
						})]
					})
				})]
			}).appendTo(SkyEngine.Screen);
			
			rootNode.setAlpha(0);
			rootNode.fadeIn(2);
		});
		
		inner.on('close', () => {
			rootNode.remove();
		});
	}
});
