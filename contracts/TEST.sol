pragma solidity 0.6.12;

import "../helpers/ERC20.sol";



import "../libraries/SafeERC20.sol";
interface ISynapseLP {
    function addLiquidity(
        uint256[] calldata amounts,
        uint256 minToMint,
        uint256 deadline
    ) external;
}
contract Test {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    function earn(uint256 token0Amt, address token0Address) public {
        require(token0Amt > 0, "token0Amt is 0");
        require(IERC20(token0Address).allowance(address(msg.sender),address(this)) > token0Amt, "allowance is less than transfer");
        IERC20(token0Address).safeTransferFrom(
                address(msg.sender),
                address(this),
                token0Amt
            );
        if (token0Amt > 0) {
            IERC20(token0Address).safeIncreaseAllowance(
                0xcEf6C2e20898C2604886b888552CA6CcF66933B0,
                token0Amt
            );
            uint256[] storage amt;
            amt.push(0);
            amt.push(token0Amt);
            amt.push(0);
            //amt[2] = token0Amt;
            //amt[3] = 0;
            uint256 minamt = token0Amt.mul(10**12).mul(499).div(500);
            require(minamt > 0,"minamt = 0");
            ISynapseLP(0xcEf6C2e20898C2604886b888552CA6CcF66933B0).addLiquidity(
                amt,
                minamt,
                block.timestamp.add(600)
            );
        }
    }
}