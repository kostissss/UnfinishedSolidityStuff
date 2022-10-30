// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
///neeeeeeeed comments
contract NftSubscription is ERC721 {
    string private s_TokenURI;
    uint256 private s_tokenCounter;
    uint256 private s_duration;
    uint256 public s_activationBlock;
    uint256 public  elapsedTime;
    string  public constant IPFS_PREFIX="";

    event NftMinted(uint256 indexed tokenId,uint256 timer);
    event NftBurned(uint256 indexed tokenId,uint256 timer);
    error NftSubscription__SubscriptionNotOver(uint256 elapsedTime );

    constructor() ERC721("CrypBookSubscription", "SCB") {
        s_tokenCounter = 0;
    }
    
    function activateSubscription() private {
        
        s_activationBlock=block.timestamp;
        

        
    }

    function mintNft(uint256 duration,string memory userInfo) public {
        
        _safeMint(msg.sender, s_tokenCounter);
        s_duration=duration;
        s_TokenURI=userInfo;
        emit NftMinted(s_tokenCounter,s_duration);
        s_tokenCounter = s_tokenCounter + 1;
    }

    function burnNft() public{
        if(s_activationBlock+s_duration <block.timestamp){
        _burn(s_tokenCounter);
        emit NftBurned(s_tokenCounter,block.timestamp);
        }
        else{
            elapsedTime=   s_duration * 1 days-(block.timestamp -s_activationBlock)*1 days ;
            revert NftSubscription__SubscriptionNotOver(elapsedTime); }
        
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return s_TokenURI;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
    function getElapsedTime() public  returns (uint256 ) {
        elapsedTime=s_duration * 1 days-(block.timestamp -s_activationBlock)*1 days;
        return elapsedTime;
    }
}