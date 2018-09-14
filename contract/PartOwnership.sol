pragma solidity ^0.4.24;

import "./EtherShipMaster.sol";
import "./ERC/ERC721.sol";
import "./ERC/ERC721TokenReceiver.sol";
import "./Util/SafeMath.sol";

// 부품 소유권 관련 기능
contract PartOwnership is EtherShipMaster, ERC721 {
	using SafeMath for uint256;
	
	// 부품의 소유주 정보
	mapping(uint256 => address) public partIdToMaster;
	
	// 소유주의 부품 ID 목록 정보
	mapping(address => uint256[]) public masterToPartIds;
	
	// 부품의 부품 ID 목록에서의 index 정보
	mapping(uint256 => uint256) internal partIdToPartIdsIndex;
	
	// 부품 거래 권한이 승인된 지갑 정보
	mapping(uint256 => address) private partIdToApproved;
	
	// 오퍼레이터가 승인되었는지에 대한 정보
	mapping(address => mapping(address => bool)) private masterToOperatorToIsApprovedForAll;
	
	// 부품 소유주만
	modifier onlyPartMasterOf(uint256 partId) {
		require(msg.sender == ownerOf(partId));
		_;
	}
	
	// 승인된 지갑만
	modifier onlyApprovedOf(uint256 partId) {
		require(
			msg.sender == ownerOf(partId) ||
			msg.sender == getApproved(partId) ||
			isApprovedForAll(ownerOf(partId), msg.sender) == true ||
			msg.sender == address(this)
		);
		_;
	}
	
	//ERC721: 부품의 개수를 가져옵니다.
	function balanceOf(address master) view public returns (uint256) {
		// 주소 오용 차단
		require(checkAddressMisused(master) != true);
		return masterToPartIds[master].length;
	}
	
	//ERC721: 부품의 소유주 지갑 주소를 가져옵니다.
	function ownerOf(uint256 partId) view public returns (address) {
		address master = partIdToMaster[partId];
		require(checkAddressMisused(master) != true);
		return master;
	}
	
	// 주어진 주소가 스마트 계약인지 확인합니다.
	function checkIsSmartContract(address addr) view private returns (bool) {
		uint32 size;
		assembly { size := extcodesize(addr) }
		return size > 0;
	}
	
	//ERC721: 부품을 받는 대상이 스마트 계약인 경우, onERC721Received 함수를 실행합니다.
	function safeTransferFrom(address from, address to, uint256 partId, bytes data) whenServiceRunning payable external {
		transferFrom(from, to, partId);
		if (checkIsSmartContract(to) == true) {
			// ERC721TokenReceiver
			require(ERC721TokenReceiver(to).onERC721Received(msg.sender, from, partId, data) == 0x150b7a02);
		}
	}
	
	//ERC721: 부품을 받는 대상이 스마트 계약인 경우, onERC721Received 함수를 실행합니다.
	function safeTransferFrom(address from, address to, uint256 partId) whenServiceRunning payable external {
		transferFrom(from, to, partId);
		if (checkIsSmartContract(to) == true) {
			// ERC721TokenReceiver
			require(ERC721TokenReceiver(to).onERC721Received(msg.sender, from, partId, "") == 0x150b7a02);
		}
	}
	
	//ERC721: 부품을 이전합니다.
	function transferFrom(address from, address to, uint256 partId) whenServiceRunning whenNotBlocked whenNotBlockedPart(partId) onlyApprovedOf(partId) payable public {
		// 주소 오용 차단
		require(checkAddressMisused(to) != true);
		
		require(from == ownerOf(partId));
		require(to != ownerOf(partId));
		
		// 거래 권한 제거
		delete partIdToApproved[partId];
		emit Approval(from, 0, partId);
		
		// 기존 소유주로부터 부품 제거
		uint256 index = partIdToPartIdsIndex[partId];
		uint256 lastIndex = balanceOf(from).sub(1);
		
		uint256 lastPartId = masterToPartIds[from][lastIndex];
		masterToPartIds[from][index] = lastPartId;
		
		delete masterToPartIds[from][lastIndex];
		masterToPartIds[from].length -= 1;
		
		partIdToPartIdsIndex[lastPartId] = index;
		
		// 부품 이전
		partIdToMaster[partId] = to;
		partIdToPartIdsIndex[partId] = masterToPartIds[to].push(partId).sub(1);
		
		// 장착중인 부품 떼기
		uint256 shipId = masterToShipId[from];
		if (checkAddressMisused(shipIdToMaster[shipId]) != true) {
			
			uint8 partLocation = parts[partId].partLocation;
			
			Ship storage ship = ships[shipId];
			
			// center
			if (partLocation == 0 && ship.centerPartId == partId) {
				ship.centerPartId = 0;
			}
			
			// front
			if (partLocation == 1 && ship.frontPartId == partId) {
				ship.frontPartId = 0;
			}
			
			// rear
			if (partLocation == 2 && ship.rearPartId == partId) {
				ship.rearPartId = 0;
			}
			
			// top
			if (partLocation == 3 && ship.topPartId == partId) {
				ship.topPartId = 0;
			}
			
			// bottom
			if (partLocation == 4 && ship.bottomPartId == partId) {
				ship.bottomPartId = 0;
			}
		}
		
		emit Transfer(from, to, partId);
	}
	
	//ERC721: 특정 계약에 거래 권한을 부여합니다.
	function approve(address approved, uint256 partId) whenServiceRunning whenNotBlocked whenNotBlockedPart(partId) onlyPartMasterOf(partId) payable external {
		
		address master = ownerOf(partId);
		
		// 주소 오용 차단
		require(approved != master);
		require(checkAddressMisused(approved) != true);
		
		partIdToApproved[partId] = approved;
		emit Approval(master, approved, partId);
	}
	
	//ERC721: 오퍼레이터에게 거래 권한을 부여하거나 뺏습니다.
	function setApprovalForAll(address operator, bool isApproved) whenServiceRunning whenNotBlocked external {
		// 주소 오용 차단
		require(operator != msg.sender);
		require(checkAddressMisused(operator) != true);
		
		if (isApproved == true) {
			masterToOperatorToIsApprovedForAll[msg.sender][operator] = true;
		} else {
			delete masterToOperatorToIsApprovedForAll[msg.sender][operator];
		}
		
		emit ApprovalForAll(msg.sender, operator, isApproved);
	}
	
	//ERC721: 부품 거래 권한이 승인된 지갑 주소를 가져옵니다.
	function getApproved(uint256 partId) public view returns (address) {
		return partIdToApproved[partId];
	}
	
	//ERC721: 오퍼레이터가 거래 권한을 가지고 있는지 확인합니다.
	function isApprovedForAll(address master, address operator) view public returns (bool) {
		return masterToOperatorToIsApprovedForAll[master][operator] == true;
	}
}