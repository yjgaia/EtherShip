pragma solidity ^0.4.24;

import "./PartOwnership.sol";

// EtherShip을 운영하는 회사에서 사용하는 기능들
contract EtherShipCompany is PartOwnership {
	
	// 소유권 이전 이벤트
	event TransferOwnership(address oldCompany, address newCompany);
	
	// 서비스를 일시중지하거나 재개하면 발생하는 이벤트
	event PauseService();
	event ResumeService();
	
	// 기타 이벤트
	event ChangePartUpgradePrice(uint256 price);
	event BlockMaster(address masterToBlock);
	event BlockPart(uint256 partIdToBlock);
	event UnblockMaster(address masterToUnlock);
	event UnblockPart(uint256 partIdToUnblock);
	
	// 소유권을 이전합니다.
	function transferOwnership(address newCompany) onlyCompany public {
		address oldCompany = company;
		company = newCompany;
		emit TransferOwnership(oldCompany, newCompany);
	}
	
	// 서비스의 작동을 중지합니다.
	function pauseService() onlyCompany whenServiceRunning public {
		servicePaused = true;
		emit PauseService();
	}
	
	// 서비스를 재개합니다.
	function resumeService() onlyCompany whenServicePaused public {
		servicePaused = false;
		emit ResumeService();
	}
	
	// 부품 합성의 가격을 변경합니다.
	function changePartUpgradePrice(uint256 newPartUpgradePrice) onlyCompany public {
		partUpgradePrice = newPartUpgradePrice;
		emit ChangePartUpgradePrice(newPartUpgradePrice);
	}
	
	// 특정 소유주를 차단합니다.
	function blockMaster(address masterToBlock) onlyCompany public {
		masterToIsBlocked[masterToBlock] = true;
		emit BlockMaster(masterToBlock);
	}
	
	// 특정 부품을 차단합니다.
	function blockPart(uint256 partIdToBlock) onlyCompany public {
		partIdToIsBlocked[partIdToBlock] = true;
		emit BlockPart(partIdToBlock);
	}
	
	// 소유주 차단을 해제합니다.
	function unblockMaster(address masterToUnlock) onlyCompany public {
		delete masterToIsBlocked[masterToUnlock];
		emit UnblockMaster(masterToUnlock);
	}
	
	// 부품 차단을 해제합니다.
	function unblockPart(uint256 partIdToUnblock) onlyCompany public {
		delete partIdToIsBlocked[partIdToUnblock];
		emit UnblockPart(partIdToUnblock);
	}
	
	// 행성 정보를 수정합니다.
	function updatePlanet(uint256 planetId, string name, uint256 power, uint256 population, bool isHidden) onlyCompany public {
		
		Planet storage planet = planets[planetId];
		
		planet.name = name;
		planet.power = power;
		planet.population = population;
		planet.isHidden = isHidden;
	}
	
	// 부품 원본 정보를 수정합니다.
	function updatePartOrigin(uint256 partOriginId, uint256 planetId, uint8 partLocation, string name, uint256 level, uint256 power, bool isHidden) onlyCompany public {
		
		PartOrigin storage partOrigin = partOrigins[partOriginId];
		
		partOrigin.planetId = planetId;
		partOrigin.partLocation = partLocation;
		partOrigin.name = name;
		partOrigin.level = level;
		partOrigin.power = power;
		partOrigin.isHidden = isHidden;
	}
	
	// 운영자가 임의로 부품을 만듭니다.
	function createPart(uint256 partOriginId) onlyCompany public {
		
		// 부품 데이터 생성
		uint256 partId = parts.push(Part({
			partOriginId : partOriginId
		})).sub(1);
		
		// msg.sender를 소유주로 등록
		partIdToMaster[partId] = msg.sender;
		partIdToPartIdsIndex[partId] = masterToPartIds[msg.sender].push(partId).sub(1);
		
		// 이벤트 발생
		emit Transfer(0x0, msg.sender, partId);
	}
}