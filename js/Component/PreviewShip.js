global.PreviewShip = CLASS({
	
	preset : () => {
		return SkyEngine.Node;
	},
	
	init : (inner, self, params) => {
		//REQUIRED: params
		//REQUIRED: params.centerPartId
		//REQUIRED: params.frontPartId
		//REQUIRED: params.rearPartId
		//REQUIRED: params.topPartId
		//REQUIRED: params.bottomPartId
		
		let centerPartId = params.centerPartId;
		let frontPartId = params.frontPartId;
		let rearPartId = params.rearPartId;
		let topPartId = params.topPartId;
		let bottomPartId = params.bottomPartId;
		
		// center
		if (centerPartId === 0) {
			self.append(ShipImage({
				zIndex : 5,
				centerX : PartImagePositions['ETR-001'].x,
				centerY : PartImagePositions['ETR-001'].y,
				src : '/resource/part/0/ETR-001.png'
			}));
		} else {
			ContractController.getPartInfo(centerPartId, (partInfo) => {
				let partName = partInfo[3];
				self.append(ShipImage({
					zIndex : 5,
					centerX : PartImagePositions[partName].x,
					centerY : PartImagePositions[partName].y,
					src : '/resource/part/0/' + partName + '.png'
				}));
			});
		}
		
		// front
		if (frontPartId === 0) {
			self.append(ShipImage({
				zIndex : 3,
				x : 50,
				centerX : PartImagePositions['ETR-003'].x,
				centerY : PartImagePositions['ETR-003'].y,
				src : '/resource/part/1/ETR-003.png'
			}));
		} else {
			ContractController.getPartInfo(frontPartId, (partInfo) => {
				let partName = partInfo[3];
				self.append(ShipImage({
					zIndex : 3,
					x : 50,
					centerX : PartImagePositions[partName].x,
					centerY : PartImagePositions[partName].y,
					src : '/resource/part/1/' + partName + '.png'
				}));
			});
		}
		
		// rear
		if (rearPartId === 0) {
			self.append(ShipImage({
				zIndex : 4,
				x : -50,
				centerX : PartImagePositions['ETR-002'].x,
				centerY : PartImagePositions['ETR-002'].y,
				src : '/resource/part/2/ETR-002.png'
			}));
		} else {
			ContractController.getPartInfo(rearPartId, (partInfo) => {
				let partName = partInfo[3];
				self.append(ShipImage({
					zIndex : 4,
					x : -50,
					centerX : PartImagePositions[partName].x,
					centerY : PartImagePositions[partName].y,
					src : '/resource/part/2/' + partName + '.png'
				}));
			});
		}
		
		// top
		if (topPartId === 0) {
			self.append(ShipImage({
				zIndex : 2,
				y : -50,
				centerX : PartImagePositions['ETR-004'].x,
				centerY : PartImagePositions['ETR-004'].y,
				src : '/resource/part/3/ETR-004.png'
			}));
		} else {
			ContractController.getPartInfo(topPartId, (partInfo) => {
				let partName = partInfo[3];
				self.append(ShipImage({
					zIndex : 2,
					y : -50,
					centerX : PartImagePositions[partName].x,
					centerY : PartImagePositions[partName].y,
					src : '/resource/part/3/' + partName + '.png'
				}));
			});
		}
		
		// bottom
		if (bottomPartId === 0) {
			self.append(ShipImage({
				zIndex : 1,
				y : 50,
				centerX : PartImagePositions['ETR-005'].x,
				centerY : PartImagePositions['ETR-005'].y,
				src : '/resource/part/4/ETR-005.png'
			}));
		} else {
			ContractController.getPartInfo(bottomPartId, (partInfo) => {
				let partName = partInfo[3];
				self.append(ShipImage({
					zIndex : 1,
					y : 50,
					centerX : PartImagePositions[partName].x,
					centerY : PartImagePositions[partName].y,
					src : '/resource/part/4/' + partName + '.png'
				}));
			});
		}
	}
});

ShipImage = CLASS((cls) => {
	
	const TRANSPARENT_ALPHA = 20;
	
	return {
		
		preset : () => {
			return SkyEngine.Node;
		},
		
		init : (inner, self, params) => {
			//REQUIRED: params
			//REQUIRED: params.src
			//OPTIONAL: params.cropTop
			//OPTIONAL: params.cropRight
			//OPTIONAL: params.cropBottom
			//OPTIONAL: params.cropLeft
			
			let src = params.src;
			
			let cropTop = params.cropTop;
			let cropRight = params.cropRight;
			let cropBottom = params.cropBottom;
			let cropLeft = params.cropLeft;
			
			if (cropTop === undefined) {
				cropTop = 0;
			}
			if (cropRight === undefined) {
				cropRight = 0;
			}
			if (cropBottom === undefined) {
				cropBottom = 0;
			}
			if (cropLeft === undefined) {
				cropLeft = 0;
			}
			
			let checkRectRect = SkyEngine.Util.Collision.checkRectRect;
			
			let imageData;
			let isImageDataLoading = false;
			
			let polygonPoints;
			
			let width;
			let height;
			
			let img;
			
			let setSrc = self.setSrc = (_src) => {
				src = _src;
				
				let tempImg = new Image();
				
				if (img === undefined) {
					img = tempImg;
				}
				
				tempImg.onload = () => {
					
					width = tempImg.width;
					height = tempImg.height;
					
					tempImg.onload = undefined;
					
					img = tempImg;
					
					self.fireEvent('load');
				};
				
				tempImg.src = src;
			};
			
			setSrc(src);
			
			let checkPoint;
			OVERRIDE(self.checkPoint, (origin) => {
				
				checkPoint = self.checkPoint = (x, y) => {
					
					if (imageData === undefined) {
						
						if (isImageDataLoading !== true) {
							
							let tempImg = new Image();
							
							tempImg.onload = () => {
								
								let width = tempImg.width;
								let height = tempImg.height;
								
								let imageCanvas = CANVAS({
									style : {
										display : 'none'
									},
									width : width,
									height : height
								}).appendTo(BODY);
								
								let imageContext = imageCanvas.getContext('2d');
								imageContext.drawImage(tempImg, 0, 0, width, height);
								
								imageData = imageContext.getImageData(0, 0, width, height).data;
								
								// clear.
								imageContext = undefined;
								imageCanvas.remove();
								
								tempImg.onload = undefined;
							};
							
							tempImg.src = src;
							
							isImageDataLoading = true;
						}
						
						return origin(x, y) === true;
					}
					
					let tx = x - self.getDrawingX();
					let ty = y - self.getDrawingY();
					
					let cos = Math.cos(-self.getRealRadian());
					let sin = Math.sin(-self.getRealRadian());
					
					let px = cos * tx - sin * ty;
					let py = cos * ty + sin * tx;
					
					px = parseInt((px + width * self.getRealScaleX() / 2) / self.getRealScaleX());
					py = parseInt((py + height * self.getRealScaleY() / 2) / self.getRealScaleY());
					
					return (px >= 0 && px < width && py >= 0 && py < height && imageData[(py * width + px) * 4 + 3] > TRANSPARENT_ALPHA) || origin(x, y) === true;
				};
			});
			
			let checkOffScreen;
			OVERRIDE(self.checkOffScreen, (origin) => {
				
				checkOffScreen = self.checkOffScreen = () => {
					
					if (width === undefined || checkRectRect(
						
						SkyEngine.Screen.getCameraFollowX(),
						SkyEngine.Screen.getCameraFollowY(),
						SkyEngine.Screen.getWidth(),
						SkyEngine.Screen.getHeight(),
						1,
						1,
						0,
						1,
						
						self.getDrawingX(),
						self.getDrawingY(),
						width,
						height,
						self.getRealScaleX(),
						self.getRealScaleY(),
						self.getRealSin(),
						self.getRealCos()) === true) {
						
						return false;
					}
					
					return origin();
				};
			});
			
			let draw;
			OVERRIDE(self.draw, (origin) => {
				
				draw = self.draw = (context) => {
					
					let w = width - cropLeft - cropRight;
					let h = height - cropTop - cropBottom;
					
					if (w > 0 && h > 0) {
						context.drawImage(
							img,
							cropLeft,
							cropTop,
							w,
							h,
							cropLeft,
							cropTop,
							w,
							h);
					}
					
					origin(context);
				};
			});
			
			let drawArea;
			OVERRIDE(self.drawArea, (origin) => {
				
				drawArea = self.drawArea = (context) => {
					
					if (polygonPoints === undefined) {
						
						if (imageData === undefined) {
							
							if (isImageDataLoading !== true) {
								
								let tempImg = new Image();
								
								tempImg.onload = () => {
									
									let width = tempImg.width;
									let height = tempImg.height;
									
									let imageCanvas = CANVAS({
										style : {
											display : 'none'
										},
										width : width,
										height : height
									}).appendTo(BODY);
									
									let imageContext = imageCanvas.getContext('2d');
									imageContext.drawImage(tempImg, 0, 0, width, height);
									
									imageData = imageContext.getImageData(0, 0, width, height).data;
									
									polygonPoints = SkyEngine.Util.ImageData.convertImageDataToPolygonPoints(imageData, width);
									
									// clear.
									imageContext = undefined;
									imageCanvas.remove();
									
									tempImg.onload = undefined;
								};
								
								tempImg.src = src;
								
								isImageDataLoading = true;
							}
						}
						
						else {
							polygonPoints = SkyEngine.Util.ImageData.convertImageDataToPolygonPoints(imageData, width);
						}
					}
					
					else if (polygonPoints.length > 0) {
						
						context.moveTo(polygonPoints[0].x - width / 2, polygonPoints[0].y - height / 2);
						
						for (let i = 1; i < polygonPoints.length; i += 1) {
							let point = polygonPoints[i];
							context.lineTo(point.x - width / 2, point.y - height / 2);
						}
						
						context.lineTo(polygonPoints[0].x - width / 2, polygonPoints[0].y - height / 2);
					}
					
					origin(context);
				};
			});
			
			let remove;
			OVERRIDE(self.remove, (origin) => {
				
				remove = self.remove = () => {
					
					img.onload = undefined;
					img = undefined;
					
					imageData = undefined;
					
					polygonPoints = undefined;
					
					origin();
				};
			});
			
			let getImg = inner.getImg = () => {
				return img;
			};
			
			let crop = self.crop = (params) => {
				//REQUIRED: params
				//REQUIRED: params.top
				//REQUIRED: params.right
				//REQUIRED: params.bottom
				//REQUIRED: params.left
				
				if (params.top !== undefined) {
					cropTop = params.top;
				}
				if (params.right !== undefined) {
					cropRight = params.right;
				}
				if (params.bottom !== undefined) {
					cropBottom = params.bottom;
				}
				if (params.left !== undefined) {
					cropLeft = params.left;
				}
			};
		}
	};
});
