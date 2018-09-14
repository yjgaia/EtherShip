global.ManageShip = CLASS({
	
	preset : () => {
		return VIEW;
	},
	
	init : (inner, self) => {
		
		let bgm = SkyEngine.BGM({
			ogg : '/resource/bgm/ship_manage.ogg',
			mp3 : '/resource/bgm/ship_manage.mp3'
		});
		bgm.play();
		
		let selectedCenterPartId = 0;
		let selectedRearPartId = 0;
		let selectedFrontPartId = 0;
		let selectedTopPartId = 0;
		let selectedBottomPartId = 0;
		
		let powerPanel;
		let partList;
		let centerPartPanel;
		let rearPartPanel;
		let frontPartPanel;
		let topPartPanel;
		let bottomPartPanel;
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
						ko : '전함 관리'
					})
				})
			}),
			SkyEngine.Image({
				y : -600,
				src : '/resource/ui/titlebar.png'
			}),
			
			// 조립하기 버튼
			SkyEngine.Node({
				x : -980,
				y : 600,
				dom : UUI.V_CENTER({
					style : {
						width : 485,
						height : 107,
						backgroundImage : '/resource/manageship/assembleon.png',
						textAlign : 'center',
						fontSize : 40,
						fontWeight : 'bold',
						color : '#fff0e6',
						cursor : 'pointer'
					},
					c : MSG({
						ko : '조립하기'
					}),
					on : {
						tap : () => {
							ContractController.assembleShip(selectedCenterPartId, selectedFrontPartId, selectedRearPartId, selectedTopPartId, selectedBottomPartId, {
								transaction : (transactionAddress) => {
									GO({
										uri : 'assemble/' + transactionAddress,
										data : {
											centerPartId : selectedCenterPartId,
											frontPartId : selectedFrontPartId,
											rearPartId : selectedRearPartId,
											topPartId : selectedTopPartId,
											bottomPartId : selectedBottomPartId
										}
									});
								}
							});
						}
					}
				})
			}),
			
			// 공격력
			SkyEngine.Node({
				x : -920,
				y : 480,
				dom : powerPanel = DIV({
					style : {
						width : 600,
						fontSize : 50,
						fontWeight : 'bold',
						color : '#fff0e6'
					}
				})
			}),
			
			// 장착한 아이템들
			SkyEngine.Node({
				x : -580,
				y : 410,
				c : [SkyEngine.Node({
					dom : centerPartPanel = DIV({
						style : {
							width : 160,
							height : 160,
							backgroundImage : '/resource/manageship/item.png'
						}
					})
				}), SkyEngine.Node({
					x : 160,
					dom : frontPartPanel = DIV({
						style : {
							width : 160,
							height : 160,
							backgroundImage : '/resource/manageship/item.png'
						}
					})
				}), SkyEngine.Node({
					x : -160,
					dom : rearPartPanel = DIV({
						style : {
							width : 160,
							height : 160,
							backgroundImage : '/resource/manageship/item.png'
						}
					})
				}), SkyEngine.Node({
					y : -160,
					dom : topPartPanel = DIV({
						style : {
							width : 160,
							height : 160,
							backgroundImage : '/resource/manageship/item.png'
						}
					})
				}), SkyEngine.Node({
					y : 160,
					dom : bottomPartPanel = DIV({
						style : {
							width : 160,
							height : 160,
							backgroundImage : '/resource/manageship/item.png'
						}
					})
				})]
			}),
			
			// 보관함
			SkyEngine.Node({
				x : 500,
				y : -60,
				dom : DIV({
					style : {
						width : 1500,
						height : 1059,
						backgroundImage : '/resource/manageship/inventory.png'
					},
					c : [UUI.V_CENTER({
						style : {
							flt : 'left',
							width : 250,
							height : 81,
							backgroundImage : '/resource/manageship/taboff.png',
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
							width : 250,
							height : 81,
							backgroundImage : '/resource/manageship/taboff.png',
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
					}), UUI.V_CENTER({
						style : {
							flt : 'left',
							width : 250,
							height : 81,
							backgroundImage : '/resource/manageship/taboff.png',
							textAlign : 'center',
							fontSize : 35,
							fontWeight : 'bold',
							color : '#fff0e6',
							cursor : 'pointer'
						},
						c : MSG({
							ko : '리어'
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
							width : 250,
							height : 81,
							backgroundImage : '/resource/manageship/taboff.png',
							textAlign : 'center',
							fontSize : 40,
							fontWeight : 'bold',
							color : '#fff0e6',
							cursor : 'pointer'
						},
						c : MSG({
							ko : '프론트'
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
							width : 250,
							height : 81,
							backgroundImage : '/resource/manageship/taboff.png',
							textAlign : 'center',
							fontSize : 35,
							fontWeight : 'bold',
							color : '#fff0e6',
							cursor : 'pointer'
						},
						c : MSG({
							ko : '탑'
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
							width : 250,
							height : 81,
							backgroundImage : '/resource/manageship/taboff.png',
							textAlign : 'center',
							fontSize : 35,
							fontWeight : 'bold',
							color : '#fff0e6',
							cursor : 'pointer'
						},
						c : MSG({
							ko : '바텀'
						}),
						on : {
							tap : () => {
								SOUND_ONCE({
									ogg : '/resource/sound/tabclick.ogg',
									mp3 : '/resource/sound/tabclick.mp3'
								});
							}
						}
					}), CLEAR_BOTH(),
					
					partList = DIV()]
				})
			})]
		}).appendTo(SkyEngine.Screen);
		
		// 내 전함을 불러옵니다.
		WalletManager.getWalletAddress((walletAddress) => {
			
			rootNode.append(Ship({
				x : -850,
				y : -100,
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
			});
		});
		
		// 내 부품들을 불러옵니다.
		ContractController.getMyPartCount((partCount) => {
			REPEAT(partCount, (i) => {
				ContractController.getMyPartId(i, (partId) => {
					ContractController.getPartInfo(partId, (partInfo) => {
						
						let partItem;
						partList.append(partItem = DIV({
							style : {
								margin : 5,
								flt : 'left',
								padding : 20,
								width : 200,
								height : 310,
								backgroundImage : '/resource/manageship/listitem.png',
								cursor : 'pointer'
							},
							c : [DIV({
								style : {
									width : 200,
									height : 200,
									backgroundImage : '/resource/part/' + partInfo[2] + '/' + partInfo[3] + '.png',
									backgroundSize : 'contain',
									backgroundPosition : 'center center',
									backgroundRepeat : 'no-repeat'
								}
							}), H5({
								style : {
									marginTop : 20,
									textAlign : 'center',
									fontSize : 35,
									fontWeight : 'bold',
									color : '#fff0e6'
								},
								c : partInfo[3]
							}), P({
								style : {
									textAlign : 'center',
									fontSize : 35,
									fontWeight : 'bold',
									color : '#fff0e6'
								},
								c : MSG({
									ko : '공격력'
								}) + ' ' + partInfo[5]
							})],
							on : {
								tap : () => {
									
									// center
									if (partInfo[2] === 0) {
										selectedCenterPartId = partId;
										
										partItem.addStyle({
											backgroundImage : '/resource/manageship/listitemselected.png'
										});
										centerPartPanel.addStyle({
											backgroundImage : '/resource/manageship/itemchange.png'
										});
										
										centerPartPanel.empty();
										centerPartPanel.append(DIV({
											style : {
												width : 160,
												height : 160,
												backgroundImage : '/resource/part/' + partInfo[2] + '/' + partInfo[3] + '.png',
												backgroundSize : 'contain',
												backgroundPosition : 'center center',
												backgroundRepeat : 'no-repeat'
											}
										}));
									}
									
									// front
									else if (partInfo[2] === 1) {
										selectedFrontPartId = partId;
										
										partItem.addStyle({
											backgroundImage : '/resource/manageship/listitemselected.png'
										});
										frontPartPanel.addStyle({
											backgroundImage : '/resource/manageship/itemchange.png'
										});
										
										frontPartPanel.empty();
										frontPartPanel.append(DIV({
											style : {
												width : 160,
												height : 160,
												backgroundImage : '/resource/part/' + partInfo[2] + '/' + partInfo[3] + '.png',
												backgroundSize : 'contain',
												backgroundPosition : 'center center',
												backgroundRepeat : 'no-repeat'
											}
										}));
									}
									
									// rear
									else if (partInfo[2] === 2) {
										selectedRearPartId = partId;
										
										partItem.addStyle({
											backgroundImage : '/resource/manageship/listitemselected.png'
										});
										rearPartPanel.addStyle({
											backgroundImage : '/resource/manageship/itemchange.png'
										});
										
										rearPartPanel.empty();
										rearPartPanel.append(DIV({
											style : {
												width : 160,
												height : 160,
												backgroundImage : '/resource/part/' + partInfo[2] + '/' + partInfo[3] + '.png',
												backgroundSize : 'contain',
												backgroundPosition : 'center center',
												backgroundRepeat : 'no-repeat'
											}
										}));
									}
									
									// top
									else if (partInfo[2] === 3) {
										selectedTopPartId = partId;
										
										partItem.addStyle({
											backgroundImage : '/resource/manageship/listitemselected.png'
										});
										topPartPanel.addStyle({
											backgroundImage : '/resource/manageship/itemchange.png'
										});
										
										topPartPanel.empty();
										topPartPanel.append(DIV({
											style : {
												width : 160,
												height : 160,
												backgroundImage : '/resource/part/' + partInfo[2] + '/' + partInfo[3] + '.png',
												backgroundSize : 'contain',
												backgroundPosition : 'center center',
												backgroundRepeat : 'no-repeat'
											}
										}));
									}
									
									// bottom
									else if (partInfo[2] === 4) {
										selectedBottomPartId = partId;
										
										partItem.addStyle({
											backgroundImage : '/resource/manageship/listitemselected.png'
										});
										bottomPartPanel.addStyle({
											backgroundImage : '/resource/manageship/itemchange.png'
										});
										
										bottomPartPanel.empty();
										bottomPartPanel.append(DIV({
											style : {
												width : 160,
												height : 160,
												backgroundImage : '/resource/part/' + partInfo[2] + '/' + partInfo[3] + '.png',
												backgroundSize : 'contain',
												backgroundPosition : 'center center',
												backgroundRepeat : 'no-repeat'
											}
										}));
									}
								}
							}
						}));
					});
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
