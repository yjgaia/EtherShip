pragma solidity ^0.4.24;

import "./EtherShipBase.sol";

// EtherShip을 운영하는 회사에서 사용하는 기능들
contract EtherShipCompany is EtherShipBase {
	
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
	
	// 회사만 처리 가능
	modifier onlyCompany {
		require(msg.sender == company);
		_;
	}
	
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
}