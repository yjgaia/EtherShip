pragma solidity ^0.4.24;

import "./EtherShipBase.sol";
import "./ERC/ERC721.sol";
import "./ERC/ERC721TokenReceiver.sol";
import "./Util/SafeMath.sol";

// 전함 소유권 관련 기능
contract EtherShipOwnership is EtherShipBase, ERC721 {
	using SafeMath for uint256;
	
	// 전함의 소유주 정보
	mapping(uint256 => address) public shipIdToMaster;
	
	// 소유주의 전함 ID 목록 정보
	mapping(address => uint256[]) public masterToShipIds;
	
	// 전함의 전함 ID 목록에서의 index 정보
	mapping(uint256 => uint256) internal shipIdToShipIdsIndex;
	
	// 전함 거래 권한이 승인된 지갑 정보
	mapping(uint256 => address) private shipIdToApproved;
	
	// 오퍼레이터가 승인되었는지에 대한 정보
	mapping(address => mapping(address => bool)) private masterToOperatorToIsApprovedForAll;
	
	// 전함 소유주만
	modifier onlyMasterOf(uint256 shipId) {
		require(msg.sender == ownerOf(shipId));
		_;
	}
	
	// 승인된 지갑만
	modifier onlyApprovedOf(uint256 shipId) {
		require(
			msg.sender == ownerOf(shipId) ||
			msg.sender == getApproved(shipId) ||
			isApprovedForAll(ownerOf(shipId), msg.sender) == true ||
			msg.sender == address(this)
		);
		_;
	}
	
	//ERC721: 전함의 개수를 가져옵니다.
	function balanceOf(address master) view public returns (uint256) {
		// 주소 오용 차단
		require(checkAddressMisused(master) != true);
		return masterToShipIds[master].length;
	}
	
	//ERC721: 전함의 소유주 지갑 주소를 가져옵니다.
	function ownerOf(uint256 shipId) view public returns (address) {
		address master = shipIdToMaster[shipId];
		require(checkAddressMisused(master) != true);
		return master;
	}
	
	// 주어진 주소가 스마트 계약인지 확인합니다.
	function checkIsSmartContract(address addr) view private returns (bool) {
		uint32 size;
		assembly { size := extcodesize(addr) }
		return size > 0;
	}
	
	//ERC721: 전함을 받는 대상이 스마트 계약인 경우, onERC721Received 함수를 실행합니다.
	function safeTransferFrom(address from, address to, uint256 shipId, bytes data) whenServiceRunning payable external {
		transferFrom(from, to, shipId);
		if (checkIsSmartContract(to) == true) {
			// ERC721TokenReceiver
			require(ERC721TokenReceiver(to).onERC721Received(msg.sender, from, shipId, data) == 0x150b7a02);
		}
	}
	
	//ERC721: 전함을 받는 대상이 스마트 계약인 경우, onERC721Received 함수를 실행합니다.
	function safeTransferFrom(address from, address to, uint256 shipId) whenServiceRunning payable external {
		transferFrom(from, to, shipId);
		if (checkIsSmartContract(to) == true) {
			// ERC721TokenReceiver
			require(ERC721TokenReceiver(to).onERC721Received(msg.sender, from, shipId, "") == 0x150b7a02);
		}
	}
	
	//ERC721: 전함을 이전합니다.
	function transferFrom(address from, address to, uint256 shipId) whenServiceRunning whenNotBlocked whenNotBlockedShip(shipId) onlyApprovedOf(shipId) payable public {
		// 주소 오용 차단
		require(checkAddressMisused(to) != true);
		
		require(from == ownerOf(shipId));
		require(to != ownerOf(shipId));
		
		// 거래 권한 제거
		delete shipIdToApproved[shipId];
		emit Approval(from, 0, shipId);
		
		// 기존 소유주로부터 전함 제거
		uint256 index = shipIdToShipIdsIndex[shipId];
		uint256 lastIndex = balanceOf(from).sub(1);
		
		uint256 lastShipId = masterToShipIds[from][lastIndex];
		masterToShipIds[from][index] = lastShipId;
		
		delete masterToShipIds[from][lastIndex];
		masterToShipIds[from].length -= 1;
		
		shipIdToShipIdsIndex[lastShipId] = index;
		
		// 전함 이전
		shipIdToMaster[shipId] = to;
		shipIdToShipIdsIndex[shipId] = masterToShipIds[to].push(shipId).sub(1);
		
		emit Transfer(from, to, shipId);
	}
	
	//ERC721: 특정 계약에 거래 권한을 부여합니다.
	function approve(address approved, uint256 shipId) whenServiceRunning whenNotBlocked whenNotBlockedShip(shipId) onlyMasterOf(shipId) payable external {
		
		address master = ownerOf(shipId);
		
		// 주소 오용 차단
		require(approved != master);
		require(checkAddressMisused(approved) != true);
		
		shipIdToApproved[shipId] = approved;
		emit Approval(master, approved, shipId);
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
	
	//ERC721: 전함 거래 권한이 승인된 지갑 주소를 가져옵니다.
	function getApproved(uint256 shipId) public view returns (address) {
		return shipIdToApproved[shipId];
	}
	
	//ERC721: 오퍼레이터가 거래 권한을 가지고 있는지 확인합니다.
	function isApprovedForAll(address master, address operator) view public returns (bool) {
		return masterToOperatorToIsApprovedForAll[master][operator] == true;
	}
}