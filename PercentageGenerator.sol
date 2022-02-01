// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PercentageGenerator {

    string[] rarities = ["common", "uncommon" , "rare", "epic", "legendary"];
    uint[][5] raritiesRating;
	
	uint[][1] raritiesRatingNoVault;
     
    uint multiply = 100;
    uint onePercent = ((100 * multiply) / 31); // 322 (3.22), (0 - 10 000)
    uint onePercentNoVault = 10;

     constructor()  {
        raritiesRating[0] = [16,8,4,2,1];
        raritiesRating[1] = [1,16,8,4,2];
        raritiesRating[2] = [1,2,16,8,4];
        raritiesRating[3] = [1,2,4,16,8];
        raritiesRating[4] = [1,2,4,8,16];
    }

    function calculatePercentage(bool hasVault, uint rarity, uint tokens) public view returns (uint[] memory) {

        require(rarity >= 0, "Wrong rarity ID");
        require(rarity < 5, "Wrong rarity ID");

        // declare variables
        uint[] memory raritiesPercentage = new uint[](5);
      
        //////////////////////////////////////////////////////////// VAULT OWNERS ////////////////////////////////////////////////////////////		
		if (hasVault)
		{
			for (uint i=0; i < rarities.length; i++) {
				// pull raritiesRating row according to my rarity and go through array of numbers and multiply by percentage, add percentage of rarity to new array
				raritiesPercentage[i] =  uint(raritiesRating[rarity][i] * onePercent);
			}
		}
		else {
			rarity = 0;
            raritiesPercentage[0] = 6500;
            raritiesPercentage[1] = 2000;
            raritiesPercentage[2] = 950;
            raritiesPercentage[3] = 450;
            raritiesPercentage[4] = 100;
		}
		
		uint tokensPercentage = 0;
        uint actualPosition = rarity;
        uint positionsBefore = actualPosition + 1;
		uint positionsAfter = 5 - positionsBefore;   

        ////////////////////////////////////////////////////////// ADDITIONAL TOKENS //////////////////////////////////////////////////////////
        if(tokens > 0) {
            tokensPercentage = (tokens / 1000) * multiply;

            // to add / subtract
           if(positionsAfter == 0){ // LEGENDARY (no rarity in front of Legendary), add a percentage to the current, subtract from others
                
                 // foreach all rarities
                for (uint i=0; i < rarities.length; i++) {
                        if(i == actualPosition) {
							// if EPIC = add percentage to EPIC
							raritiesPercentage[i] = raritiesPercentage[i] + tokensPercentage;
						} else { // others						
							uint substractOnePercent = tokensPercentage / 15;						
							// subtract from negative rarities 1/15 * rating ( 1 2 4 8)                  
							raritiesPercentage[i] = raritiesPercentage[i] - ( substractOnePercent * raritiesRating[rarity][i] );
						}
                }

           }else{ 	// OTHERS (there are rarities in front of current rarity), add percentages to next, subtracted from current & behind me

             // foreach all rarities
                for (uint i=0; i < rarities.length; i++) {

                    if(i > actualPosition) { // add to next rarity

                        // count ratings in front of the current rarity
                        uint ratingNextCount = 0;

                        for (uint index=0; index < rarities.length; index++) {
                                if(index > actualPosition){
									ratingNextCount = ratingNextCount + raritiesRating[rarity][index];
								}
                        }       

                        // calculate one percent
						uint onePercentFromOthers = tokensPercentage / ratingNextCount;
							
						// we can add to every rarity one percent devided by sum of all ratings
						raritiesPercentage[i] = raritiesPercentage[i] + ( onePercentFromOthers * raritiesRating[rarity][i] );


                    } else { // SUBTRACT (CURRENT + PREVIOUS)

                       // count ratings of all the next rarities
                       uint ratingNextCount = 0;

                       for (uint index=0; index < rarities.length; index++) {
                                if(index < actualPosition) {
									ratingNextCount = ratingNextCount + raritiesRating[rarity][index];
								}
                        } 

                        // calculate one percent
						uint onePercentFromOthers = tokensPercentage / ratingNextCount;

                        // we can add to every rarity one percent devided by sum of all ratings
                        raritiesPercentage[i] = raritiesPercentage[i] - ( onePercentFromOthers * raritiesRating[rarity][i] );

                    }

                } 

           }

        }

        return raritiesPercentage;
    }
    
}