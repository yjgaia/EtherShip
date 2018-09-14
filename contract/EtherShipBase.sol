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
	
	// 행성에서 얻을 수 있는 부품 원본 ID 목록을 가져옵니다.
	function getPlanetPartOriginIds(uint256 planetId) view public returns (uint256[]) {
		
		uint256 count = 0;
		
		for (uint256 i = 0; i < partOrigins.length; i += 1) {
			PartOrigin memory partOrigin = partOrigins[i];
			if (partOrigin.planetId == planetId) {
				count = count.add(1);
			}
        }
        
		uint256[] memory partOriginIds = new uint256[](count);
		uint256 index = 0;
		
		for (i = 0; i < partOrigins.length; i += 1) {
			partOrigin = partOrigins[i];
			if (partOrigin.planetId == planetId) {
				partOriginIds[index] = i;
				index = index.add(1);
			}
        }
        
        return partOriginIds;
	}
	
	// 부품 정보
	struct Part {
		
		// 부품 원본 ID
		uint256 partOriginId;
		
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
				.add(ship.centerPartId == 0 ? 1 : parts[ship.centerPartId].power)
				.add(ship.frontPartId == 0 ? 1 : parts[ship.frontPartId].power)
				.add(ship.rearPartId == 0 ? 1 : parts[ship.rearPartId].power)
				.add(ship.topPartId == 0 ? 1 : parts[ship.topPartId].power)
				.add(ship.bottomPartId == 0 ? 1 : parts[ship.bottomPartId].power);
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