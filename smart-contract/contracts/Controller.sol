// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./IInstitution.sol";

error ValueCanNotBeZero();
error InvalidAddress();
error InvalidModerator();

contract Controller is Ownable {
    modifier validAddress(address _address) {
        if (_address == address(0) || _address == address(this)) {
            revert InvalidAddress();
        }
        _;
    }

    modifier validInstitutionAddress(address _address) {
        if (_address == address(0) || _address == address(this)) {
            revert InvalidAddress();
        }
        _;
    }

    modifier notZero(uint256 amount) {
        if (amount == 0) {
            revert ValueCanNotBeZero();
        }
        _;
    }

    modifier validModerator(address _address) {
        if (!moderators[_address]) {
            revert InvalidModerator();
        }
        _;
    }

    struct InstitutionInfo {
        address contractAddres;
        string name;
    }

    IInstitution public institutionSc;

    mapping(address => bool) public moderators;

    mapping(uint256 => InstitutionInfo) public InstitutionInfos;

    constructor() {}

    function addSessions(
        uint256 _startTimestamp,
        uint256 _endTimestamp,
        address _scAddress
    ) external validModerator(msg.sender) validAddress(_scAddress) {
        institutionSc = IInstitution(_scAddress);
        institutionSc.addSessions(_startTimestamp, _endTimestamp);
    }

    function addProgram(
        string memory _name,
        uint256 _duration,
        address _scAddress
    ) external validModerator(msg.sender) validAddress(_scAddress) {
        institutionSc = IInstitution(_scAddress);
        institutionSc.addProgram(_name, _duration);
    }

    function addVerifier(address _verifier, address _scAddress)
        external
        validModerator(msg.sender)
        validAddress(_scAddress)
    {
        institutionSc = IInstitution(_scAddress);
        institutionSc.addVerifier(_verifier);
    }

    function removeVerifier(address _verifier, address _scAddress)
        external
        validModerator(msg.sender)
        validAddress(_scAddress)
    {
        institutionSc = IInstitution(_scAddress);
        institutionSc.removeVerifier(_verifier);
    }

    function addModerator(address _moderator)
        external
        onlyOwner
        validAddress(_moderator)
    {
        moderators[_moderator] = true;
    }

    function removeModerator(address _moderator)
        external
        onlyOwner
        validAddress(_moderator)
    {
        moderators[_moderator] = false;
    }
}
