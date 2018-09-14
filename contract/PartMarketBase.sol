pragma solidity ^0.4.24;

import "./EtherShipBase.sol";

// 부품 마켓 Base
contract PartMarketBase is EtherShipBase {
	
	// 마켓을 일시중지하거나 재개하면 발생하는 이벤트
	event PausePartMarket();
	event ResumePartMarket();
	
	// 판매 정보
	struct PartSale {
		
		// 판매자
		address seller;
		
		// 부품 ID
		uint256 partId;
		
		// 가격
		uint256 price;
	}
	
	// 판매 정보 저장소
	PartSale[] public partSales;
	
	function getPartSaleCount() view public returns (uint256) {
		return partSales.length;
	}
	
	// 마켓이 일시중지 상태인지
	bool public partMarketPaused = false;
	
	// 마켓이 구동중일때만
	modifier whenPartMarketRunning() {
		require(partMarketPaused != true);
		_;
	}
	
	// 마켓이 일시정지 상태일때만
	modifier whenPartMarketPaused() {
		require(partMarketPaused == true);
		_;
	}
	
	// 마켓의 작동을 중지합니다.
	function pausePartMarket() onlyCompany whenPartMarketRunning public {
		partMarketPaused = true;
		emit PausePartMarket();
	}
	
	// 마켓을 재개합니다.
	function resumePartMarket() onlyCompany whenPartMarketPaused public {
		partMarketPaused = false;
		emit ResumePartMarket();
	}
}