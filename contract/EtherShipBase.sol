pragma solidity ^0.4.24;

// EtherShip의 기본적인 내용을 담고있는 계약
contract EtherShipBase {
	
	// 토큰 정보
	string constant public NAME = "EtherShip";
	string constant public SYMBOL = "SHIP";
	
	// 부품 합성의 가격 (초기 가격은 0.01 이더입니다.)
	uint256 public partUpgradePrice = 0.01 ether;
	
	// 행성 정보
	struct Planet {
		
		// 행성 이름
		string name;
		
		// 행성 전투력
		uint256 power;
		
		// 행성 인구 수
		uint256 population;
		
		// 숨긴 행성인가?
		bool isHidden;
	}
	
	// 행성 정보 저장소
	Planet[] public planets;
	
	function getPlanetCount() view public returns (uint256) {
		return planets.length;
	}
	
	// 행성 정보를 추가합니다.
	function addPlanet(string name, uint256 power, uint256 population) onlyCompany public {
		planets.push(Planet({
			name : name,
			power : power,
			population : population,
			isHidden : false
		}));
	}
	
	// 부품 원본 정보
	struct PartOrigin {
		
		// 출신 행성 ID
		uint256 planetId;
		
		// 부품 위치
		uint8 partLocation;
		
		// 부품 이름
		string name;
		
		// 부품 레벨
		uint256 level;
		
		// 공격력
		uint256 power;
		
		// 숨긴 부품 원본인가?
		bool isHidden;
	}
	
	// 부품 원본 정보 저장소
	PartOrigin[] public partOrigins;
	
	function getPartOriginCount() view public returns (uint256) {
		return partOrigins.length;
	}
	
	// 부품 원본 정보를 추가합니다.
	function addPartOrigin(uint256 planetId, uint8 partLocation, string name, uint256 level, uint256 power) onlyCompany public {
		partOrigins.push(PartOrigin({
			planetId : planetId,
			partLocation : partLocation,
			name : name,
			level : level,
			power : power,
			isHidden : false
		}));
	}
	
	// 부품 정보
	struct Part {
		
		// 부품 원본 ID
		uint256 partOriginId;
	}
	
	// 부품 정보 저장소
	Part[] public parts;
	
	function getPartCount() view public returns (uint256) {
		return parts.length;
	}
	
	// 전함 정보
	struct Ship {
		
		// 중앙
		uint256 centerPartId;
		
		// 전방
		uint256 frontPartId;
		
		// 후방
		uint256 rearPartId;
		
		// 위
		uint256 topPartId;
		
		// 아래
		uint256 bottomPartId;
	}
	
	// 전함 정보 저장소
	Ship[] public ships;
	
	function getShipCount() view public returns (uint256) {
		return ships.length;
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
		
		// 기본 행성 정보 등록
		addPlanet('EOS', 4, 1000000000);
		addPlanet('TRON', 22, 100000000000);
		addPlanet('Ripple', 39, 100000000000);
		addPlanet('OmiseGO', 51, 140000000);
		addPlanet('Qtum', 74, 100000000);
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