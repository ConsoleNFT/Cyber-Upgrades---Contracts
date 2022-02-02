// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ConsoleNFT_Source_Data {

    uint16 legendary = 5; // 1%
    uint16 epic = 25; // 5%
    uint16 rare = 50; // 10%
    uint16 uncommon = 150; // 30%
    // rest = 54%
	
    mapping(uint => uint8) private _vaultRarities;
	
	constructor() {
		
	uint16[150] memory list;

        list = [210,196,66,163,222,255,54,241,426,218,380,156,470,385,2,340,266,366,478,262,30,164,472,120,394,35,294,68,422,90,180,170,0,458,404,315,270,497,11,334,29,309,162,329,6,275,58,459,286,57,32,232,18,384,152,160,114,451,496,282,310,209,108,320,302,36,408,159,174,141,240,288,226,72,234,360,438,462,21,289,450,219,244,50,158,25,228,28,454,498,20,337,77,299,212,390,418,12,76,110,99,59,24,147,354,215,144,285,52,343,83,447,146,89,138,60,414,149,80,81,130,300,101,444,92,100,38,325,4,73,410,8,17,15,348,400,132,387,230,263,95,161,358,126,338,305,186,313,128,123];
		
        for (uint16 i = 0; i < list.length; i++) {
		
            uint8 rarity = 0;
			
            if (i < legendary) {
                rarity = 4;
            }
            if (i >= legendary && i < epic) {
                rarity = 3;
            }
            if (i >= epic && i < rare) {
                rarity = 2;
            }
            if (i >= rare && i < uncommon) {
                rarity = 1;
            }
			
			_vaultRarities[list[i]] = rarity;

        }
        
		
	}
	
    function getVaultRarity(uint token_id) public view returns(uint8) {

        return _vaultRarities[token_id];
        
    }
	
	uint baseSeed = 4965469432;

    function getFirstStat(uint token_id, uint rarity) public view returns(uint) {

		uint seed = baseSeed + token_id + rarity;

        return minMax(seed, rarity);

    }

    function getFirstStatValue(uint token_id, uint rarity) public view returns(uint) {

		uint seed = baseSeed + token_id + rarity * 2;

        return minMax(seed, rarity) / 2;

    }

    function getSecondStat(uint token_id, uint rarity) public view returns(uint) {

		uint seed = baseSeed + (token_id / 2) + rarity * 3;

        return minMax(seed, rarity);

    }

    function getSecondStatValue(uint token_id, uint rarity) public view returns(uint) {

		uint seed = baseSeed + (token_id / 3) + rarity * 4;

        return minMax(seed, rarity) / 2;

    }

    function getFirstAugment(uint token_id, uint rarity) public view returns(uint) {

		uint seed = baseSeed + (token_id / 3) + rarity * 5;

        return minMax(seed, rarity);

    }

    function getSecondAugment(uint token_id, uint rarity) public view returns(uint) {

		uint seed = (baseSeed / 3) + (token_id / 5) + rarity * 2;

        return minMax(seed, rarity);

    }

    function getAirdrops(uint token_id, uint rarity) public view returns(uint) {

		uint seed = (baseSeed / 3) + (token_id / 5) + rarity * 2;

        return minMax(seed, rarity) / 3;

    }

    function minMax(uint seed, uint rarity) public pure returns(uint) {
        		
        uint output = seed % (6 - 0 + 1) + 0;

        if (rarity == 1) {
            output = seed % (8 - 3 + 1) + 3;
        }
        if (rarity == 2) {
            output = seed % (10 - 5 + 1) + 5;
        }
        if (rarity == 3) {
            output = seed % (12 - 8 + 1) + 9;
        }
        if (rarity == 4) {
            output = seed % (14 - 11 + 1) + 12;
        }

        return output;

    }
    
}
