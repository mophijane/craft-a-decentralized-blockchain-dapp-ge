pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract vedq_CraftADecentR {
    using SafeMath for uint256;

    // Mapping to store generated dApp details
    mapping (address => dAppDetails) public generatedDApps;

    // Struct to store dApp details
    struct dAppDetails {
        string name;
        string symbol;
        uint256 totalSupply;
        address[] owners;
        mapping (address => uint256) balances;
    }

    // Event emitted when a new dApp is generated
    event NewDAppGenerated(address indexed owner, string name, string symbol, uint256 totalSupply);

    // Function to generate a new decentralized dApp
    function generateDApp(string memory _name, string memory _symbol, uint256 _totalSupply) public {
        require(msg.sender != address(0), "Invalid sender");
        require(_totalSupply > 0, "Total supply should be greater than 0");

        // Create a new dApp details struct
        dAppDetails memory newDApp = dAppDetails(_name, _symbol, _totalSupply, new address[](0));

        // Add the dApp creator as the first owner
        newDApp.owners.push(msg.sender);
        newDApp.balances[msg.sender] = _totalSupply;

        // Store the generated dApp details
        generatedDApps[msg.sender] = newDApp;

        // Emit the NewDAppGenerated event
        emit NewDAppGenerated(msg.sender, _name, _symbol, _totalSupply);
    }

    // Function to add a new owner to an existing dApp
    function addOwnerToDApp(address _dAppOwner, address _newOwner) public {
        require(msg.sender != address(0), "Invalid sender");
        require(generatedDApps[_dAppOwner].owners.length > 0, "dApp does not exist");

        // Add the new owner to the dApp owners array
        generatedDApps[_dAppOwner].owners.push(_newOwner);
    }

    // Function to transfer ownership of a dApp
    function transferDAppOwnership(address _dAppOwner, address _newOwner) public {
        require(msg.sender != address(0), "Invalid sender");
        require(generatedDApps[_dAppOwner].owners.length > 0, "dApp does not exist");

        // Update the dApp owner
        generatedDApps[_newOwner] = generatedDApps[_dAppOwner];
        delete generatedDApps[_dAppOwner];
    }

    // Function to get the details of a generated dApp
    function getDAppDetails(address _dAppOwner) public view returns (string memory, string memory, uint256) {
        require(msg.sender != address(0), "Invalid sender");
        require(generatedDApps[_dAppOwner].owners.length > 0, "dApp does not exist");

        return (generatedDApps[_dAppOwner].name, generatedDApps[_dAppOwner].symbol, generatedDApps[_dAppOwner].totalSupply);
    }
}