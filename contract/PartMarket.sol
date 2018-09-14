pragma solidity ^0.4.24;

import "./PartMarketBase.sol";
import "./PartOwnership.sol";
import "./Util/SafeMath.sol";

// 부품 마켓
contract PartMarket is PartMarketBase, PartOwnership {
	using SafeMath for uint256;

    event StartPartSale(uint256 indexed partId, uint256 price);
    event ChangePartSaleId(uint256 indexed originSaleId, uint256 newSaleId);
    event CancelPartSale(uint256 indexed partId);
    event SuccessPartSale(uint256 indexed partId, uint256 price);
    
	// 부품 판매를 시작합니다.
	function startPartSale(uint256 partId, uint256 price) whenPartMarketRunning onlyPartMasterOf(partId) whenNotBlockedPart(partId) public {
		
		// 마켓으로 부품 이전
		transferFrom(msg.sender, this, partId);
		
		// 판매 정보 생성
		partSales.push(PartSale({
			seller : msg.sender,
			partId : partId,
			price : price
		}));
		
		emit StartPartSale(partId, price);
	}
	
	// 부품이 판매되고 있는지 확인합니다.
	function checkPartForSale(uint256 partId) whenPartMarketRunning whenNotBlockedPart(partId) public view returns (bool) {
		
		// saleId를 찾습니다.
		for (uint256 i = 0; i < partSales.length; i += 1) {
			if (partSales[i].partId == partId) {
				return true;
			}
        }
		
		return false;
	}
	
	// 부품 ID로부터 판매 정보 ID를 가져옵니다.
	function findPartSaleIdByPartId(uint256 partId) whenPartMarketRunning whenNotBlockedPart(partId) public view returns (uint256) {
		
		bool isFound = false;
		uint256 saleId;
		
		// saleId를 찾습니다.
		for (uint256 i = 0; i < partSales.length; i += 1) {
			if (partSales[i].partId == partId) {
				saleId = i;
				isFound = true;
			}
        }
		
		// 판매 정보를 찾은 경우에만
		require(isFound == true);
		
		return saleId;
	}
	
	// 부품 판매를 취소합니다.
	function cancelPartSale(uint256 partId) whenPartMarketRunning whenNotBlockedPart(partId) public {
		
		bool isFound = false;
		uint256 saleId;
		
		// saleId를 찾습니다.
		for (uint256 i = 0; i < partSales.length; i += 1) {
			if (partSales[i].partId == partId) {
				saleId = i;
				isFound = true;
			}
        }
		
		// 소유주인 경우에만
		require(isFound == true && msg.sender == partSales[saleId].seller);
		
		// 소유주로 부품 이전
		transferFrom(this, msg.sender, partId);
		
		// 판매 정보 삭제
		for (i = saleId; i < partSales.length - 1; i += 1) {
            partSales[i] = partSales[i + 1];
            
            emit ChangePartSaleId(i + 1, i);
        }
        delete partSales[partSales.length - 1];
        partSales.length -= 1;
		
		emit CancelPartSale(partId);
	}
	
	// 부품을 구매합니다.
	function buyPart(uint256 partId) whenPartMarketRunning whenNotBlockedPart(partId) payable public {
		
		bool isFound = false;
		uint256 saleId;
		PartSale memory sale;
		
		// saleId를 찾습니다.
		for (uint256 i = 0; i < partSales.length; i += 1) {
			if (partSales[i].partId == partId) {
				saleId = i;
				sale = partSales[i];
				isFound = true;
			}
        }
		
		// 판매 정보를 찾은 경우에만
		require(isFound == true);
		
		// 정상적인 판매인지 체크
		require(checkAddressMisused(sale.seller) != true);
		
		// 지불하고자 하는 가격이 맞는지 체크
		require(msg.value == sale.price);
		
		// 구매자로 부품 이전
		transferFrom(this, msg.sender, partId);
		
		// 판매 정보 삭제
		for (i = saleId; i < partSales.length - 1; i += 1) {
            partSales[i] = partSales[i + 1];
            
            emit ChangePartSaleId(i + 1, i);
        }
        delete partSales[partSales.length - 1];
        partSales.length -= 1;
        
        uint256 companyRevenue = msg.value.div(10);
        uint256 sellerRevenue = msg.value.div(10).mul(9);
        
        require(companyRevenue.add(sellerRevenue) == msg.value);
		
		// 회사에게 금액의 10%를 지급합니다.
		company.transfer(companyRevenue);
		
		// 판매자에게 금액의 90%를 지급합니다.
		sale.seller.transfer(sellerRevenue);
		
		emit SuccessPartSale(partId, sale.price);
	}
}