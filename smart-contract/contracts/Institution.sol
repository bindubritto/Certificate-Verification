// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";

error InvalidProgram();
error InvalidSession();
error ApplicationLimitExceeded();

contract Institution is Ownable {
    struct Certificate {
        string Name;
        uint256 Roll;
        uint256 RegistrationNo;
        uint256 SessionId;
        uint256 ProgramId;
        string IpfsUrl;
    }

    struct Application {
        string Name;
        uint256 Roll;
        uint256 RegistrationNo;
        uint256 SessionId;
        uint256 ProgramId;
        string IpfsUrl;
        bool Verified;
    }

    struct Program {
        string Name;
        uint256 Duration;
    }

    struct Session {
        uint256 startTimestamp;
        uint256 endTimestamp;
    }

    address public InstitutionVerifier;
    address payable public InstitutionWallet;

    uint256 public totalProgram = 0;
    uint256 public totalSession = 0;
    uint256 public totalCertificate = 0;
    uint256 public totalApplication = 0;
    
    uint256 public ApplicationperWallet = 10;

    mapping(uint256 => Session) public sessions;

    mapping(uint256 => Application) public applications;

    mapping(uint256 => Program) public programs;

    mapping(address => uint256) public applicationPerWalletMapping;

    constructor() {}

    function applyForCertificate(
        string memory _name,
        uint256 _roll,
        uint256 _registrationNo,
        uint256 _sessionId,
        uint256 _programId,
        string memory _ipfsUrl
    ) external {
        if (_programId < 0 || _programId > totalProgram) {
            revert InvalidProgram();
        }

        if (_programId < 0 || _programId > totalProgram) {
            revert InvalidSession();
        }

        if (applicationPerWalletMapping[msg.sender] == 10) {
            revert ApplicationLimitExceeded();
        }

        applicationPerWalletMapping[msg.sender]++;
        totalApplication++;

        applications[totalApplication] = Application(
            _name,
            _roll,
            _registrationNo,
            _sessionId,
            _programId,
            _ipfsUrl,
            false
        );
    }
}
