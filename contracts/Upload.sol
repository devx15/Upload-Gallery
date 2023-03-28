// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Upload{
   struct Access{
       address user;
       bool access;
   }
   mapping (address=>string[]) value;
   mapping (address=>Access[]) AccessList;
   mapping (address=>mapping(address=>bool)) ownership;
   mapping (address=>mapping(address=>bool)) PreviousData;

   function addItem(address user,string memory url) external{
       value[user].push(url);
   }

   function allowAccess(address user) external{
       ownership[msg.sender][user]=true;
        if(PreviousData[msg.sender][user]){
            for(uint256 i=0;i<AccessList[msg.sender].length;i++){
                if(AccessList[msg.sender][i].user==user){
                    AccessList[msg.sender][i].access=true;
                }
            }
        }else{
                    AccessList[msg.sender].push(Access(user,true));
                    PreviousData[msg.sender][user]=true;
                }
   }

   function disAllow(address user) external {
       ownership[msg.sender][user]=false;
        for(uint256 i=0;i<AccessList[msg.sender].length;i++){
           if(AccessList[msg.sender][i].user==user){
                    AccessList[msg.sender][i].access=false;
                } 
        }
   }

   function displayItem(address user) public view returns(string[] memory) {
       require(user==msg.sender || ownership[user][msg.sender],"You cant access these items");
       return value[user];
   }

   function sharedAccessWith() public view returns(Access[] memory){
       return AccessList[msg.sender];
   }
}