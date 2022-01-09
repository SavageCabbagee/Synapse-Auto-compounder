// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "./StratX2_mod.sol";
interface ISynapse {
    function deposit(uint256 pid, uint256 _amount, address to) external;

    function withdraw(uint256 pid, uint256 _amount, address to) external;
}
contract StratX2_Synapses is StratX2_mod {
    constructor(
        address[] memory _addresses,
        uint256 _pid,//1
        bool _isCAKEStaking,//False
        bool _isSameAssetDeposit,//False
        bool _isAutoComp,//True
        address[] memory _earnedToToken0Path,//0x1f1e7c893855525b303f99bdf5c3c05be09ca251,0xb31f66aa3c1e785363f0875a1b74e27b85fd66c7,0xa7d7079b0fead91f3e65f86e8915cb59c1a4c664
        //address[] memory _earnedToToken1Path,
        address[] memory _token0ToEarnedPath,//inverse of above
        //address[] memory _token1ToEarnedPath,
        uint256 _controllerFee,//100
        //uint256 _buyBackRate,
        uint256 _entranceFeeFactor,//9990 
        uint256 _withdrawFeeFactor//10000 
    ) public {
        //wbnbAddress = _addresses[0];//0xb31f66aa3c1e785363f0875a1b74e27b85fd66c7
        govAddress = _addresses[0];//Your gov address
        autoFarmAddress = _addresses[1];//Your Deployed address
        //AUTOAddress = _addresses[3];

        wantAddress = _addresses[2];//LP   0xca87bf3ec55372d9540437d7a86a7750b42c02f4
        token0Address = _addresses[3];//1st token of LP  0xa7d7079b0fead91f3e65f86e8915cb59c1a4c664
        //token1Address = _addresses[5];//2nd token of LP
        earnedAddress = _addresses[4];//yield token  0x1f1e7c893855525b303f99bdf5c3c05be09ca251

        farmContractAddress = _addresses[5];//Masterchef   0x3a01521F8E7F012eB37eAAf1cb9490a5d9e18249
        pid = _pid;
        isCAKEStaking = _isCAKEStaking;
        isSameAssetDeposit = _isSameAssetDeposit;
        isAutoComp = _isAutoComp;

        uniRouterAddress = _addresses[6];//router   0x60aE616a2155Ee3d9A68541Ba4544862310933d4
        //earnedToAUTOPath = _earnedToAUTOPath;
        earnedToToken0Path = _earnedToToken0Path;//swap path
        //earnedToToken1Path = _earnedToToken1Path;//swap path
        token0ToEarnedPath = _token0ToEarnedPath;//swap path
        //token1ToEarnedPath = _token1ToEarnedPath;//swap path

        controllerFee = _controllerFee; 
        rewardsAddress = _addresses[7];//fees address  
        //buyBackRate = _buyBackRate;
        //buyBackAddress = _addresses[11];
        entranceFeeFactor = _entranceFeeFactor;
        withdrawFeeFactor = _withdrawFeeFactor;

        transferOwnership(autoFarmAddress);
    }
    function _farm() internal override {
        uint256 wantAmt = IERC20(wantAddress).balanceOf(address(this));
        wantLockedTotal = wantLockedTotal.add(wantAmt);
        IERC20(wantAddress).safeIncreaseAllowance(farmContractAddress, wantAmt);

        ISynapse(farmContractAddress).deposit(pid, wantAmt,address(this));
    }

    function _unfarm(uint256 _wantAmt) internal override {
        ISynapse(farmContractAddress).withdraw(pid, _wantAmt,address(this));
    }
}
