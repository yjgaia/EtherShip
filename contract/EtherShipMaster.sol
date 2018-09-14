pragma solidity ^0.4.24;

import "./EtherShipBase.sol";

// 전함 소유주가 사용하는 기능들
contract EtherShipMaster is EtherShipBase {
	
	// 전함의 소유주 정보
	mapping(uint256 => address) public shipIdToMaster;
	
	// 소유주의 전함 ID 정보
	mapping(address => uint256) public masterToShipId;
	
	/*// 전함을 조립합니다.
	function assembleShip() pure public {
		
	}
	
	// 부품을 합성합니다.
	function upgradePart() pure public {
		
	}
	
	// 행성을 침략합니다.
	function invadePlanet(uint256 planetId) pure public {
		
	}
	
	// 임의의 전함과 전투를 벌입니다.
	function battle() pure public {
		
	}*/
}