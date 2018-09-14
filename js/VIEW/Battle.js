global.Battle = CLASS({
	
	preset : () => {
		return VIEW;
	},
	
	init : (inner, self) => {
		
		let bgm = SkyEngine.BGM({
			ogg : '/resource/bgm/mainmenu.ogg',
			mp3 : '/resource/bgm/mainmenu.mp3'
		});
		bgm.play();
		
		let powerPanel;
		let pointPanel;
		let rootNode = SkyEngine.Node({
			c : [
			SkyEngine.Background({
				speedX : -10,
				src : '/resource/ui/background.png'
			}),
			
			// 뒤로가기
			SkyEngine.Node({
				x : -1215,
				y : -670,
				dom : A({
					c : IMG({
						src : '/resource/ui/back.png'
					}),
					on : {
						tap : () => {
							
							SOUND_ONCE({
								ogg : '/resource/sound/backbutton.ogg',
								mp3 : '/resource/sound/backbutton.mp3'
							});
							
							GO('');
						}
					}
				})
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
						ko : '전함 대전'
					})
				})
			}),
			SkyEngine.Image({
				y : -600,
				src : '/resource/ui/titlebar.png'
			}),
			
			SkyEngine.Image({
				x : -845,
				y : 30,
				src : '/resource/battle/shipinfopanel.png',
				dom : UUI.V_CENTER({
					style : {
						position : 'absolute',
						left : -403.5,
						top : 487,
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
						ko : '대전 시작'
					}),
					on : {
						tap : () => {
							
							ContractController.battle({
								transaction : (transactionAddress) => {
									GO('battlepresentation/' + transactionAddress);
								}
							});
						}
					}
				})
			}),
			
			// 공격력 및 점수
			SkyEngine.Node({
				x : -845,
				y : 400,
				dom : [powerPanel = DIV({
					style : {
						width : 600,
						fontSize : 40,
						fontWeight : 'bold',
						color : '#fff0e6',
						textAlign : 'center'
					}
				}), pointPanel = DIV({
					style : {
						marginTop : 30,
						width : 600,
						fontSize : 40,
						fontWeight : 'bold',
						color : '#fff0e6',
						textAlign : 'center'
					}
				})]
			}),
			
			SkyEngine.Node({
				x : 415,
				y : 30,
				dom : DIV({
					style : {
						width : 1670,
						height : 1214,
						backgroundImage : '/resource/planetinfo/rankpanel.png'
					},
					c : [UUI.V_CENTER({
						style : {
							flt : 'left',
							width : 835,
							height : 80,
							backgroundImage : '/resource/battle/tab.png',
							textAlign : 'center',
							fontSize : 35,
							fontWeight : 'bold',
							color : '#fff0e6',
							cursor : 'pointer'
						},
						c : MSG({
							ko : '전체'
						}),
						on : {
							tap : () => {
								SOUND_ONCE({
									ogg : '/resource/sound/tabclick.ogg',
									mp3 : '/resource/sound/tabclick.mp3'
								});
							}
						}
					}), UUI.V_CENTER({
						style : {
							flt : 'left',
							width : 835,
							height : 80,
							backgroundImage : '/resource/battle/tab.png',
							textAlign : 'center',
							fontSize : 35,
							fontWeight : 'bold',
							color : '#fff0e6',
							cursor : 'pointer'
						},
						c : MSG({
							ko : '센터'
						}),
						on : {
							tap : () => {
								SOUND_ONCE({
									ogg : '/resource/sound/tabclick.ogg',
									mp3 : '/resource/sound/tabclick.mp3'
								});
							}
						}
					}), CLEAR_BOTH(), DIV({
						style : {
							margin : 'auto',
							marginTop : 30,
							width : 1598,
							height : 1030,
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
										ko : '최후의 승리자'
									})
								})]
							}), CLEAR_BOTH()]
						})]
					})]
				})
			})
			]
		}).appendTo(SkyEngine.Screen);
		
		// 내 전함을 불러옵니다.
		WalletManager.getWalletAddress((walletAddress) => {
			
			rootNode.append(Ship({
				x : -850,
				y : -130,
				scale : 1.2,
				walletAddress : walletAddress
			}));
			
			// 전함의 공격력을 불러옵니다.
			ContractController.getShipId(walletAddress, (shipId) => {
				
				ContractController.getShipPower(shipId, (power) => {
					powerPanel.append(MSG({
						ko : '공격력'
					}) + ' ' + power);
				});
				
				ContractController.getShipInfo(shipId, (shipInfo) => {
					pointPanel.append(MSG({
						ko : shipInfo[5] + ' 점'
					}));
				});
			});
		});
		
		rootNode.setAlpha(0);
		rootNode.fadeIn(2);
		
		inner.on('close', () => {
			
			bgm.stop();
			bgm = undefined;
			
			rootNode.remove();
		});
	}
});
