pragma solidity ^0.4.24;

import "./Util/MersenneTwister32.sol";
import "./Util/SafeMath.sol";

// EtherShip의 기본적인 내용을 담고있는 계약
contract EtherShipBase {
	using SafeMath for uint256;
	
	// 토큰 정보
	string constant public NAME = "EtherShip";
	string constant public SYMBOL = "SHIP";
	
	MersenneTwister32 internal mersenneTwister32;
	
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
		
		// 점수
		uint256 point;
	}
	
	// 전함 정보 저장소
	Ship[] public ships;
	
	// 전함의 소유주 정보
	mapping(uint256 => address) public shipIdToMaster;
	
	// 소유주의 전함 ID 정보
	mapping(address => uint256) public masterToShipId;
	
	function getShipCount() view public returns (uint256) {
		return ships.length;
	}
	
	// 전함의 파워를 계산합니다.
	function getShipPower(uint256 shipId) view public returns (uint256) {
		
		uint256 power = 0;
		
		// 소유하고 있는 전함이 없으면 기본 공격력은 5 입니다.
		if (checkAddressMisused(shipIdToMaster[shipId]) == true) {
			power = 5;
		}
		
		else {
			
			Ship memory ship = ships[shipId];
			
			// 총 공격력 계산
			power = power
				.add(partOrigins[parts[ship.centerPartId].partOriginId].power)
				.add(partOrigins[parts[ship.frontPartId].partOriginId].power)
				.add(partOrigins[parts[ship.rearPartId].partOriginId].power)
				.add(partOrigins[parts[ship.topPartId].partOriginId].power)
				.add(partOrigins[parts[ship.bottomPartId].partOriginId].power);
		}
		
		return power;
	}
	
	// 침공 기록 정보
	struct InvasionRecord {
		
		// 침공 대상 행성 ID
		uint256 planetId;
		
		// 침공자
		address master;
		
		// 침공 횟수
		uint256 count;
		
		// 승리 횟수
		uint256 winCount;
		
		// 패배 횟수
		uint256 loseCount;
		
		// 메시지 인덱스 (최대 10)
		uint8 messageIndex;
	}
	
	// 침공 기록 정보 저장소
	InvasionRecord[] public invasionRecords;
	
	// 침공자의 침공 기록 ID 목록 정보
	mapping(address => uint256[]) public masterToInvasionRecordIds;
	
	function getInvasionRecordCount() view public returns (uint256) {
		return invasionRecords.length;
	}
	
	// 전투 기록 정보
	struct BattleRecord {
		
		// 전함 소유주
		address master;
		
		// 전투 대상
		address target;
		
		// 승리 여부
		bool isWin;
		
		// 전투 시각
		uint256 time;
	}
	
	// 전투 기록 정보 저장소
	BattleRecord[] public battleRecords;
	
	// 소유주의 전투 기록 ID 목록 정보
	mapping(address => uint256[]) public masterToBattleRecordIds;
	
	function getBattleRecordCount() view public returns (uint256) {
		return battleRecords.length;
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
	
	constructor(uint32 randomSeed) public {
		
		// 랜덤 알고리즘 생성
		mersenneTwister32 = new MersenneTwister32();
		mersenneTwister32.seedMT(randomSeed);
		
		// 계약 생성자를 초기 회사로 등록
		company = msg.sender;
		
		// 기본 행성 정보 등록
		addPlanet("EOS", 4, 1000000000);
		addPlanet("TRON", 22, 100000000000);
		addPlanet("Ripple", 39, 100000000000);
		addPlanet("OmiseGO", 51, 140000000);
		addPlanet("Qtum", 74, 100000000);
		
		// 기본 부품 정보 등록
		
		// EOS
		addPartOrigin(0, 0, "STD-N010M", 1, 2);
		addPartOrigin(0, 2, "STP-Z1", 1, 3);
		addPartOrigin(0, 1, "EPR-C", 1, 2);
		addPartOrigin(0, 3, "EOS-CSC", 1, 2);
		addPartOrigin(0, 4, "TT-VC", 1, 3);
		addPartOrigin(0, 0, "STD-N100", 2, 4);
		addPartOrigin(0, 2, "STK-HV", 2, 5);
		addPartOrigin(0, 1, "SHD-72", 2, 4);
		addPartOrigin(0, 3, "EOS-CSF", 2, 5);
		addPartOrigin(0, 4, "TT-VF", 2, 4);
		addPartOrigin(0, 0, "STD-N010T", 3, 30);
		addPartOrigin(0, 2, "SHK-325", 3, 14);
		addPartOrigin(0, 1, "EU-Z", 3, 15);
		addPartOrigin(0, 3, "EOS-CST", 3, 14);
		addPartOrigin(0, 4, "TT-VT", 3, 15);
		
		// TRON
		addPartOrigin(1, 0, "STD-N010B", 1, 5);
		addPartOrigin(1, 2, "PLST-AI", 1, 6);
		addPartOrigin(1, 1, "TES-LA", 1, 5);
		addPartOrigin(1, 3, "EOS-CSB", 1, 5);
		addPartOrigin(1, 4, "TT-VB", 1, 6);
		addPartOrigin(1, 0, "STD-N001", 2, 8);
		addPartOrigin(1, 2, "FG-B", 2, 9);
		addPartOrigin(1, 1, "RACER", 2, 8);
		addPartOrigin(1, 3, "EOS-CSE", 2, 9);
		addPartOrigin(1, 4, "TT-VE", 2, 8);
		addPartOrigin(1, 0, "WA-SANS-C", 3, 17);
		addPartOrigin(1, 2, "LIE", 3, 18);
		addPartOrigin(1, 1, "NC-C3", 3, 30);
		addPartOrigin(1, 3, "RIS-451", 3, 18);
		addPartOrigin(1, 4, "OG-BTC", 3, 17);
		
		// Ripple
		addPartOrigin(2, 0, "WA-SANS-F", 1, 7);
		addPartOrigin(2, 2, "RVV-6", 1, 8);
		addPartOrigin(2, 1, "NC-F5", 1, 7);
		addPartOrigin(2, 3, "RIS-772", 1, 8);
		addPartOrigin(2, 4, "OG-BTF", 1, 7);
		addPartOrigin(2, 0, "WA-SANS-T", 2, 10);
		addPartOrigin(2, 2, "JE-06", 2, 11);
		addPartOrigin(2, 1, "NC-T2", 2, 10);
		addPartOrigin(2, 3, "RIS-883", 2, 11);
		addPartOrigin(2, 4, "OG-BTT", 2, 10);
		addPartOrigin(2, 0, "WA-SANS-B", 3, 20);
		addPartOrigin(2, 2, "MIOB", 3, 30);
		addPartOrigin(2, 1, "NC-B3", 3, 20);
		addPartOrigin(2, 3, "RIS-774", 3, 19);
		addPartOrigin(2, 4, "OG-BTB", 3, 20);
		
		// OmiseGo
		addPartOrigin(3, 0, "WA-SANS-E", 1, 9);
		addPartOrigin(3, 2, "OJE-92", 1, 10);
		addPartOrigin(3, 1, "NC-E1", 1, 9);
		addPartOrigin(3, 3, "RIS-E", 1, 10);
		addPartOrigin(3, 4, "OG-BTE", 1, 9);
		addPartOrigin(3, 0, "1000000", 2, 16);
		addPartOrigin(3, 2, "HAL-9000", 2, 16);
		addPartOrigin(3, 1, "STD-unknown", 2, 15);
		addPartOrigin(3, 3, "FTT-010C", 2, 15);
		addPartOrigin(3, 4, "ISTD-010", 2, 15);
		addPartOrigin(3, 0, "1100110", 3, 22);
		addPartOrigin(3, 2, "SG-AB", 3, 23);
		addPartOrigin(3, 1, "SP-23", 3, 23);
		addPartOrigin(3, 3, "FTT-100", 3, 30);
		addPartOrigin(3, 4, "ISTD-100", 3, 22);
		
		// Qtum
		addPartOrigin(4, 0, "1110101", 1, 12);
		addPartOrigin(4, 2, "AP-90", 1, 11);
		addPartOrigin(4, 1, "TTP-412", 1, 11);
		addPartOrigin(4, 3, "FTT-010T", 1, 12);
		addPartOrigin(4, 4, "BFG-9000", 1, 12);
		addPartOrigin(4, 0, "1001101", 2, 18);
		addPartOrigin(4, 2, "PST-840", 2, 19);
		addPartOrigin(4, 1, "BDH-70", 2, 18);
		addPartOrigin(4, 3, "FTT-010B", 2, 18);
		addPartOrigin(4, 4, "BFG-9000F", 2, 19);
		addPartOrigin(4, 0, "1010011", 3, 26);
		addPartOrigin(4, 2, "HX-EB", 3, 25);
		addPartOrigin(4, 1, "GB-10", 3, 26);
		addPartOrigin(4, 3, "FTT-001", 3, 26);
		addPartOrigin(4, 4, "ISTD-001", 3, 30);
	}
	
	// 32 Bit 랜덤 정수를 반환합니다.
	function random32(uint32 min, uint32 max) internal returns (uint32) {
		return mersenneTwister32.extractNumber() % ((max + 1) - min) + min;
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