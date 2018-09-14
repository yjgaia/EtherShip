global.ContractController = OBJECT({

	init : (inner, self) => {
		
		let contract;
		let eventMap = {};
		
		let setContract = self.setContract = (_contract) => {
			contract = _contract;
			
			contract.allEvents((error, info) => {
				
				if (error === TO_DELETE) {
					
					let eventHandlers = eventMap[info.event];
		
					if (eventHandlers !== undefined) {
						EACH(eventHandlers, (eventHandler) => {
							eventHandler(info.args);
						});
					}
				}
			});
		};
		
		let func = (f) => {
			return function() {
				if (WalletManager.checkIsEnable() !== true) {
					// 메타마스크가 설치되어 있지 않는 경우
					
				} else {
					f.apply(undefined, arguments);
				}
			};
		};
		
		let callbackWrapper = (callbackOrHandlers) => {
			
			let callback;
			let errorHandler;
			
			if (CHECK_IS_DATA(callbackOrHandlers) !== true) {
				callback = callbackOrHandlers;
			} else {
				callback = callbackOrHandlers.success;
				errorHandler = callbackOrHandlers.error;
			}
			
			return (error, result) => {
				
				// 계약 실행 오류 발생
				if (error !== TO_DELETE) {
					if (errorHandler !== undefined) {
						errorHandler(error.toString());
					} else {
						alert(error.toString());
					}
				}
				
				// 정상 작동
				else if (CHECK_IS_ARRAY(result) === true) {
					EACH(result, (value, i) => {
						if (value.toNumber !== undefined) {
							result[i] = value.toNumber();
						}
					});
					callback(result);
				}
				
				else {
					if (result.toNumber !== undefined) {
						result = result.toNumber();
					}
					callback(result);
				}
			};
		};
		
		let toStringCallbackWrapper = (callbackOrHandlers) => {
			
			let callback;
			let errorHandler;
			
			if (CHECK_IS_DATA(callbackOrHandlers) !== true) {
				callback = callbackOrHandlers;
			} else {
				callback = callbackOrHandlers.success;
				errorHandler = callbackOrHandlers.error;
			}
			
			return (error, result) => {
				
				// 계약 실행 오류 발생
				if (error !== TO_DELETE) {
					if (errorHandler !== undefined) {
						errorHandler(error.toString());
					} else {
						alert(error.toString());
					}
				}
				
				// 정상 작동
				else if (CHECK_IS_ARRAY(result) === true) {
					EACH(result, (value, i) => {
						if (value.toNumber !== undefined) {
							result[i] = value.toString(10);
						}
					});
					callback(result);
				}
				
				else {
					if (result.toNumber !== undefined) {
						result = result.toString(10);
					}
					callback(result);
				}
			};
		};
		
		let transactionCallbackWrapper = (callbackOrHandlers) => {
			
			let callback;
			let errorHandler;
			let transactionHandler;
			
			if (CHECK_IS_DATA(callbackOrHandlers) !== true) {
				callback = callbackOrHandlers;
			} else {
				callback = callbackOrHandlers.success;
				errorHandler = callbackOrHandlers.error;
				transactionHandler = callbackOrHandlers.transaction;
			}
			
			return (error, result) => {
				
				// 계약 실행 오류 발생
				if (error !== TO_DELETE) {
					if (errorHandler !== undefined) {
						errorHandler(error.toString());
					} else {
						alert(error.toString());
					}
				}
				
				// 정상 작동
				else {
					
					if (transactionHandler !== undefined) {
						transactionHandler(result);
					}
					
					if (callback !== undefined) {
						
						let retry = RAR(() => {
							
							web3.eth.getTransactionReceipt(result, (error, result) => {
								
								// 트랜잭선 오류 발생
								if (error !== TO_DELETE) {
									if (errorHandler !== undefined) {
										errorHandler(error.toString());
									} else {
										alert(error.toString());
									}
								}
								
								// 아무런 값이 없으면 재시도
								else if (result === TO_DELETE) {
									retry();
								}
								
								// 트랜잭션 완료
								else {
									callback();
								}
							});
						});
					}
				}
			};
		};
		
		let setTransactionCallback = self.setTransactionCallback = (transactionAddress, callbackOrHandlers) => {
			
			let callback;
			let errorHandler;
			
			if (CHECK_IS_DATA(callbackOrHandlers) !== true) {
				callback = callbackOrHandlers;
			} else {
				callback = callbackOrHandlers.success;
				errorHandler = callbackOrHandlers.error;
			}
			
			let retry = RAR(() => {
				
				web3.eth.getTransactionReceipt(transactionAddress, (error, result) => {
					
					// 트랜잭선 오류 발생
					if (error !== TO_DELETE) {
						if (errorHandler !== undefined) {
							errorHandler(error.toString());
						} else {
							alert(error.toString());
						}
					}
					
					// 아무런 값이 없으면 재시도
					else if (result === TO_DELETE) {
						retry();
					}
					
					// 트랜잭션 완료
					else {
						callback();
					}
				});
			});
		};
		
		let on = self.on = (eventName, eventHandler) => {
			//REQUIRED: eventName
			//REQUIRED: eventHandler
			
			if (eventMap[eventName] === undefined) {
				eventMap[eventName] = [];
			}

			eventMap[eventName].push(eventHandler);
		};

		let off = self.off = (eventName, eventHandler) => {
			//REQUIRED: eventName
			//OPTIONAL: eventHandler

			if (eventMap[eventName] !== undefined) {

				if (eventHandler !== undefined) {

					REMOVE({
						array: eventMap[eventName],
						value: eventHandler
					});
				}

				if (eventHandler === undefined || eventMap[eventName].length === 0) {
					delete eventMap[eventName];
				}
			}
		};
		
		let name = self.name = func((callback) => {
			contract.name(callbackWrapper(callback));
		});
		
		let symbol = self.symbol = func((callback) => {
			contract.symbol(callbackWrapper(callback));
		});
		
		// 행성 정보를 반환합니다.
		let getPlanetInfo = self.getPlanetInfo = func((planetId, callback) => {
			contract.planets(planetId, callbackWrapper(callback));
		});
		
		// 행성의 전리품 목록을 반환합니다.
		let getPlanetPartOriginIds = self.getPlanetPartOriginIds = func((planetId, callback) => {
			contract.getPlanetPartOriginIds(planetId, callbackWrapper(callback));
		});
		
		// 부품 원본 정보를 반환합니다.
		let getPartOriginInfo = self.getPartOriginInfo = func((partOriginId, callback) => {
			contract.partOrigins(partOriginId, callbackWrapper(callback));
		});
		
		// 행성을 정벌합니다.
		let invadePlanet = self.invadePlanet = func((planetId, callback) => {
			contract.invadePlanet(planetId, transactionCallbackWrapper(callback));
		});
		
		// 내 부품 ID 개수를 불러옵니다.
		let getMyPartCount = self.getMyPartCount = func((callback) => {
			WalletManager.getWalletAddress((walletAddress) => {
				contract.balanceOf(walletAddress, callbackWrapper(callback));
			});
		});
		
		// 내 부품 ID를 불러옵니다.
		let getMyPartId = self.getMyPartId = func((index, callback) => {
			WalletManager.getWalletAddress((walletAddress) => {
				contract.masterToPartIds(walletAddress, index, callbackWrapper(callback));
			});
		});
		
		// 특정 유저의 전함의 ID를 불러옵니다.
		let getShipId = self.getShipId = func((walletAddress, callback) => {
			contract.masterToShipId(walletAddress, callbackWrapper(callback));
		});
		
		// 전함의 주인을 불러옵니다.
		let getMasterByShipId = self.getMasterByShipId = func((shipId, callback) => {
			contract.shipIdToMaster(shipId, callbackWrapper(callback));
		});
		
		// 전함의 정보를 불러옵니다.
		let getShipInfo = self.getShipInfo = func((shipId, callback) => {
			contract.ships(shipId, callbackWrapper(callback));
		});
		
		// 부품의 정보를 불러옵니다.
		let getPartInfo = self.getPartInfo = func((partId, callback) => {
			contract.parts(partId, callbackWrapper(callback));
		});
		
		// 전함의 공격력을 불러옵니다.
		let getShipPower = self.getShipPower = func((shipId, callback) => {
			contract.getShipPower(shipId, callbackWrapper(callback));
		});
		
		// 전함을 조립합니다.
		let assembleShip = self.assembleShip = func((centerPartId, frontPartId, rearPartId, topPartId, bottomPartId, callback) => {
			contract.assembleShip(centerPartId, frontPartId, rearPartId, topPartId, bottomPartId, transactionCallbackWrapper(callback));
		});
	}
});
