pragma solidity ^0.4.24;

import "./EtherShipCompany.sol";
import "./EtherShipMaster.sol";
import "./PartMarket.sol";
import "./ERC/ERC165.sol";

// EtherShip 스마트 계약
contract EtherShip is EtherShipCompany, EtherShipMaster, PartMarket, ERC165 {
	
	//TODO: 계약 생성 이후 이 함수를 실행해줘야 합니다.
	function initMersenneTwister32() onlyCompany public {
		mersenneTwister32 = new MersenneTwister32();
	}
	
	//TODO: initMersenneTwister32 이후 이 함수를 실행해줘야 합니다.
	function seedMersenneTwister32(uint32 seed) onlyCompany public {
		mersenneTwister32.seedMT(seed);
	}
	
	constructor() public {
		
		// 계약 생성자를 초기 회사로 등록
		company = msg.sender;
		
		// part 0번은 사용하지 않습니다.
		parts.push(Part({
			partOriginId : 0,
			planetId : 0,
			partLocation : 0,
			name : "",
			level : 0,
			power : 0
		}));
		
		// 기본 행성 정보 등록
		addPlanet("EOS", 4, 1000000000);
		
		//TODO: 나머지 행성들의 정보도 추가해줘야합니다.
		//addPlanet("TRON", 22, 100000000000);
		//addPlanet("Ripple", 39, 100000000000);
		//addPlanet("OmiseGO", 51, 140000000);
		//addPlanet("Qtum", 74, 100000000);
		
		// EOS 무기 추가
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
		
		//TODO: 나머지 무기들도 추가해줘야합니다.
		
		/*
		// TRON 기본 부품 정보
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
	
		// Ripple 기본 부품 정보
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
	
		// OmiseGo 기본 부품 정보
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
	
		// Qtum 기본 부품 정보
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
		*/
	}
	
	//ERC165: 주어진 인터페이스가 구현되어 있는지 확인합니다.
	function supportsInterface(bytes4 interfaceID) external view returns (bool) {
		return
			// ERC165
			interfaceID == this.supportsInterface.selector ||
			// ERC721
			interfaceID == 0x80ac58cd ||
			// ERC721Enumerable
			interfaceID == 0x780e9d63;
	}
}