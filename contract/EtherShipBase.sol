pragma solidity ^0.4.24;

// EtherShip의 기본적인 내용을 담고있는 계약
contract EtherShipBase {
	
	// 토큰 정보
	string constant public NAME = "EtherShip";
	string constant public SYMBOL = "SHIP";
	
	// 전함 정보
	struct Ship {
		
		// 전방
		uint256 frontPart;
		
		// 후방
		uint256 rearPart;
		
		// 위
		uint256 topPart;
		
		// 아래
		uint256 bottomPart;
		
		// 중앙
		uint256 centerPart;
	}
	
	// 회사의 지갑 주소
	address public company;
	
	// 회사만 처리 가능
	modifier onlyCompany {
		require(msg.sender == company);
		_;
	}
	
	// 소유주가 차단되었는지
	mapping(address => bool) public masterToIsBlocked;
	
	// 부품이 차단되었는지
	mapping(uint256 => bool) public partIdToIsBlocked;
	
	constructor() public {
		// 계약 생성자를 초기 회사로 등록
		company = msg.sender;
	}
	
	// 서비스가 일시중지 상태인지
	bool public servicePaused = false;
	
	// 서비스가 구동중일때만
	modifier whenServiceRunning() {
		require(servicePaused != true);
		_;
	}
	
	// 서비스가 일시정지 상태일때만
	modifier whenServicePaused() {
		require(servicePaused == true);
		_;
	}
	
	// 차단된 소유주가 아닐 경우에만
	modifier whenNotBlocked() {
		// 회사는 차단 불가
		require(msg.sender == company || masterToIsBlocked[msg.sender] != true);
		_;
	}
	
	// 차단된 부품이 아닐 경우에만
	modifier whenNotBlockedPart(uint256 partId) {
		// 회사는 차단 불가
		require(msg.sender == company || partIdToIsBlocked[partId] != true);
		_;
	}
	
	// 주소를 잘못 사용하는 것인지 체크
	function checkAddressMisused(address target) internal view returns (bool) {
		return
			target == address(0) ||
			target == address(this);
	}
	
	// 토큰의 이름 반환
	function name() pure external returns (string) {
		return NAME;
	}
	
	// 토큰의 심볼 반환
	function symbol() pure external returns (string) {
		return SYMBOL;
	}
}