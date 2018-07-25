pragma solidity ^0.4.21;
/**
 * Contract "Ownable"
 * Purpose: Defines Owner for contract and provide functionality to transfer ownership to another account
 */
contract Ownable {

  //owner variable to store contract owner account
  address public owner;
  //add another owner
  address deployer;

  //Constructor for the contract to store owner's account on deployement
  function Ownable() public {
    owner = msg.sender;
    deployer = msg.sender;
  }

  //modifier to check transaction initiator is only owner
  modifier onlyOwner() {
    require (msg.sender == owner || msg.sender == deployer);
      _;
  }

  //ownership can be transferred to provided newOwner. Function can only be initiated by contract owner's account
  function transferOwnership(address _newOwner) public onlyOwner {
    require (_newOwner != address(0));
    owner = _newOwner;
  }

}

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;
  uint256 public startTime;
  uint256 public endTime;
  uint256 private pauseTime;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    //Record the pausing time only if any startTime is defined
    //in other cases, it will work as a toggle switch only
    if(startTime > 0){
        pauseTime = now;
    }
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    //if endTime is defined, only then proceed with its updation
    if(endTime > 0 && pauseTime > startTime){
        uint256 pauseDuration = pauseTime - startTime;
        endTime = endTime + pauseDuration;
    }
    emit Unpause();
  }
}