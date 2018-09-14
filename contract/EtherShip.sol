pragma solidity ^0.4.24;

import "./EtherShipCompany.sol";
import "./EtherShipMaster.sol";
import "./PartMarket.sol";
import "./ERC/ERC165.sol";

// EtherShip 스마트 계약
contract EtherShip is EtherShipCompany, EtherShipMaster, PartMarket, ERC165 {
	
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