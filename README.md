# EtherShip
이더리움 기반 우주 전함 게임

SKT 블록체인 해커톤에서 개발하고 있습니다.

## EtherShip
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `constructor()`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `initMersenneTwister32()`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `seedMersenneTwister32(uint32 seed)`

## EtherShipBase
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `getPlanetCount()`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `addPlanet(string name, uint256 power, uint256 population)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `getPartOriginCount()`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `addPartOrigin(uint256 planetId, uint8 partLocation, string name, uint256 level, uint256 power)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `getPlanetPartOriginIds(planetId)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `getPartCount()`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `getShipCount()`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `getShipPower(uint256 shipId)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `getInvasionRecordCount()`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `getBattleRecordCount()`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `name()`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `symbol()`

## EtherShipCompany
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `updatePlanet(uint256 planetId, string name, uint256 power, uint256 population, bool isHidden)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `updatePartOrigin(uint256 partOriginId, uint256 planetId, uint8 partLocation, string name, uint256 level, uint256 power, bool isHidden)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `createPart(uint256 partOriginId)`

## EtherShipMaster
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `assembleShip(uint256 centerPartId, uint256 frontPartId, uint256 rearPartId, uint256 topPartId, uint256 bottomPartId)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `upgradePart(uint256 part1Id, uint256 part2Id, uint256 part3Id)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `invadePlanet(uint256 planetId)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `battle()`

## PartOwnership
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `transferFrom(address from, address to, uint256 partId)`

## 라이센스
[MIT](LICENSE)

## 작성자
[Young Jae Sim](https://github.com/Hanul)
