pragma solidity ^0.4.24;

import "./PartOwnership.sol";

// 전함 소유주가 사용하는 기능들
contract EtherShipMaster is PartOwnership {
	
	// 전함을 조립합니다.
	function assembleShip(uint256 centerPartId, uint256 frontPartId, uint256 rearPartId, uint256 topPartId, uint256 bottomPartId) public {
		
		// 모든 부품들을 소유하고 있어야 합니다.
		require(ownerOf(centerPartId) == msg.sender);
		require(ownerOf(frontPartId) == msg.sender);
		require(ownerOf(rearPartId) == msg.sender);
		require(ownerOf(topPartId) == msg.sender);
		require(ownerOf(bottomPartId) == msg.sender);
		
		uint256 shipId = masterToShipId[msg.sender];
		
		// 소유하고 있는 전함이 없으면 생성
		if (checkAddressMisused(shipIdToMaster[shipId]) == true) {
			
			// 전함 데이터 생성
			shipId = ships.push(Ship({
				centerPartId : centerPartId,
				frontPartId : frontPartId,
				rearPartId : rearPartId,
				topPartId : topPartId,
				bottomPartId : bottomPartId,
				point : 0
			})).sub(1);
			
			masterToShipId[msg.sender] = shipId;
			shipIdToMaster[shipId] = msg.sender;
		}
		
		else {
			
			Ship storage ship = ships[shipId];
			
			ship.centerPartId = centerPartId;
			ship.frontPartId = frontPartId;
			ship.rearPartId = rearPartId;
			ship.topPartId = topPartId;
			ship.bottomPartId = bottomPartId;
		}
	}
	
	// 부품을 합성합니다.
	function upgradePart(uint256 part1Id, uint256 part2Id, uint256 part3Id) public {
		
		// 모든 부품의 출신 행성과 레벨이 동일해야함
		uint256 planetId = parts[part1Id].planetId;
		uint256 level = parts[part1Id].level;
		require(
			parts[part2Id].planetId == planetId &&
			parts[part3Id].planetId == planetId &&
			parts[part2Id].level == level &&
			parts[part3Id].level == level);
		
		// 다음 레벨의 부품이 하나 이상 있어야 합니다.
		uint256 nextLevel = level.add(1);
		uint256 nextLevelPartCount = 0;
		for (uint256 i = 0; i < partOrigins.length; i += 1) {
			PartOrigin memory partOrigin = partOrigins[i];
			if (partOrigin.planetId == planetId && partOrigin.level == nextLevel) {
				nextLevelPartCount += 1;
			}
        }
        require(nextLevelPartCount > 0);
		
		// 재료로 사용되는 부품들을 회수합니다.
		transferFrom(msg.sender, this, part1Id);
		transferFrom(msg.sender, this, part2Id);
		transferFrom(msg.sender, this, part3Id);
		
		// 다음 레벨의 부품을 생성하여 지급합니다.
		uint32 max;
		if (nextLevelPartCount > 4294967295) {
			max = 4294967295;
		} else {
			max = uint32(nextLevelPartCount);
		}
		uint32 index = random32(0, max);
		
		// 부품 원본을 찾습니다.
		for (i = 0; i < partOrigins.length; i += 1) {
			partOrigin = partOrigins[i];
			if (partOrigin.planetId == planetId && partOrigin.level == nextLevel) {
				nextLevelPartCount -= 1;
				if (nextLevelPartCount == index) {
		
					// 부품 데이터 생성
					uint256 partId = parts.push(Part({
						partOriginId : i,
						planetId : partOrigin.planetId,
						partLocation : partOrigin.partLocation,
						name : partOrigin.name,
						level : partOrigin.level,
						power : partOrigin.power
					})).sub(1);
					
					// msg.sender를 소유주로 등록
					partIdToMaster[partId] = msg.sender;
					partIdToPartIdsIndex[partId] = masterToPartIds[msg.sender].push(partId).sub(1);
					
					// 이벤트 발생
					emit Transfer(0x0, msg.sender, partId);
					
					break;
				}
			}
        }
	}
	
	// 행성을 침략합니다.
	function invadePlanet(uint256 planetId) public {
		
		// 존재하는 행성이어야 합니다.
		require(planetId < planets.length);
		
		uint256 power = getShipPower(masterToShipId[msg.sender]);
		uint256 planetPower = planets[planetId].power;
		
		bool isWin;
		
		// 행성의 공격력보다 전함의 공격력이 높으면 승리
		if (planetPower < power) {
			isWin = true;
		}
		
		// 전함의 공격력보다 행성의 공격력이 높으면 패배
		else if (power < planetPower) {
			isWin = false;
		}
		
		// 공격력이 동일하면 랜덤
		else {
			isWin = random32(0, 1) == 0;
		}
		
		// 침공 기록 저장
		
		// 침공 기록 검색
		uint256[] memory invasionRecordIds = masterToInvasionRecordIds[msg.sender];
		for (uint256 i = 0; i < invasionRecordIds.length; i += 1) {
			if (invasionRecords[invasionRecordIds[i]].planetId == planetId) {
				InvasionRecord storage invasionRecord = invasionRecords[invasionRecordIds[i]];
				break;
			}
        }
        
        // 침공 기록이 없으면 생성
        if (invasionRecord.master != msg.sender) {
        	uint256 invasionRecordId = invasionRecords.push(InvasionRecord({
				planetId : planetId,
				master : msg.sender,
				count : 1,
				winCount : isWin == true ? 1 : 0,
				loseCount : isWin != true ? 1 : 0
			})).sub(1);
			masterToInvasionRecordIds[msg.sender].push(invasionRecordId);
        }
        
        // 침공 기록이 있으면 침공 기록 카운트를 증가시키고, 메시지를 변경합니다.
        else {
        	invasionRecord.count = invasionRecord.count.add(1);
        	if (isWin == true) {
        		invasionRecord.winCount = invasionRecord.winCount.add(1);
        	} else {
        		invasionRecord.loseCount = invasionRecord.loseCount.add(1);
        	}
        }
        
        // 승리했으면 해당 행성에서의 전리품을 얻습니다.
        // 행성별로 전리품은 반드시 5개여야 합니다.
        
		uint32 index = random32(1, 5);
		
		for (i = 0; i < partOrigins.length; i += 1) {
			PartOrigin memory partOrigin = partOrigins[i];
			if (partOrigin.planetId == planetId && partOrigin.level == 1) {
				index -= 1;
				if (index == 0) {
					
					// 부품 데이터 생성
					uint256 partId = parts.push(Part({
						partOriginId : i,
						planetId : partOrigin.planetId,
						partLocation : partOrigin.partLocation,
						name : partOrigin.name,
						level : partOrigin.level,
						power : partOrigin.power
					})).sub(1);
					
					// msg.sender를 소유주로 등록
					partIdToMaster[partId] = msg.sender;
					partIdToPartIdsIndex[partId] = masterToPartIds[msg.sender].push(partId).sub(1);
					
					// 이벤트 발생
					emit Transfer(0x0, msg.sender, partId);
					
					break;
				}
			}
        }
	}
	
	// 임의의 전함과 전투를 벌입니다.
	function battle() public {
		
		// 내 전함과의 공격력 차이가 작은 순서대로 전함들을 가져옵니다.
		
		uint256 power = getShipPower(masterToShipId[msg.sender]);
		
		uint256[] memory shipPowers = new uint256[](ships.length);
		
		for (uint256 i = 0; i < ships.length; i += 1) {
			shipPowers[i] = getShipPower(i);
		}
		
		uint256[] memory shipIds = new uint256[](ships.length);
		
		for (i = 0; i < ships.length; i += 1) {
			
			uint256 powerCompare = power < shipPowers[i] ? shipPowers[i].sub(power) : power.sub(shipPowers[i]);
			
			for (uint256 j = i; j > 0; j -= 1) {
				
				if (powerCompare < (power < shipPowers[shipIds[j - 1]] ? shipPowers[shipIds[j - 1]].sub(power) : power.sub(shipPowers[shipIds[j - 1]]))) {
					shipIds[j] = shipIds[j - 1];
				} else {
					break;
				}
			}
			
			shipIds[j] = i;
		}
		
		// 차이가 가장 덜 나는 10명 중 한명과 전투를 벌입니다.
		uint32 max;
		if (shipIds.length > 10) {
			max = 10;
		} else {
			max = uint32(shipIds.length - 1);
		}
		uint256 selectedShipId = shipIds[random32(0, max)];
		
		uint256 selectedShipPower = getShipPower(selectedShipId);
		
		bool isWin;
		
		// 상대의 공격력보다 전함의 공격력이 높으면 승리
		if (selectedShipPower < power) {
			isWin = true;
		}
		
		// 전함의 공격력보다 상대의 공격력이 높으면 패배
		else if (power < selectedShipPower) {
			isWin = false;
		}
		
		// 공격력이 동일하면 랜덤
		else {
			isWin = random32(0, 1) == 0;
		}
		
		// 전투 기록 저장
		address target = shipIdToMaster[selectedShipId];
		uint256 battleRecordId = battleRecords.push(BattleRecord({
			master : msg.sender,
			target : target,
			isWin : isWin,
			time : now
		})).sub(1);
		masterToBattleRecordIds[msg.sender].push(battleRecordId);
		masterToBattleRecordIds[target].push(battleRecordId);
		
		// 이겼으면 점수를 올립니다.
		if (isWin == true) {
			Ship storage ship = ships[masterToShipId[msg.sender]];
			if (ship.point < 990) {
				ship.point = ship.point.add(10);
			} else {
				ship.point = 1000;
			}
			
			Ship storage selectedShip = ships[selectedShipId];
			if (selectedShip.point > 10) {
				selectedShip.point = selectedShip.point.sub(10);
			} else {
				selectedShip.point = 0;
			}
		}
		
		// 졌으면 점수를 내립니다.
		else {
			ship = ships[masterToShipId[msg.sender]];
			if (ship.point > 10) {
				ship.point = ship.point.sub(10);
			} else {
				ship.point = 0;
			}
			
			selectedShip = ships[selectedShipId];
			if (selectedShip.point < 990) {
				selectedShip.point = selectedShip.point.add(10);
			} else {
				selectedShip.point = 1000;
			}
		}
	}
}